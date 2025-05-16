import 'package:dio/dio.dart';
import 'package:fife_lab/constants.dart';
import 'package:fife_lab/lib/app_logger.dart';
import 'package:fife_lab/providers/images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TestingScreen extends ConsumerStatefulWidget {
  static const route = '/testing';

  const TestingScreen({super.key});

  @override
  ConsumerState createState() => _TestingScreenState();
}

class _TestingScreenState extends ConsumerState<TestingScreen> {
  Future<void> _clearDataBase() async {
    try {
      final dio = Dio(BaseOptions(baseUrl: kServer));
      final response = await dio.post('/clear');
      AppLogger.f(response.toString());
    } catch (err, stack) {
      AppLogger.e(err, stackTrace: stack);
    }
  }

  Future<void> _ioTest() async {
    try {
      final dio = Dio(BaseOptions(baseUrl: kServer));
      List<Future> futures = [];
      for (int i = 0; i < 1000; i++) {
        futures.add(dio.post(
          '/iotest',
          data: {'test_type': 'rapid_io_test', 'value': 1},
        ));
      }
      await Future.wait(futures);
    } catch (err, stack) {
      AppLogger.e(err, stackTrace: stack);
    }
  }

  Future<void> _getAll() async {
    try {
      final dio = Dio(BaseOptions(baseUrl: kServer));
      final response = await dio.get('/all');
      AppLogger.f(response.toString());
    } catch (err, stack) {
      AppLogger.e(err, stackTrace: stack);
    }
  }

  @override
  Widget build(BuildContext context) {
    final data = ref.watch(imagesProvider);
    data.when(
      data: (data) {
        AppLogger.i(data);
      },
      error: (err, stack) {
        AppLogger.e(err, stackTrace: stack);
      },
      loading: () {
        AppLogger.w('loading images');
      },
    );

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
                onPressed: _clearDataBase,
                child: Text('Clear Database'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: _ioTest,
                child: Text('IO Test (Rapid Read, Modify Write)'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: _getAll,
                child: Text('All'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
