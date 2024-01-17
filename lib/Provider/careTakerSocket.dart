// import 'package:minor_project/to_do/data/data.dart';
// import 'package:minor_project/to_do/utils/task_category.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

main() {
  print('Hello World!');
  // Dart client
  IO.Socket socket = IO.io(
      'http://192.168.101.5:5000',
      // IO.Socket socket = IO.io('https://assistalzheimer.onrender.com',
      IO.OptionBuilder().setTransports(['websocket']).setAuth({
        'role': "careTaker",
        'userId': "6583ead050b5596880c25afd",
      }).build());
  socket.connect();
  socket.onConnect(
    (_) {
      print(socket.connected.toString());

      socket.on('updateLocation', (data) => print(data.toString()));

      Future.delayed(
        Duration(seconds: 3),
        () {
          socket.emit("assignTaskToPatient", {
            "from": "6583ead050b5596880c25afd",
            "to": "6593dc206342a2d7242067cd",
            "task": {
              "id": "1234567890",
              "title": "Take Medicine",
              "note": "Take medicine at 10:00 AM",
              "category": "Medicine",
              "time": "10:00 AM",
              "date": "2021-06-30",
              "assignedBy": "6583ead050b5596880c25afd",
              "isCompleted": false
            }
          });
        },
      );
    },
  );
}
