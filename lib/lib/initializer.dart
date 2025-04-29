import 'dart:async';
import 'dart:io';
import 'package:fife_lab/lib/app_logger.dart';
import 'package:fife_lab/lib/server_process.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

class Initializer {
  Initializer._();

  static Directory? logDir;
  static Directory? projectsDir;
  static String? appLogPath;
  static String? serverLogPath;
  static Completer initialised = Completer();

  static Future<Directory> _createAppDirs(List<String> dir) async {
    final docs = await getLibraryDirectory();

    if (Platform.isMacOS) {
      final appDirPath = p.joinAll([docs.path, ...dir]);
      final appDir = Directory(appDirPath);
      final exists = await appDir.exists();

      if (!exists) {
        await appDir.create(recursive: true);
      }
      return appDir;
    } else if (Platform.isWindows) {
      throw 'Windows is not ready yet';
    } else {
      throw 'Unsupported platform';
    }
  }

  static Future<void> init() async {
    logDir = await _createAppDirs(['Logs', 'FifeLab']);
    projectsDir = await _createAppDirs(['FifeLab', 'Projects']);

    final appLatest = 'app_latest.log';
    final serverLatest = 'server_latest.log';

    assert(logDir != null);
    appLogPath = p.join(logDir!.path, appLatest);
    serverLogPath = p.join(logDir!.path, serverLatest);

    assert(appLogPath != null);
    assert(serverLogPath != null);

    AppLogger.init(
      logPath: logDir!.path,
      latestFileName: appLatest,
    );
    AppLogger.i('Projects located at: ${projectsDir?.path}');

    final serverProcess = ServerProcess(
      logPath: logDir!.path,
      latestFileName: serverLatest,
    );

    await serverProcess.spawn();
    await serverProcess.startServer();
    initialised.complete();
  }
}