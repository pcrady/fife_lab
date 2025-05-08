import 'package:dio/dio.dart';
import 'package:fife_lab/constants.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'worker_watcher.g.dart';

@riverpod
class WorkerWatcher extends _$WorkerWatcher {
  @override
  Stream<bool> build() async* {
    yield* _workerIsUp();
  }

  Stream<bool> _workerIsUp() async* {
    while (true) {
      await Future.delayed(const Duration(seconds: 1));
      yield await workerIsUp();
    }
  }

  static Future<bool> workerIsUp() async {
    try {
      final dio = Dio(BaseOptions(baseUrl: kServer));
      final response = await dio.get('/heartbeat');
      if (response.data['status'] == 'alive') {
        return true;
      } else {
        return false;
      }
    } catch (_) {
      return false;
    }
  }
}
