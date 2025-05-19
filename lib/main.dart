import 'dart:ui';
import 'package:dio/dio.dart';
import 'package:fife_lab/constants.dart';
import 'package:fife_lab/lib/app_logger.dart';
import 'package:fife_lab/lib/fife_lab_router.dart';
import 'package:fife_lab/lib/fife_lab_themes.dart';
import 'package:fife_lab/lib/initializer.dart';
import 'package:fife_lab/models/settings_model.dart';
import 'package:fife_lab/providers/watchers/project_watcher.dart';
import 'package:fife_lab/providers/settings.dart';
import 'package:fife_lab/providers/watchers/server_watcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';

void main() async {
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      await Initializer.init();

      FlutterError.onError = (FlutterErrorDetails details) {
        AppLogger.e(details.toString());
        FlutterError.dumpErrorToConsole(details);
      };

      PlatformDispatcher.instance.onError = (Object error, StackTrace stack) {
        AppLogger.e(error, stackTrace: stack);
        return true;
      };

      runApp(
        ProviderScope(
          child: FifeLab(),
        ),
      );
    },
    (err, stack) {
      AppLogger.e(err, stackTrace: stack);
    },
  );
}

class FifeLab extends ConsumerWidget with FifeLabRouter {
  FifeLab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsData = ref.watch(settingsProvider);

    final theme = settingsData.when(
      data: (settings) => settings.theme,
      error: (_, __) => ColorTheme.dark,
      loading: () => ColorTheme.dark,
    );

    return _EagerInitialization(
      child: MaterialApp.router(
        title: 'Fife Image',
        theme: switch (theme) {
          ColorTheme.dark => darkTheme,
          ColorTheme.light => lightTheme,
        },
        routerConfig: router,
      ),
    );
  }
}

class _EagerInitialization extends ConsumerStatefulWidget {
  final Widget child;

  const _EagerInitialization({
    required this.child,
  });

  @override
  ConsumerState<_EagerInitialization> createState() => _EagerInitializationState();
}

class _EagerInitializationState extends ConsumerState<_EagerInitialization> {
  @override
  void initState() {
    ref.listenManual(
      settingsProvider.future,
      (previous, next) async {
        final settingsModel = await next;
        final dio = Dio(BaseOptions(baseUrl: kServer));
        try {
          await dio.post(
            '/config',
            data: {'project_path': settingsModel.projectPath},
          );
        } catch (err, stack) {
          AppLogger.e(err, stackTrace: stack);
        }
      },
      fireImmediately: true,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(serverWatcherProvider);
    ref.watch(settingsProvider);
    ref.watch(projectWatcherProvider);
    return widget.child;
  }
}
