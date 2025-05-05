import 'dart:async';
import 'package:fife_lab/providers/settings.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'project_watcher.g.dart';

enum ProjectStatus {
  healthy,
  projectNotFound,
  projectsDirNotFound,
  noProjectSelected,
}

@riverpod
class ProjectWatcher extends _$ProjectWatcher {
  @override
  Stream<ProjectStatus> build() async* {
    yield* _projectDirectoryPoller();
  }

  Stream<ProjectStatus> _projectDirectoryPoller() async* {
    while (true) {
      await Future.delayed(const Duration(seconds: 1));
      final settings = await ref.watch(settingsProvider.future);
      final projectPath = settings.projectPath;
      final projectsPath = settings.projectsPath;
      final projectDirExists = await settings.projectDirExists;
      final projectsDirExists = await settings.projectsDirExists;

      if (!projectsDirExists && projectsPath != null) {
        yield ProjectStatus.projectsDirNotFound;
      } else if (!projectDirExists && projectPath != null) {
        yield ProjectStatus.projectNotFound;
      } else if (projectPath == null || projectsPath == null) {
        yield ProjectStatus.noProjectSelected;
      } else {
        yield ProjectStatus.healthy;
      }
    }
  }
}
