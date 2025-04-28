import 'dart:async';
import 'dart:io';
import 'package:fife_lab/lib/app_logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/io.dart';

part 'server_controller.g.dart';

@riverpod
class ServerController extends _$ServerController {
  static const socketEndpoint = 'ws://127.0.0.1:8000/ws';
  late WebSocketChannel channel;
  final controller = StreamController<bool>();

  @override
  Stream<bool> build() {
    connectToKeepAliveSocket();
    return controller.stream;
  }

  Future<void> connectToKeepAliveSocket() async {
    controller.add(false);
    try {
      final socket = await WebSocket.connect(socketEndpoint);
      controller.add(true);
      AppLogger.i('socket connection successful.');

      channel = IOWebSocketChannel(socket);
      channel.stream.listen(
        (msg) => AppLogger.i(msg),
        onError: (err) => AppLogger.e(err),
        onDone: () async {
          // Keep alive socket died abruptly. Server should restart it
          // and then we reconnect.
          controller.add(false);
          AppLogger.w('Connection closed. Attempting to reconnect.');
          await Future.delayed(Duration(seconds: 2));
          connectToKeepAliveSocket();
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
