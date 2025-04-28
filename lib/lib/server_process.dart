import 'dart:async';
import 'dart:io';
import 'dart:isolate';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as path;
import 'dart:convert';


class SubprocessArgs {
  File serverExecutable;
  List<String> serverArgs;

  SubprocessArgs({
    required this.serverExecutable,
    required this.serverArgs,
  });
}

class Worker {
  late SendPort _mainSendPort;
  final Completer<void> _isolateReady = Completer.sync();
  bool serverStarted = false;

  SubprocessArgs _getSubprocessArgs() {
    final flutterExecutable = File(Platform.resolvedExecutable);
    late String runServerExecPath;
    late Directory projectDir;
    late String relativePythonPath;

    if (kDebugMode || kProfileMode) {
      projectDir = flutterExecutable.parent.parent.parent.parent.parent.parent.parent.parent.parent;
      relativePythonPath = 'server/test_env/bin/python';
      runServerExecPath = path.join(projectDir.path, 'server/run_server.py');
    } else {
      projectDir = flutterExecutable.parent.parent;
      relativePythonPath = 'Resources/server/test_env/bin/python';
      runServerExecPath = path.join(projectDir.path, 'Resources/server/run_server.py');
    }

    final args = SubprocessArgs(
      serverExecutable: File(path.join(projectDir.path, relativePythonPath)),
      serverArgs: [runServerExecPath],
    );

    return args;
  }

  static void _isolate(SendPort port) {
    final isolateReceivePort = ReceivePort();
    port.send(isolateReceivePort.sendPort);

    isolateReceivePort.listen((dynamic args) async {
      if (args is SubprocessArgs) {
        int retries = 0;
        const maxRetries = 10;
        const retryDelay = Duration(milliseconds: 500);

        while (retries < maxRetries) {
          final process = await Process.start(
            args.serverExecutable.path,
            args.serverArgs,
          );

          bool addressInUse = false;
          process.stdout.transform(utf8.decoder).listen((data) {
            data = data.replaceAll("\n", '');
            data = data.replaceAll('main pid:', '\nmain pid:');
            data = data.replaceAll('worker pid:', '\nworker pid:');

            print(data);
            if (data.contains('Address already in use')) {
              addressInUse = true;
            }
          });

          process.stderr.transform(utf8.decoder).listen((data) {
            data = data.replaceAll("\n", '');
            data = data.replaceAll('main pid:', '\nmain pid:');
            data = data.replaceAll('worker pid:', '\nworker pid:');

            print(data);
            if (data.contains('Address already in use')) {
              addressInUse = true;
            }
          });

          final exitCode = await process.exitCode;
          if (!addressInUse) {
            port.send(true);
            port.send(exitCode);
            break;
          } else {
            retries += 1;
            print('Retrying server start... attempt $retries');
            await Future.delayed(retryDelay);
          }
        }

        if (retries >= maxRetries) {
          port.send(false);
        }
      }
    });
  }

  void _handleResponsesFromIsolate(dynamic message) {
    if (message is SendPort) {
      _mainSendPort = message;
      _isolateReady.complete();
    } else if (message is bool) {
      serverStarted = message;
    } else {
      print(message);
    }
  }

  Future<void> spawn() async {
    final mainReceivePort = ReceivePort();
    mainReceivePort.listen(_handleResponsesFromIsolate);
    await Isolate.spawn(_isolate, mainReceivePort.sendPort);
  }

  // sends message to isolate
  Future<void> startServer() async {
    await _isolateReady.future;
    final args = _getSubprocessArgs();
    _mainSendPort.send(args);
  }
}
