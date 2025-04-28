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

  @override
  Future<void> build() async {
    await connectToKeepAliveSocket();
  }

  Future<void> connectToKeepAliveSocket() async {
    try {
      final socket = await WebSocket.connect(socketEndpoint);
      AppLogger.i('socket connection successful.');

      channel = IOWebSocketChannel(socket);
      channel.stream.listen(
        (msg) => AppLogger.i(msg),
        onError: (err) => AppLogger.e(err),
        onDone: () async {
          // Keep alive socket died abruptly. Server should restart it
          // and then we reconnect.
          AppLogger.w('Connection closed. Attempting to reconnect.');
          await Future.delayed(Duration(seconds: 2));
          connectToKeepAliveSocket();
        },
      );
    } catch (e) {
      // Unable to connect to socket. Retry
      await Future.delayed(Duration(milliseconds: 100));
      connectToKeepAliveSocket();
    }
  }
}
