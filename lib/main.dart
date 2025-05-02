import 'package:fife_lab/lib/fife_lab_router.dart';
import 'package:fife_lab/lib/initializer.dart';
import 'package:fife_lab/models/settings_model.dart';
import 'package:fife_lab/providers/project_watcher.dart';
import 'package:fife_lab/providers/server_controller.dart';
import 'package:fife_lab/providers/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Initializer.init();

  runApp(
    ProviderScope(
      child: FifeLab(),
    ),
  );
}

class FifeLab extends ConsumerWidget with FifeLabRouter {
  FifeLab({super.key});

  static const unselectedColor = Colors.white54;

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
          ColorTheme.dark => ThemeData(
            useMaterial3: true,
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurpleAccent),
              elevatedButtonTheme: ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.green,
                ),
              ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  foregroundColor: Colors.green,
                ),
              ),
              outlinedButtonTheme: OutlinedButtonThemeData(
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.green,
                ),
              ),
              appBarTheme: const AppBarTheme(
                color: Color(0xff1f004a),
                foregroundColor: Colors.white,
              ),
              scaffoldBackgroundColor: const Color(0xff101418),
              inputDecorationTheme: const InputDecorationTheme(
                suffixIconColor: Colors.greenAccent,
                isDense: true,
                border: OutlineInputBorder(),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                ),
                labelStyle: TextStyle(color: unselectedColor),
                hintStyle: TextStyle(color: unselectedColor),
              ),
              dialogTheme: DialogTheme(
                backgroundColor: Color(0xFF1e112b),
                titleTextStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 24.0,
                ),
                contentTextStyle: TextStyle(
                  color: Colors.white,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              textTheme: const TextTheme(
                bodyLarge: TextStyle(color: Colors.white),
                bodyMedium: TextStyle(color: Colors.white),
                bodySmall: TextStyle(color: Colors.white),
              ),
              iconTheme: const IconThemeData(
                color: Colors.green,
              ),
            ),
          ColorTheme.light => ThemeData(
              appBarTheme: const AppBarTheme(
                color: Color(0xff1f004a),
                foregroundColor: Colors.white,
              ),
              inputDecorationTheme: const InputDecorationTheme(
                isDense: true,
                border: OutlineInputBorder(),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                ),
              ),
              useMaterial3: true,
            ),
        },
        routerConfig: router,
      ),
    );
  }
}

class _EagerInitialization extends ConsumerWidget {
  final Widget child;

  const _EagerInitialization({
    required this.child,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(serverControllerProvider);
    ref.watch(settingsProvider);
    ref.watch(projectWatcherProvider);
    return child;
  }
}
