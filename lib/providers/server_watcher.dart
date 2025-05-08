import 'dart:async';
import 'dart:io';
import 'package:fife_lab/constants.dart';
import 'package:fife_lab/lib/app_logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'server_watcher.g.dart';

@riverpod
class ServerWatcher extends _$ServerWatcher {
  final _controller = StreamController<bool>.broadcast();

  @override
  Stream<bool> build() {
    connectToKeepAliveSocket();
    return _controller.stream;
  }

  Future<void> connectToKeepAliveSocket() async {
    _controller.add(false);
    try {
      final socket = await Socket.connect(kHostIp, kControlPort);
      _controller.add(true);
      AppLogger.i('socket connection successful.');

      socket.listen(
        (msg) => AppLogger.i(msg),
        onDone: () async {
          AppLogger.w('Connection closed. Attempting to reconnect.');
          _controller.add(false);
          socket.destroy();
          await Future.delayed(Duration(seconds: 2));
          ref.invalidateSelf();
        },
        onError: (err) => AppLogger.e(err),
        cancelOnError: true,
      );
    } catch (e) {
      AppLogger.w('Unable to connect to socket.');
      _controller.add(false);
      await Future.delayed(Duration(seconds: 2));
      ref.invalidateSelf();
    }
  }
}
