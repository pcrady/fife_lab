import 'dart:async';
import 'dart:io';
import 'dart:isolate';
import 'package:fife_lab/lib/app_logger.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import 'package:path/path.dart' as path;
import 'dart:convert';

class ServerProcessArgs {
  final File serverExecutable;
  final List<String> serverArgs;
  final String latestFileName;
  final String logPath;

  ServerProcessArgs({
    required this.serverExecutable,
    required this.serverArgs,
    required this.latestFileName,
    required this.logPath,
  });
}

class ServerProcess {
  final String latestFileName;
  final String logPath;

  ServerProcess({
    required this.latestFileName,
    required this.logPath,
  });

  late SendPort _mainSendPort;
  final Completer<void> _isolateReady = Completer.sync();
  bool serverStarted = false;

  ServerProcessArgs _getSubprocessArgs() {
    final flutterExecutable = File(Platform.resolvedExecutable);
    late String runServerExecPath;
    late Directory projectDir;
    late String relativePythonPath;

    if (kDebugMode || kProfileMode) {
      projectDir = flutterExecutable.parent.parent.parent.parent.parent.parent.parent.parent.parent;
      relativePythonPath = 'server/fife_lab_env/bin/python';
      runServerExecPath = path.join(projectDir.path, 'server/run_server.py');
    } else {
      projectDir = flutterExecutable.parent.parent;
      relativePythonPath = 'Resources/server/fife_lab_env/bin/python';
      runServerExecPath = path.join(projectDir.path, 'Resources/server/run_server.py');
    }

    final args = ServerProcessArgs(
      serverExecutable: File(path.join(projectDir.path, relativePythonPath)),
      serverArgs: [runServerExecPath],
      logPath: logPath,
      latestFileName: latestFileName,
    );

    return args;
  }

  static void _annotateData(String data) {
    data = data.replaceAll("\n", '');
    data = data.replaceAll('main pid:', '\nmain pid:');
    data = data.replaceAll('worker pid:', '\nworker pid:');
    AppLogger.i(data);
  }

  static bool _checkIfAddressInUse(String data) {
    return data.contains('address already in use') ? true : false;
  }

  static void _isolate(SendPort port) async {
    final isolateReceivePort = ReceivePort();
    port.send(isolateReceivePort.sendPort);

    isolateReceivePort.listen((dynamic args) async {
      if (args is ServerProcessArgs) {
        AppLogger.init(
          logPath: args.logPath,
          latestFileName: args.latestFileName,
          infoColor: AnsiColor.fg(083),
        );

        int retries = 0;
        const maxRetries = 10;
        const retryDelay = Duration(milliseconds: 500);

        while (retries < maxRetries) {
          final process = await Process.start(
            args.serverExecutable.path,
            args.serverArgs,
          );

          bool addressInUse = false;
          final streams = [process.stdout, process.stderr];
          for (final stream in streams) {
            stream.transform(utf8.decoder).listen((data) {
              _annotateData(data);
              addressInUse = _checkIfAddressInUse(data);
            });
          }

          final exitCode = await process.exitCode;
          if (!addressInUse) {
            port.send(true);
            port.send(exitCode);
            break;
          } else {
            retries += 1;
            AppLogger.i('Retrying server start... attempt $retries');
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
      AppLogger.i(message);
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
