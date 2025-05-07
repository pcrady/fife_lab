import 'package:dio/dio.dart';
import 'package:fife_lab/constants.dart';
import 'package:fife_lab/lib/app_logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TestingScreen extends ConsumerStatefulWidget {
  static const route = '/testing';

  const TestingScreen({super.key});

  @override
  ConsumerState createState() => _TestingScreenState();
}

class _TestingScreenState extends ConsumerState<TestingScreen> {
  bool _stressRunning = false;

  // Toggles the stress loop on/off
  void _toggleStress() {
    setState(() {
      _stressRunning = !_stressRunning;
    });
    if (_stressRunning) {
      _startStress();
    }
  }

  // Only runs while _stressRunning is true
  Future<void> _startStress() async {
    final dio = Dio(BaseOptions(baseUrl: kServer));
    try {
      while (_stressRunning) {
        final response = await dio.post(
          '/config',
          data: {'project_path': 'testingwhat'},
        );
        AppLogger.f(response.toString());
        // optional small delay to avoid absolutely hammering the server:
        // await Future.delayed(Duration(milliseconds: 10));
      }
    } catch (err, stack) {
      AppLogger.e(err, stackTrace: stack);
    }
  }

  // Only runs while _stressRunning is true
  Future<void> _ioTest() async {
    try {
      final dio = Dio(BaseOptions(baseUrl: kServer));
      List<Future> futures = [];
      for (int i = 0; i < 10000; i++) {
        futures.add(dio.post(
          '/iotest',
          data: {'test_type': 'io_test', 'value': 1},
        ));
      }
      Future.wait(futures);
    } catch (err, stack) {
      AppLogger.e(err, stackTrace: stack);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TESTING'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () async {
                  try {
                    final dio = Dio(BaseOptions(baseUrl: kServer));
                    final response = await dio.post('/clear');
                    AppLogger.f(response.toString());
                  } catch (err, stack) {
                    AppLogger.e(err, stackTrace: stack);
                  }
                },
                child: Text('Clear Database'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: _toggleStress,
                child: Text(_stressRunning ? 'Stop Stress' : 'Start Stress'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: _ioTest,
                child: Text('IO Test'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () async {
                  try {
                    final dio = Dio(BaseOptions(baseUrl: kServer));
                    final response = await dio.get('/all');
                    AppLogger.f(response.toString());
                  } catch (err, stack) {
                    AppLogger.e(err, stackTrace: stack);
                  }
                },
                child: Text('All'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
