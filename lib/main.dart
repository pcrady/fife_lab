import 'package:fife_lab/lib/fife_lab_router.dart';
import 'package:fife_lab/lib/initializer.dart';
import 'package:fife_lab/models/settings_model.dart';
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
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurpleAccent),
              elevatedButtonTheme: ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                ),
              ),
              appBarTheme: const AppBarTheme(
                color: Color(0xff1f004a),
                foregroundColor: Colors.white,
              ),
              scaffoldBackgroundColor: const Color(0xff101418),
              buttonTheme: const ButtonThemeData(
                buttonColor: Colors.deepPurple,
                textTheme: ButtonTextTheme.primary,
              ),
              inputDecorationTheme: const InputDecorationTheme(
                suffixIconColor: Colors.greenAccent,
                isDense: true,
                border: OutlineInputBorder(), // Default border
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                ),
                labelStyle: TextStyle(color: unselectedColor),
                hintStyle: TextStyle(color: unselectedColor),
                //focusColor: Colors.blue,
              ),
              dialogTheme: DialogTheme(
                backgroundColor: Colors.white12,
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
                bodyLarge: TextStyle(color: Colors.white), // for Text()
                bodyMedium: TextStyle(color: Colors.white), // for e.g. smaller text
                bodySmall: TextStyle(color: Colors.white),
              ),
              iconTheme: const IconThemeData(
                color: Colors.green,
              ),
              useMaterial3: true,
            ),
          ColorTheme.light => ThemeData(
              appBarTheme: const AppBarTheme(
                color: Color(0xff1f004a),
                foregroundColor: Colors.white,
              ),
              inputDecorationTheme: const InputDecorationTheme(
                //contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                isDense: true,
                border: OutlineInputBorder(), // Default border
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
    return child;
  }
}
