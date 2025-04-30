import 'package:fife_lab/lib/app_logger.dart';
import 'package:fife_lab/providers/server_controller.dart';
import 'package:fife_lab/providers/settings.dart';
import 'package:fife_lab/widgets/fife_lab_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MainScreen extends ConsumerWidget {
  static const route = '/';

  const MainScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final serverControllerData = ref.watch(serverControllerProvider);

    return serverControllerData.when(
      data: (data) => data ? _MainScreenContent() : _MainScreenContent(locked: true),
      error: (err, stack) {
        AppLogger.e(err, stackTrace: stack);
        return _MainScreenContent(locked: true);
      },
      loading: () => _MainScreenContent(locked: true),
    );
  }
}

class _MainScreenContent extends ConsumerStatefulWidget {
  final bool locked;

  const _MainScreenContent({
    this.locked = false,
    super.key,
  });

  @override
  ConsumerState createState() => __MainScreenContentState();
}

class __MainScreenContentState extends ConsumerState<_MainScreenContent> {
  @override
  Widget build(BuildContext context) {
    final settingsData = ref.watch(settingsProvider);
    final settings = settingsData.when(
      data: (data) => data,
      error: (_, __) => null,
      loading: () => null,
    );

    return Stack(
      children: [
        Opacity(
          opacity: widget.locked ? 0.5 : 1.0,
          child: IgnorePointer(
            ignoring: widget.locked,
            child: Scaffold(
              appBar: FifeLabAppBar(),
              body: Container(),
              bottomNavigationBar: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Text(settings?.projectsDirPath ?? 'None'),
                  ],
                ),
              ),
            ),
          ),
        ),
        switch (widget.locked) {
          true => Material(
              type: MaterialType.transparency,
              child: Container(
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Connecting To Sever..'),
                    SizedBox(height: 8.0),
                    SizedBox(width: 200, child: LinearProgressIndicator()),
                  ],
                ),
              ),
            ),
          false => Container(),
        },
      ],
    );
  }
}
