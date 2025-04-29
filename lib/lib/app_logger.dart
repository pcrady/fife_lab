import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

class AppLogger {
  AppLogger._();
  static late final Logger _logger;
  static final Completer _completer = Completer();

  static void init({
    required String latestFileName,
    required String logPath,
    AnsiColor infoColor = const AnsiColor.fg(032),
  }) {
    if (_completer.isCompleted) return;
    _logger = Logger(
      level: kReleaseMode ? Level.warning : Level.trace,
      printer: PrettyPrinter(
        levelColors: {Level.info: infoColor},
        dateTimeFormat: DateTimeFormat.dateAndTime,
      ),
      output: MultiOutput([
        ConsoleOutput(),
        AdvancedFileOutput(
          path: logPath,
          latestFileName: latestFileName,
          maxFileSizeKB: 512,
          maxRotatedFilesCount: 10,
        ),
      ]),
    );

    _logger.i('Logging to: ${logPath}/${latestFileName}');
    _completer.complete();
  }

  static void _checkCompleter() {
    if (!_completer.isCompleted) {
      throw StateError('AppLogger not initialized – call AppLogger.init() first.');
    }
  }

  static void d(
    dynamic message, {
    DateTime? time,
    Object? error,
    StackTrace? stackTrace,
  }) {
    _checkCompleter();
    _logger.d(
      message,
      time: time,
      error: error,
      stackTrace: stackTrace,
    );
  }

  static void e(
    dynamic message, {
    DateTime? time,
    Object? error,
    StackTrace? stackTrace,
  }) {
    _checkCompleter();
    _logger.e(
      message,
      time: time,
      error: error,
      stackTrace: stackTrace,
    );
  }

  static void f(
    dynamic message, {
    DateTime? time,
    Object? error,
    StackTrace? stackTrace,
  }) {
    _checkCompleter();
    _logger.f(
      message,
      time: time,
      error: error,
      stackTrace: stackTrace,
    );
  }

  static void i(
    dynamic message, {
    DateTime? time,
    Object? error,
    StackTrace? stackTrace,
  }) {
    _checkCompleter();
    _logger.i(
      message,
      time: time,
      error: error,
      stackTrace: stackTrace,
    );
  }

  static void t(
    dynamic message, {
    DateTime? time,
    Object? error,
    StackTrace? stackTrace,
  }) {
    _checkCompleter();
    _logger.t(
      message,
      time: time,
      error: error,
      stackTrace: stackTrace,
    );
  }

  static void w(
    dynamic message, {
    DateTime? time,
    Object? error,
    StackTrace? stackTrace,
  }) {
    _checkCompleter();
    _logger.w(
      message,
      time: time,
      error: error,
      stackTrace: stackTrace,
    );
  }
}
