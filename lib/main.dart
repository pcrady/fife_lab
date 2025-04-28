import 'package:fife_lab/lib/app_logger.dart';
import 'package:fife_lab/lib/initializer.dart';
import 'package:fife_lab/providers/server_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'screens/main_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Initializer.init();

  runApp(
    ProviderScope(
      child: FifeLab(),
    ),
  );
}

class FifeLab extends StatelessWidget {
  const FifeLab({super.key});

  @override
  Widget build(BuildContext context) {
    return _EagerInitialization(
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const MyHomePage(title: 'Flutter Demo Home Page'),
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
