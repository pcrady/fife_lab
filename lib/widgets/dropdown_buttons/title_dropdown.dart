import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:fife_lab/lib/app_logger.dart';
import 'package:fife_lab/lib/initializer.dart';
import 'package:fife_lab/widgets/dropdown_buttons/app_bar_dropdown.dart';
import 'package:fife_lab/widgets/fife_lab_dialog.dart';
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
          content: _ServerLogsContent(),
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
          content: Text('Some content'),
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

class _ServerLogsContent extends StatefulWidget {
  const _ServerLogsContent({super.key});

  @override
  State<_ServerLogsContent> createState() => _ServerLogsContentState();
}

class _ServerLogsContentState extends State<_ServerLogsContent> {
  late String selectedFilePath;
  List<String> logFileContents = [];
  late final StreamController<String> _logStreamController;
  late final ScrollController scrollController;
  bool serverLog = true;

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
    _logStreamController = StreamController();

    WidgetsBinding.instance.addPostFrameCallback((_) => setScroll());
    _startReadingFile();
  }

  //TODO this is janky
  Future<void> setScroll() async {
    if (scrollController.hasClients) {
      scrollController.jumpTo(scrollController.position.maxScrollExtent);
    } else {
      await Future.delayed(Duration(milliseconds: 50));
      setScroll();
    }
  }

  String stripAnsiCodes(String text) {
    final ansiRegex = RegExp(r'\x1B\[[0-?]*[ -/]*[@-~]');
    return text.replaceAll(ansiRegex, '');
  }

  void _startReadingFile() async {
    final file = File(Initializer.serverLogPath!);

    if (await file.exists()) {
      final stream = file.openRead();
      try {
        await for (final line in stream.transform(utf8.decoder).transform(const LineSplitter())) {
          final strippedLine = stripAnsiCodes(line);
          _logStreamController.add(strippedLine);
          logFileContents.add(strippedLine);
        }
      } catch (e) {
        _logStreamController.addError("Error reading file: $e");
        _logStreamController.close();
      }
    } else {
      _logStreamController.addError("File does not exist.");
      _logStreamController.close();
    }
  }

  @override
  void dispose() {
    _logStreamController.close();
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 1200,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SelectionArea(
            child: Text('Server Log File At: ${Initializer.serverLogPath}'),
          ),
          const Divider(),
          SizedBox(height: 8.0),
          StreamBuilder<String>(
            stream: _logStreamController.stream,
            builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
              if (!snapshot.hasData) {
                return const Text('No data');
              }

              return SizedBox(
                height: 700,
                child: RawScrollbar(
                  thumbColor: Colors.white30,
                  radius: const Radius.circular(20),
                  controller: scrollController,
                  child: ListView.builder(
                    controller: scrollController,
                    shrinkWrap: true,
                    itemCount: logFileContents.length,
                    itemBuilder: (context, index) {
                      return Row(
                        children: [
                          Expanded(
                            child: SelectionArea(
                              child: Text(
                                logFileContents[index],
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'monospace', // 👈 fixed-width font
                                  // Optional: fallbacks for older systems
                                  fontFamilyFallback: ['Courier', 'Courier New'],
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
