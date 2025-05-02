import 'dart:async';
import 'dart:io';
import 'package:fife_lab/lib/app_logger.dart';
import 'package:fife_lab/providers/settings.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'project_watcher.g.dart';

enum ProjectStatus {
  healthy,
  noSelection,
  notFound,
}

@riverpod
class ProjectWatcher extends _$ProjectWatcher {
  @override
  Stream<ProjectStatus> build() async* {
    final settings = await ref.watch(settingsProvider.future);
    final projectDirExists = await settings.projectDirExists;
    final projectPath = settings.projectPath;
    final projectsPath = settings.projectsPath;

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

    final eventStream = Directory(projectsPath).watch(recursive: true);
    yield* _projectsFifeLabEventStream(stream: eventStream);
  }

  Stream<ProjectStatus> _projectsFifeLabEventStream({
    required Stream<FileSystemEvent> stream,
  }) async* {
    await for (final event in stream) {
      switch (event) {
        case FileSystemCreateEvent _:
          break;
        case FileSystemModifyEvent _:
          break;
        case FileSystemDeleteEvent _:
          {
            final settingsModel = await ref.read(settingsProvider.future);
            final settings = ref.read(settingsProvider.notifier);

            if (event.path == settingsModel.projectPath) {
              await settings.setProject(
                projectsPath: settingsModel.projectsPath,
                projectName: null,
              );
              yield ProjectStatus.notFound;
            } else if (event.path == settingsModel.projectsPath) {
              await settings.setProject(
                projectsPath: null,
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

    AppLogger.e('DONE');
    await ref.read(settingsProvider.notifier).setProject(
      projectsPath: null,
      projectName: null,
    );
    yield ProjectStatus.notFound;
  }
}
