import 'dart:async';
import 'dart:io';
import 'package:fife_lab/lib/app_logger.dart';
import 'package:fife_lab/models/settings_model.dart';
import 'package:fife_lab/providers/settings.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:rxdart/rxdart.dart';

part 'project_watcher.g.dart';

@riverpod
class ProjectWatcher extends _$ProjectWatcher {
  StreamSubscription<FileSystemEvent>? _projectsSub;
  StreamSubscription<FileSystemEvent>? _projectSub;

  @override
  Stream<FileSystemEvent> build() {
    final settingsAsync = ref.watch(settingsProvider);
    SettingsModel? settingsModel;

    late Stream<FileSystemEvent> projectDirStream;
    late Stream<FileSystemEvent> projectsDirStream;

    settingsAsync.when(
      data: (data) {
        settingsModel = data;
        final projectPath = data.projectPath;
        projectDirStream = (projectPath == null) ? Stream.empty() : Directory(projectPath).watch(recursive: true);

        final projectsPath = data.projectsPath;
        projectsDirStream = (projectsPath == null) ? Stream.empty() : Directory(projectsPath).watch();
      },
      loading: () => Stream.empty(),
      error: (_, __) => Stream.empty(),
    );

    _projectSub?.cancel();
    _projectsSub?.cancel();

    _projectSub = _listenProjectDir(stream: projectDirStream, settingsModel: settingsModel);
    _projectsSub = _listenProjectsDir(stream: projectsDirStream, settingsModel: settingsModel);

    ref.onDispose(() {
      _projectSub?.cancel();
      _projectsSub?.cancel();
    });

    return MergeStream([projectDirStream, projectsDirStream]);
  }

  StreamSubscription<FileSystemEvent> _listenProjectDir({
    required Stream<FileSystemEvent> stream,
    SettingsModel? settingsModel,
  }) {
    return stream.listen((event) {
      if (settingsModel != null) {
        switch (event) {
          case FileSystemCreateEvent():
            break;
          case FileSystemModifyEvent():
            break;
          case FileSystemDeleteEvent():
            {
              final settings = ref.read(settingsProvider.notifier);
              if (event.path == settingsModel.projectPath) {
                assert(settingsModel.projectsPath != null);
                AppLogger.w(event);
                settings.setProject(
                  projectsPath: settingsModel.projectsPath,
                  projectName: null,
                );
              }
            }
            break;
          case FileSystemMoveEvent():
            break;
        }
      }
    });
  }

  StreamSubscription<FileSystemEvent> _listenProjectsDir({
    required Stream<FileSystemEvent> stream,
    SettingsModel? settingsModel,
  }) {
    return stream.listen((event) {
      if (settingsModel != null) {
        if (event is FileSystemDeleteEvent) {
          final settings = ref.read(settingsProvider.notifier);
          if (event.path == settingsModel.projectsPath) {
            AppLogger.f(event);
            settings.setProject(
              projectsPath: null,
              projectName: null,
            );
          }
        }
      }
    });
  }
}
