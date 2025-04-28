import 'dart:async';
import 'dart:io';
import 'package:fife_lab/lib/app_logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'server_controller.g.dart';

@riverpod
class ServerController extends _$ServerController {
  final String _serverIp = '127.0.0.1';
  final int _serverPort = 8001;
  final _controller = StreamController<bool>.broadcast();

  @override
  Stream<bool> build() {
    connectToKeepAliveSocket();
    return _controller.stream;
  }

  Future<void> connectToKeepAliveSocket() async {
    _controller.add(false);
    try {
      final socket = await Socket.connect(_serverIp, _serverPort);
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
