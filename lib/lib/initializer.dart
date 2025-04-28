import 'dart:async';
import 'dart:io';
import 'package:fife_lab/lib/app_logger.dart';
import 'package:fife_lab/lib/server_process.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

class Initializer {
  Initializer._();

  static Future<void> init() async {
    final docs = await getLibraryDirectory();
    late String logDirPath;

    if (Platform.isMacOS) {
      logDirPath = p.join(docs.path, 'Logs', 'FifeLab');
      final logDir = Directory(logDirPath);
      final exists = await logDir.exists();

      if (!exists) {
        await logDir.create(recursive: true);
      }
    } else if (Platform.isWindows) {
      throw 'Windows is not ready yet';
    } else {
      throw 'Unsupported platform';
    }

    AppLogger.init(
      logPath: logDirPath,
      latestFileName: 'app_latest.log',
    );

    final serverProcess = ServerProcess(
      logPath: logDirPath,
      latestFileName: 'server_latest.log',
    );

    await serverProcess.spawn();
    await serverProcess.startServer();
  }
}