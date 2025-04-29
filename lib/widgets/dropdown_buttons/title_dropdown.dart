import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:isolate';

import 'package:fife_lab/lib/app_logger.dart';
import 'package:fife_lab/lib/initializer.dart';
import 'package:fife_lab/widgets/dropdown_buttons/app_bar_dropdown.dart';
import 'package:fife_lab/widgets/fife_lab_dialog.dart';
import 'package:fife_lab/widgets/logfile_reader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';

enum _Title {
  about('About'),
  preferences('Preferences'),
  serverLogs('Server Logs'),
  appLogs('App Logs');

  const _Title(this.displayTitle);

  final String displayTitle;

  @override
  String toString() => displayTitle;
}

class TitleDropdown extends ConsumerStatefulWidget {
  const TitleDropdown({super.key});

  @override
  ConsumerState createState() => _TitleDropdownState();
}

class _TitleDropdownState extends ConsumerState<TitleDropdown> {
  void onSelected(_Title choice) {
    switch (choice) {
      case _Title.about:
        {
          FifeLabDialog.showDialogWrapper(
            title: 'About',
            content: _AboutContent(),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Close'),
              ),
            ],
            context: context,
          );
        }
      case _Title.preferences:
        FifeLabDialog.showDialogWrapper(
          title: 'Preferences',
          content: Text('asdf'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
          context: context,
        );
      case _Title.serverLogs:
        FifeLabDialog.showDialogWrapper(
          title: 'Server Logs',
          content: LogfileReader(logType: LogType.serverLogs),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
          context: context,
        );
      case _Title.appLogs:
        FifeLabDialog.showDialogWrapper(
          title: 'App Logs',
          content: LogfileReader(logType: LogType.appLogs),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
          context: context,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBarDropdown(
      primary: true,
      onSelected: onSelected,
      values: _Title.values,
      title: 'Fife Lab',
    );
  }
}

class _AboutContent extends StatelessWidget {
  const _AboutContent({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: PackageInfo.fromPlatform(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Container();
        }
        final packageInfo = snapshot.data;
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('App Name: ${packageInfo?.appName ?? 'Error'}'),
            Text('Version: ${packageInfo?.version ?? 'Error'}'),
            Text('Build Number: ${packageInfo?.buildNumber ?? 'Error'}'),
          ],
        );
      },
    );
  }
}