import 'dart:async';
import 'dart:io';
import 'package:fife_lab/lib/app_logger.dart';
import 'package:fife_lab/providers/settings.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'project_watcher.g.dart';

@riverpod
class ProjectWatcher extends _$ProjectWatcher {
  @override
  Stream<FileSystemEvent> build() {
    final settingsData = ref.watch(settingsProvider);
    return settingsData.when(
      data: (settingsModel)  {
        final projectDir = settingsModel.currentProjectDir;
        if (projectDir == null) {
          AppLogger.w('No project directory detected');
          return Stream.empty();
        }
        final eventStream = projectDir.watch();
        eventStream.listen((event) {
          AppLogger.f(event);
          // Todo we need to validate if the directory becomes invalid
          // We also need to nullify the project directory if it gets deleted
          // and we need to nulify the projectS directory if it gets deleted
        });

        return eventStream;
      },
      error: (err, stack) {
        AppLogger.e(err, stackTrace: stack);
        return const Stream.empty();
      },
      loading: () {
        return const Stream.empty();
      },
    );
  }
}
