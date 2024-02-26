import 'package:socket_io_client/socket_io_client.dart' as IO;

main() async {
  print('Hello World!');
  // Dart client
  // IO.Socket socket = IO.io(
  IO.Socket socket = IO.io(
      // 'https://assistalzheimer.onrender.com',
      'http://localhost:5000',
      IO.OptionBuilder().setAuth({
        "role": "patient",
        "userId": "6593dc206342a2d7242067cd",
      }).setTransports(['websocket']).build());
  socket.connect();
  socket.onConnect((_) {
    print('connect');

    socket.on("tasksFromCareTaker", (data) => print(data.toString()));
    Future.delayed(const Duration(seconds: 2), () {
      socket.emit("updateLocation", {
        "userId": "6593dc206342a2d7242067cd",
        // "careTakerId": "6583ead050b5596880c25afd",
        "latitude": 37.4219983,
        "longitude": -122.084,
        "timestamp": 1331161200
      });
    });
  });
}
