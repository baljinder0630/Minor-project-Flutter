import 'package:socket_io_client/socket_io_client.dart' as IO;

main() {
  // Dart client
  IO.Socket socket = IO.io('http://192.168.101.5:5000', <String, dynamic>{
    'transports': ['websocket'],
    'autoConnect': false
  });
  socket.connect();
  socket.onConnect((data) {
    socket.emit('updateLocation', {
      "lat": 64524235,
      "long": 23221,
      "userId": "6593dc206342a2d7242067cd",
      "careTakerId": "6583ead050b5596880c25afd"
    });
    socket.emit('registerSocket',
        {"userId": "6593dc206342a2d7242067cd", "role": "patient"});

    // socket.on('/registerSocket', (data) => print("Location updated: $data"));
  });
}
