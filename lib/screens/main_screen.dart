import 'dart:io';

import 'package:fife_lab/lib/app_logger.dart';
import 'package:fife_lab/providers/server_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';

class MyHomePage extends ConsumerStatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  ConsumerState<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends ConsumerState<MyHomePage> {
  String data = '0';

  void _incrementCounter() async {
    AppLogger.i('this is a test');
    final dio = Dio(
      BaseOptions(baseUrl: 'http://127.0.0.1:8000'),
    );
    final response = await dio.get('/test');
    setState(() {
      data = response.data.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    final asyncValue = ref.watch(serverControllerProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            asyncValue.when(
              data: (serverConnected) {
                if (serverConnected) {
                  return Text(
                    'Connected',
                    style: TextStyle(
                      fontSize: 82,
                      color: Colors.green,
                    ),
                  );
                } else {
                  return Text(
                    'Not Connected',
                    style: TextStyle(
                      fontSize: 82,
                      color: Colors.red,
                    ),

                  );
                }
              },
              error: (err, stack) {
                AppLogger.e(err, stackTrace: stack);
                return Text('error');
              },
              loading: () => Text('loading'),
            ),
            Text(
              data,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
