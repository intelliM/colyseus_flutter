import 'dart:typed_data';

import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class Connection {
  WebSocketChannel _channel;

  Stream<dynamic> get stream => _channel.stream;

  Connection(String url) {
    _channel = IOWebSocketChannel.connect(Uri.parse(url));
  }

  void send(Uint8List data) {
    if (_channel != null) {
      _channel.sink.add(data.buffer);
    }
  }
}
