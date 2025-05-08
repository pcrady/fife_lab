import 'package:fife_lab/functions/convex_hull/convex_hull.dart';
import 'package:fife_lab/functions/fife_lab_function.dart';
import 'package:fife_lab/functions/general/general.dart';
import 'package:fife_lab/lib/app_logger.dart';
import 'package:fife_lab/providers/watchers/project_watcher.dart';
import 'package:fife_lab/providers/settings.dart';
import 'package:fife_lab/providers/watchers/server_watcher.dart';
import 'package:fife_lab/providers/watchers/worker_watcher.dart';
import 'package:fife_lab/widgets/fife_lab_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MainScreen extends ConsumerStatefulWidget {
  static const route = '/';

  const MainScreen({super.key});

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  bool locked = true;

  @override
  void initState() {
    ref.listenManual(
      serverWatcherProvider.future,
      (previous, next) async {
        final serverIsUp = await next;
        final shouldLock = !serverIsUp;

        if (shouldLock != locked) {
          setState(() => locked = shouldLock);
        }
      },
      fireImmediately: true,
    );

    ref.listenManual(
      workerWatcherProvider.future,
      (previous, next) async {
        final workerIsUp = await next;
        final shouldLock = !workerIsUp;

        if (shouldLock != locked) {
          setState(() => locked = shouldLock);
        }
      },
      fireImmediately: true,
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _MainScreenContent(locked: locked);
  }
}

class _MainScreenContent extends ConsumerStatefulWidget {
  final bool locked;

  const _MainScreenContent({
    this.locked = false,
  });

  @override
  ConsumerState createState() => __MainScreenContentState();
}

class __MainScreenContentState extends ConsumerState<_MainScreenContent> {
  @override
  Widget build(BuildContext context) {
    final settingsModel = ref.watch(settingsProvider).when(
          data: (data) => data,
          error: (_, __) => null,
          loading: () => null,
        );

    final event = ref.watch(projectWatcherProvider).when(
          data: (data) => data,
          error: (err, stack) {
            AppLogger.e(err, stackTrace: stack);
            return null;
          },
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
              body: switch (settingsModel?.function) {
                null => Container(),
                FifeLabFunction.general => General(),
                FifeLabFunction.convexHull => ConvexHull(),
              },
              bottomNavigationBar: Container(
                color: Theme.of(context).appBarTheme.backgroundColor,
                height: 40,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Project Path: ${settingsModel?.projectPath ?? 'None'}'),
                      switch (event) {
                        null => Container(),
                        ProjectStatus.healthy => Text(
                            'Healthy',
                            style: TextStyle(color: Colors.greenAccent),
                          ),
                        ProjectStatus.noProjectSelected => Text(
                            'No Project Selected',
                            style: TextStyle(color: Colors.yellow),
                          ),
                        ProjectStatus.projectsDirNotFound => Text(
                            'Projects Directory Not Found',
                            style: TextStyle(color: Colors.red),
                          ),
                        ProjectStatus.projectNotFound => Text(
                            'Project Not Found',
                            style: TextStyle(color: Colors.red),
                          ),
                      }
                    ],
                  ),
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
