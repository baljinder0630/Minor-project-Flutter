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
      socket.emit('registerSocket',
          {'role': "careTaker", 'userId': "6583ead050b5596880c25afd"});

      socket.on('updateLocation', (data) => print(data.toString()));

      socket.emit("assignTaskToPatient", {
        "userId": "6583ead050b5596880c25afd",
        "patientId": "6593dc206342a2d7242067cd",
        "task": "Take medicine",
      });
    },
  );
}
