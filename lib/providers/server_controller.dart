import 'dart:async';
import 'dart:io';
import 'package:fife_lab/lib/app_logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'server_controller.g.dart';

@riverpod
class ServerController extends _$ServerController {
  final String serverIp = '127.0.0.1';
  final int serverPort = 8001;
  final controller = StreamController<bool>();

  @override
  Stream<bool> build() {
    connectToKeepAliveSocket();
    return controller.stream;
  }

  Future<void> connectToKeepAliveSocket() async {
    controller.add(false);
    try {
      final socket = await Socket.connect(serverIp, serverPort);
      controller.add(true);
      AppLogger.i('socket connection successful.');

      socket.listen(
        (msg) => AppLogger.i(msg),
        onDone: () async {
          AppLogger.w('Connection closed. Attempting to reconnect.');
          controller.add(false);
          socket.destroy();
          await Future.delayed(Duration(seconds: 2));
          ref.invalidateSelf();
        },
        onError: (err) {
          AppLogger.e(err);
        },
        cancelOnError: true,
      );
    } catch (e) {
      AppLogger.w('Unable to connect to socket.');
      controller.add(false);
      await Future.delayed(Duration(seconds: 2));
      ref.invalidateSelf();
    }
  }
}
