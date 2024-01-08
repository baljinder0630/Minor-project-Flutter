import 'dart:developer';

import 'package:socket_io_client/socket_io_client.dart' as IO;

main() async {
  print('Hello World!');
  // Dart client
  // IO.Socket socket = IO.io(
  //     'http://192.168.101.5:5000',
  IO.Socket socket = IO.io('https://assistalzheimer.onrender.com',
      IO.OptionBuilder().setTransports(['websocket']).build());
  socket.connect();
  socket.emit('registerSocket',
      {'role': "patient", 'userId': "6593dc206342a2d7242067cd"});

  // wait 5 seconds
  Future.delayed(Duration(seconds: 5)).then((value) => {
        socket.emit("updateLocation", {
          "userId": "6593dc206342a2d7242067cd",
          // "careTakerId": "6583ead050b5596880c25afd",
          "latitude": 37.4219983,
          "longitude": -122.084,
          "timestamp": 1331161200
        }),
        print(socket.connected.toString())
      });
}
