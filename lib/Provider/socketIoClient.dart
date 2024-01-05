import 'dart:developer';

import 'package:socket_io_client/socket_io_client.dart' as IO;

main() {
  print('Hello World!');
  // Dart client
  IO.Socket socket = IO.io('http://localhost:3000',
      IO.OptionBuilder().setTransports(['websocket']).build());
  log(socket.connected.toString());
  socket.onConnect((data) => print('connect'));
  socket.on('event', (data) => print(data));
  socket.onDisconnect((_) => print('disconnect'));
  socket.on('fromServer', (_) => print(_));
}
