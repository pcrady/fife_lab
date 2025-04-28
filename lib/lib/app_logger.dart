import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';

class AppLogger {
  AppLogger._();
  static late final Logger _logger;
  static final Completer _completer = Completer();

  static Future<void> init() async {
    if (_completer.isCompleted) return;
    final docs = await getApplicationDocumentsDirectory();
    final logPath = docs.path;

    _logger = Logger(
      level: kReleaseMode ? Level.warning : Level.trace,
      output: MultiOutput([
        ConsoleOutput(),
        AdvancedFileOutput(path: logPath),
      ]),
    );

    _logger.i('Logging to: $logPath');
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
