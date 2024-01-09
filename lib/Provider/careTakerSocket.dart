// import 'package:minor_project/to_do/data/data.dart';
// import 'package:minor_project/to_do/utils/task_category.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

main() {
  print('Hello World!');
  // Dart client
  IO.Socket socket = IO.io(
      'http://192.168.101.5:5000',
      // IO.Socket socket = IO.io('https://assistalzheimer.onrender.com',
      IO.OptionBuilder().setTransports(['websocket']).build());
  socket.connect();
  socket.onConnect(
    (_) {
      print(socket.connected.toString());
      socket.emit('registerSocket',
          {'role': "careTaker", 'userId': "6583ead050b5596880c25afd"});

      socket.on('updateLocation', (data) => print(data.toString()));

      // socket.emit("assignTask", {
      //   "userId": "6583ead050b5596880c25afd",
      //   "Take": Task(
      //           title: "Homework",
      //           category: TaskCategory.personal,
      //           time: DateTime.now().toString(),
      //           date: DateTime.now().toString(),
      //           note: "Have to complete this by tommorrow",
      //           isCompleted: false)
      //       .toJson()
      // });
    },
  );
}
