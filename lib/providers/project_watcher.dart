import 'dart:async';
import 'dart:io';
import 'package:fife_lab/lib/app_logger.dart';
import 'package:fife_lab/models/settings_model.dart';
import 'package:fife_lab/providers/settings.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:rxdart/rxdart.dart';

part 'project_watcher.g.dart';

enum FifeLabEvent {
  projectDirNotFound,
  projectDirGood,
  projectsDirNotFound,
  projectsDirGood,
}

@riverpod
class ProjectWatcher extends _$ProjectWatcher {
  @override
  Stream<FifeLabEvent> build() async* {
    final settings = await ref.watch(settingsProvider.future);
    AppLogger.i('building ----------------');

    if (await settings.projectDirExists) {
      yield FifeLabEvent.projectDirGood;
    } else {
      yield FifeLabEvent.projectDirNotFound;
      return;
    }

    if (await settings.projectsDirExists) {
      yield FifeLabEvent.projectsDirGood;
    } else {
      yield FifeLabEvent.projectsDirNotFound;
      return;
    }

    final projectPath = settings.projectPath;
    final projectsPath = settings.projectsPath;

    assert(projectPath != null);
    assert(projectsPath != null);

    if (projectPath == null) {
      throw 'projectPath is null. This should not be possible';
    }

    if (projectsPath == null) {
      throw 'projectsPath is null. This should not be possible';
    }

    final projectEvents = _projectFifeLabEventStream(
      stream: Directory(projectPath).watch(recursive: true),
      settingsModel: settings,
    );
    final projectsEvents = _projectsFifeLabEventStream(
      stream: Directory(projectsPath).watch(),
      settingsModel: settings,
    );

    yield* MergeStream([projectEvents, projectsEvents]);
  }

  Stream<FifeLabEvent> _projectFifeLabEventStream({
    required Stream<FileSystemEvent> stream,
    SettingsModel? settingsModel,
  }) async* {
    await for (final event in stream) {
      if (settingsModel != null) {
        switch (event) {
          case FileSystemCreateEvent _:
            break;
          case FileSystemModifyEvent _:
            break;
          case FileSystemDeleteEvent _:
            {
              final settings = ref.read(settingsProvider.notifier);
              if (event.path == settingsModel.projectPath) {
                assert(settingsModel.projectsPath != null); // maybe problematic
                settings.setProject(
                  projectsPath: settingsModel.projectsPath,
                  projectName: null,
                );
                yield FifeLabEvent.projectDirNotFound;
              }
            }
            break;
          case FileSystemMoveEvent _:
            break;
        }
      }
    }
  }

  Stream<FifeLabEvent> _projectsFifeLabEventStream({
    required Stream<FileSystemEvent> stream,
    SettingsModel? settingsModel,
  }) async* {
    await for (final event in stream) {
      if (settingsModel != null) {
        if (event is FileSystemDeleteEvent) {
          final settings = ref.read(settingsProvider.notifier);
          if (event.path == settingsModel.projectsPath) {
            settings.setProject(
              projectsPath: null,
              projectName: null,
            );
            AppLogger.f('YYYYY');
            yield FifeLabEvent.projectsDirNotFound;
          }
        }
      }
    }
  }
}
