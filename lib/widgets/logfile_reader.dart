import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'package:fife_lab/lib/app_logger.dart';
import 'package:fife_lab/lib/initializer.dart';
import 'package:flutter/material.dart';

Future<List<String>> reverseAsync(String serverLogPath) async {
  final file = File(serverLogPath);
  final StreamController<String> logStreamController;
  logStreamController = StreamController();
  List<String> logFileContents = [];
  final ansiRegex = RegExp(r'\x1B\[[0-?]*[ -/]*[@-~]');

  if (await file.exists()) {
    final stream = file.openRead();
    try {
      await for (final line in stream.transform(utf8.decoder).transform(const LineSplitter())) {
        final strippedLine = line.replaceAll(ansiRegex, '');
        logStreamController.add(strippedLine);
        logFileContents.add(strippedLine);
      }
      logFileContents = logFileContents.reversed.toList();
      return logFileContents;
    } catch (e) {
      AppLogger.e('Error reading file: $e');
    } finally {
      logStreamController.close();
    }
  }
  return ['An error has occurred reading the log file.'];
}

enum LogType {
  serverLogs,
  appLogs,
}

class LogfileReader extends StatefulWidget {
  final LogType logType;

  const LogfileReader({
    required this.logType,
    super.key,
  });

  @override
  State<LogfileReader> createState() => _LogfileReaderState();
}

class _LogfileReaderState extends State<LogfileReader> with TickerProviderStateMixin {
  late String selectedFilePath;
  late final ScrollController scrollController;

  @override
  void initState() {
    scrollController = ScrollController();
    super.initState();
  }

  Future<List<String>> _readFile() async {
    await Initializer.initialised.future;
    late String logPath;
    if (widget.logType == LogType.serverLogs) {
      assert(Initializer.serverLogPath != null);
      logPath = Initializer.serverLogPath!;
    } else {
      assert(Initializer.appLogPath != null);
      logPath = Initializer.appLogPath!;
    }
    return await Isolate.run(() => reverseAsync(logPath));
  }

  @override
  void dispose() {
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
            child: Text(
              'Server Log File At: ${Initializer.serverLogPath}',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
            ),
          ),
          const Divider(),
          SizedBox(height: 16.0),
          FutureBuilder<List<String>>(
            future: _readFile(),
            builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
              if (!snapshot.hasData) {
                return SizedBox(
                  height: 700,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Loading Logs...'),
                        SizedBox(height: 8.0),
                        SizedBox(width: 100, child: LinearProgressIndicator()),
                      ],
                    ),
                  ),
                );
              }

              final lines = snapshot.data;
              if (lines == null) {
                return Text('An Error has occurred reading: ${Initializer.serverLogPath}');
              }

              return SizedBox(
                height: 700,
                child: RawScrollbar(
                  thumbColor: Colors.white30,
                  radius: const Radius.circular(20),
                  controller: scrollController,
                  child: SelectionArea(
                    child: ListView.builder(
                      controller: scrollController,
                      shrinkWrap: true,
                      reverse: true,
                      itemCount: lines.length,
                      itemBuilder: (context, index) {
                        return Row(
                          children: [
                            Expanded(
                              child: Text(
                                lines[index],
                                style: const TextStyle(
                                  fontFamily: 'monospace',
                                  fontFamilyFallback: ['Courier', 'Courier New'],
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
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
