import 'dart:io';

import 'package:fife_lab/lib/app_logger.dart';
import 'package:fife_lab/providers/project_watcher.dart';
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
    final settingsModel = ref.watch(settingsProvider).when(
          data: (data) => data,
          error: (_, __) => null,
          loading: () => null,
        );

    final event = ref.watch(projectWatcherProvider).when(
          data: (data) => data,
          error: (err, stack) {
            AppLogger.f(err, stackTrace: stack);
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
              body: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Project Path:  ${settingsModel?.projectPath ?? 'NONE'}'),
                  Text('Projects Path: ${settingsModel?.projectsPath ?? 'NONE'}'),
                  Container(
                    height: 200,
                    width: 200,
                    color: Colors.red,
                  ),
                  TextButton(
                    onPressed: () async {
                      final fuck = await ref.read(settingsProvider.future);
                      AppLogger.i(fuck.toJson());
                    },
                    child: Text('check state'),
                  ),
                ],
              ),
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
                        ProjectStatus.noProjectSelected => Text('No Project Selected'),
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
