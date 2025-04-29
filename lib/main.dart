import 'package:fife_lab/lib/fife_lab_router.dart';
import 'package:fife_lab/lib/initializer.dart';
import 'package:fife_lab/providers/server_controller.dart';
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

class FifeLab extends StatelessWidget with FifeLabRouter {
  FifeLab({super.key});

  static const unselectedColor = Colors.white54;

  @override
  Widget build(BuildContext context) {
    return _EagerInitialization(
      child: MaterialApp.router(
        title: 'Fife Image',
        theme: ThemeData(
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
          textTheme: Theme.of(context).textTheme.apply(
                bodyColor: Colors.white,
                displayColor: Colors.white,
              ),
          scaffoldBackgroundColor: const Color(0xff101418),
          buttonTheme: const ButtonThemeData(
            buttonColor: Colors.deepPurple,
            textTheme: ButtonTextTheme.primary,
          ),
          inputDecorationTheme: const InputDecorationTheme(
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blue),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: unselectedColor),
            ),
            labelStyle: TextStyle(color: unselectedColor),
            hintStyle: TextStyle(color: unselectedColor),
            focusColor: Colors.blue,
          ),
          useMaterial3: true,
        ),
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
