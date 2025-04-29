import 'dart:async';
import 'dart:io';
import 'package:fife_lab/lib/app_logger.dart';
import 'package:fife_lab/lib/server_process.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

class Initializer {
  Initializer._();

  static Directory? logDir;
  static String? appLogPath;
  static String? serverLogPath;
  static Completer initialised = Completer();

  static Future<void> init() async {
    final docs = await getLibraryDirectory();
    late String logDirPath;

    if (Platform.isMacOS) {
      logDirPath = p.join(docs.path, 'Logs', 'FifeLab');

      logDir = Directory(logDirPath);
      assert(logDir != null);

      final exists = await logDir!.exists();

      if (!exists) {
        await logDir!.create(recursive: true);
      }
    } else if (Platform.isWindows) {
      throw 'Windows is not ready yet';
    } else {
      throw 'Unsupported platform';
    }

    final appLatest = 'app_latest.log';
    final serverLatest = 'server_latest.log';

    appLogPath = p.join(logDirPath, appLatest);
    serverLogPath = p.join(logDirPath, serverLatest);

    assert(appLogPath != null);
    assert(serverLogPath != null);

    AppLogger.init(
      logPath: logDirPath,
      latestFileName: appLatest,
    );

    final serverProcess = ServerProcess(
      logPath: logDirPath,
      latestFileName: serverLatest,
    );

    await serverProcess.spawn();
    await serverProcess.startServer();
    initialised.complete();
  }
}