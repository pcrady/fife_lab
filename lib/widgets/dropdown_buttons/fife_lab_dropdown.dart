import 'package:fife_lab/models/settings_model.dart';
import 'package:fife_lab/providers/settings.dart';
import 'package:fife_lab/widgets/dropdown_buttons/app_bar_dropdown.dart';
import 'package:fife_lab/widgets/fife_lab_dialog.dart';
import 'package:fife_lab/widgets/logfile_reader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';

enum _FifeLab {
  about('About'),
  preferences('Preferences'),
  serverLogs('Server Logs'),
  appLogs('App Logs');

  const _FifeLab(this.displayTitle);

  final String displayTitle;

  @override
  String toString() => displayTitle;
}

class FifeLabDropdown extends ConsumerStatefulWidget {
  const FifeLabDropdown({super.key});

  @override
  ConsumerState createState() => _TitleDropdownState();
}

class _TitleDropdownState extends ConsumerState<FifeLabDropdown> {
  void onSelected(_FifeLab choice) async {
    switch (choice) {
      case _FifeLab.about:
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
      case _FifeLab.preferences:
        {
          FifeLabDialog.showDialogWrapper(
            title: 'Preferences',
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Color Theme'),
                StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
                  final theme = ref.watch(settingsProvider).when(
                        data: (data) => data.theme,
                        error: (_, __) => ColorTheme.dark,
                        loading: () => ColorTheme.dark,
                      );

                  return ToggleButtons(
                    isSelected: [theme == ColorTheme.light, theme == ColorTheme.dark],
                    onPressed: (int index) async {
                      final notifier = ref.read(settingsProvider.notifier);
                      if (index == 0) {
                        await notifier.setColorTheme(colorTheme: ColorTheme.light);
                      } else {
                        await notifier.setColorTheme(colorTheme: ColorTheme.dark);
                      }
                      setState(() {});
                    },
                    borderRadius: BorderRadius.circular(4),
                    children: const [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: Icon(
                          Icons.sunny,
                          size: 20,
                          color: Colors.amber,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: Icon(
                          Icons.dark_mode,
                          size: 20,
                          color: Colors.pink,
                        ),
                      ),
                    ],
                  );
                }),
              ],
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Close'),
              ),
            ],
            context: context,
          );
        }
      case _FifeLab.serverLogs:
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
      case _FifeLab.appLogs:
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
      values: _FifeLab.values,
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
        return SelectionArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('App Name: ${packageInfo?.appName ?? 'Error'}'),
              Text('Version: ${packageInfo?.version ?? 'Error'}'),
              Text('Build Number: ${packageInfo?.buildNumber ?? 'Error'}'),
            ],
          ),
        );
      },
    );
  }
}
