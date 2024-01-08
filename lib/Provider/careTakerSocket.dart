import 'dart:developer';

import 'package:socket_io_client/socket_io_client.dart' as IO;

main() {
  print('Hello World!');
  // Dart client
  IO.Socket socket = IO.io('https://assistalzheimer.onrender.com',
      IO.OptionBuilder().setTransports(['websocket']).build());
  socket.connect();
  print(socket.connected.toString());
  socket.emit('registerSocket',
      {'role': "careTaker", 'userId': "6583ead050b5596880c25afd"});

  socket.on('updateLocation', (data) => print(data.toString()));
}
