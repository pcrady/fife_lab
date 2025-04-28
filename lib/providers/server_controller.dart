import 'dart:async';
import 'dart:io';
import 'package:fife_lab/lib/app_logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/io.dart';

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
          // Keep alive socket died abruptly. Server should restart it
          // and then we reconnect.
          controller.add(false);
          AppLogger.w('Connection closed. Attempting to reconnect.');
          socket.destroy();
          await Future.delayed(Duration(seconds: 2));
          connectToKeepAliveSocket();
        },
        onError: (err) {
          controller.add(false);
          socket.destroy();
          AppLogger.e(err);
        },
      );
    } catch (e) {
      // Unable to connect to socket. Retry
      controller.add(false);
      await Future.delayed(Duration(milliseconds: 100));
      connectToKeepAliveSocket();
    }
  }
}
