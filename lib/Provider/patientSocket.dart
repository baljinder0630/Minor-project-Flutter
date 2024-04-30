import 'package:socket_io_client/socket_io_client.dart' as IO;

main() async {
  // Dart client
  // IO.Socket socket = IO.io(
  IO.Socket socket = IO.io(
      'https://assistalzheimer.onrender.com',
      // 'http://localhost:5000',
      IO.OptionBuilder().setAuth({
        "role": "patient",
        "userId": "6593dc206342a2d7242067cd",
      }).setTransports(['websocket']).build());
  socket.connect();
  socket.onConnect((_) {
    // print('connect');
    print(socket.id.toString());

    //socket.on("tasksFromCareTaker", (data) => print(data.toString()));
    socket.emit("updateLocation", {
      "userId": "6593dc206342a2d7242067cd",
      // "careTakerId": "6583ead050b5596880c25afd",
      "latitude": 3.4219983,
      "longitude": -122.084,
      "timestamp": 1331161200
    });
  });
}
