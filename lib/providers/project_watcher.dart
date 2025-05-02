import 'dart:async';
import 'dart:io';
import 'package:fife_lab/lib/app_logger.dart';
import 'package:fife_lab/models/settings_model.dart';
import 'package:fife_lab/providers/settings.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:rxdart/rxdart.dart';

part 'project_watcher.g.dart';

enum ProjectStatus {
  healthy,
  noSelection,
  notFound,
}

@riverpod
class ProjectWatcher extends _$ProjectWatcher {
  StreamSubscription<ProjectStatus>? _projectEventSubscription;
  StreamSubscription<ProjectStatus>? _projectEventsSubscription;

  @override
  Stream<ProjectStatus> build() async* {
    final settings = await ref.watch(settingsProvider.future);
    AppLogger.e(settings.toJson());

    final projectDirExists = await settings.projectDirExists;
    final projectPath =  settings.projectPath;
    final projectsPath =  settings.projectsPath;

    if (!projectDirExists && projectPath != null) {
      yield ProjectStatus.notFound;
      return;
    }

    if (projectDirExists && projectPath != null) {
      yield ProjectStatus.healthy;
    }

    if (projectPath == null) {
      yield ProjectStatus.noSelection;
      return;
    }

    if (projectsPath == null) {
      yield ProjectStatus.noSelection;
      return;
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

  Stream<ProjectStatus> _projectFifeLabEventStream({
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
                AppLogger.f(settingsModel.toJson());
                await settings.setProject(
                  projectsPath: settingsModel.projectsPath,
                  projectName: null,
                );
                yield ProjectStatus.notFound;
              }
            }
            break;
          case FileSystemMoveEvent _:
            break;
        }
      }
    }
  }

  Stream<ProjectStatus> _projectsFifeLabEventStream({
    required Stream<FileSystemEvent> stream,
    SettingsModel? settingsModel,
  }) async* {
    await for (final event in stream) {
      if (settingsModel != null) {
        if (event is FileSystemDeleteEvent) {
          final settings = ref.read(settingsProvider.notifier);
          if (event.path == settingsModel.projectsPath) {
            await settings.setProject(
              projectsPath: null,
              projectName: null,
            );
          }
        }
      }
    }
  }
}
