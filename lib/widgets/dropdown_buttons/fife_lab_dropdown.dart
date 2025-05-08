import 'package:fife_lab/lib/app_logger.dart';
import 'package:fife_lab/models/settings_model.dart';
import 'package:fife_lab/providers/settings.dart';
import 'package:fife_lab/widgets/dropdown_buttons/app_bar_dropdown.dart';
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
  void onSelected(_FifeLab choice) {
    switch (choice) {
      case _FifeLab.about:
        showDialog(
          context: context,
          builder: (_) => const _AboutDialog(),
        );
        break;
      case _FifeLab.preferences:
        showDialog(
          context: context,
          builder: (_) => const _PreferencesDialog(),
        );
        break;
      case _FifeLab.serverLogs:
        showDialog(
          context: context,
          builder: (_) => const _ServerLogs(),
        );
        break;
      case _FifeLab.appLogs:
        showDialog(
          context: context,
          builder: (_) => const _AppLogs(),
        );
        break;
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

class _AppLogs extends StatelessWidget {
  const _AppLogs();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('App Logs'),
      content: LogfileReader(logType: LogType.appLogs),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Close'),
        ),
      ],
    );
  }
}

class _ServerLogs extends StatelessWidget {
  const _ServerLogs();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Server Logs'),
      content: LogfileReader(logType: LogType.serverLogs),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Close'),
        ),
      ],
    );
  }
}



class _AboutDialog extends StatelessWidget {
  const _AboutDialog();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('About'),
      content: FutureBuilder(
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
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Close'),
        ),
      ],
    );
  }
}

class _PreferencesDialog extends ConsumerWidget {
  const _PreferencesDialog();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncSettings = ref.watch(settingsProvider);

    return asyncSettings.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, __) => const Text('Failed to load settings'),
      data: (settings) {
        final theme = settings.theme;
        return AlertDialog(
          title: const Text('Preferences'),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Color Theme'),
              ToggleButtons(
                isSelected: [
                  theme == ColorTheme.light,
                  theme == ColorTheme.dark,
                ],
                onPressed: (i) async {
                  final value = i == 0 ? ColorTheme.light : ColorTheme.dark;
                  try {
                    ref.read(settingsProvider.notifier).setColorTheme(colorTheme: value);
                  } catch (err, stack) {
                    AppLogger.e(err, stackTrace: stack);
                  }
                },
                borderRadius: BorderRadius.circular(4),
                children: const [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: Icon(Icons.sunny, size: 20, color: Colors.amber),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: Icon(Icons.dark_mode, size: 20, color: Colors.pink),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
