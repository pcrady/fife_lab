import 'dart:async';
import 'dart:io';
import 'dart:isolate';
import 'package:fife_lab/lib/app_logger.dart';
import 'package:fife_lab/providers/worker_watcher.dart';
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

    final serverExecutable = File(path.join(projectDir.path, relativePythonPath));
    assert(serverExecutable.existsSync());

    final args = ServerProcessArgs(
      serverExecutable: serverExecutable,
      serverArgs: [runServerExecPath],
      logPath: logPath,
      latestFileName: latestFileName,
    );

    return args;
  }

  static void _annotateData(String data) {
    data = data.trim();
    data = data.replaceAll('\n', '');
    data = data.replaceAll('MAIN pid:', '\nMAIN pid:');
    data = data.replaceAll('WORKER pid:', '\nWORKER pid:');
    data = data.replaceAll('WEB_SERVER pid:', '\nWEB_SERVER pid:');
    data = data.replaceAll('CONTROL_SERVER pid:', '\nCONTROL_SERVER pid:');
    AppLogger.i(data.replaceFirst('\n', ''));
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

        while (true) {
          if (await WorkerWatcher.workerIsUp()) {
            AppLogger.w('Server is already running. Cancelling process.');
            break;
          }

          final process = await Process.start(
            args.serverExecutable.path,
            args.serverArgs,
          );

          final streams = [process.stdout, process.stderr];
          for (final stream in streams) {
            stream.transform(utf8.decoder).listen((data) {
              _annotateData(data);
            });
          }

          final exitCode = await process.exitCode;
          port.send(exitCode);
          break;
        }
      }
    });
  }

  void _handleResponsesFromIsolate(dynamic message) async {
    if (message is SendPort) {
      _mainSendPort = message;
      _isolateReady.complete();
    } else if (message is int) {
      AppLogger.f('Exit Code: $message \nRestarting Server');
      await Future.delayed(Duration(milliseconds: 200));
      await startServer();
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
