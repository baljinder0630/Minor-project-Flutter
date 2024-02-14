// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// class GalleryPage extends ConsumerStatefulWidget {
//   const GalleryPage({super.key});

//   @override
//   ConsumerState<GalleryPage> createState() => _GalleryPageState();
// }

// class _GalleryPageState extends ConsumerState<GalleryPage> {
//   @override
//   Widget build(BuildContext context) {
//     // ref.listen(socketProvider, ((previous, next) => print(next)));
//     // ref.watch(socketProvider.notifier).listenLocation();
//     // ref.watch(socketProvider.notifier).sendLocation();
//     return Container();
//   }
// }


import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class GalleryPage extends ConsumerStatefulWidget {
  const GalleryPage({Key? key}) : super(key: key);

  @override
  _GalleryPageState createState() => _GalleryPageState();
}

class _GalleryPageState extends ConsumerState<GalleryPage> {
  List<File> images = [];

  Future<void> _getImageFromDevice() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        images.add(File(pickedFile.path));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Gallery"),
        centerTitle: true,
      ),
      body: GridView.builder(
        itemCount: images.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              // Action to perform when an image is tapped
            },
            child: Card(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.file(
                    images[index],
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                  SizedBox(height: 8),
                  Text(
                    images[index].path.split('/').last,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        images.removeAt(index);
                      });
                    },
                    child: Icon(Icons.remove),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(left: 26.0),
        child: Align(
          alignment: Alignment.bottomLeft,
          child: FloatingActionButton(
            onPressed: _getImageFromDevice,
            child: Icon(Icons.add),
          ),
        ),
      ),
    );
  }
}

// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:path/path.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:sqflite/sqflite.dart';

// class DatabaseHelper {
//   static DatabaseHelper? _databaseHelper; // Singleton DatabaseHelper
//   static late Database _database; // Singleton Database

//   DatabaseHelper._createInstance(); // Named constructor to create instance of DatabaseHelper

//   factory DatabaseHelper() {
//     if (_databaseHelper == null) {
//       _databaseHelper = DatabaseHelper._createInstance(); // This is executed only once, singleton object
//     }
//     return _databaseHelper!;
//   }

//   Future<Database> get database async {
//     if (_database == null) {
//       _database = await initializeDatabase();
//     }
//     return _database;
//   }

//   Future<Database> initializeDatabase() async {
//     Directory directory = await getApplicationDocumentsDirectory();
//     String path = join(directory.path, 'gallery.db');
//     var galleryDatabase =
//         await openDatabase(path, version: 1, onCreate: _createDb);
//     return galleryDatabase;
//   }

//   void _createDb(Database db, int newVersion) async {
//     await db.execute(
//         'CREATE TABLE IF NOT EXISTS images(id INTEGER PRIMARY KEY AUTOINCREMENT, path TEXT)');
//   }

//   Future<int> insertImage(String path) async {
//     Database db = await this.database;
//     var result = await db.insert('images', {'path': path});
//     return result;
//   }

//   Future<List<Map<String, dynamic>>> getImages() async {
//     Database db = await this.database;
//     var result = await db.query('images');
//     return result;
//   }
// }

// class GalleryPage extends ConsumerStatefulWidget {
//   const GalleryPage({Key? key}) : super(key: key);

//   @override
//   _GalleryPageState createState() => _GalleryPageState();
// }

// class _GalleryPageState extends ConsumerState<GalleryPage> {
//   List<File> images = [];
//   final DatabaseHelper databaseHelper = DatabaseHelper();

//   Future<void> _getImageFromDevice() async {
//     final picker = ImagePicker();
//     final pickedFile = await picker.pickImage(source: ImageSource.gallery);
//     if (pickedFile != null) {
//       setState(() {
//         images.add(File(pickedFile.path));
//       });
//       await databaseHelper.insertImage(pickedFile.path);
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//     _getStoredImages();
//   }

//   Future<void> _getStoredImages() async {
//     final List<Map<String, dynamic>> storedImages = await databaseHelper.getImages();
//     setState(() {
//       images = storedImages.map<File>((e) => File(e['path'])).toList();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Gallery"),
//         centerTitle: true,
//       ),
//       body: GridView.builder(
//         itemCount: images.length,
//         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//           crossAxisCount: 2,
//           crossAxisSpacing: 8,
//           mainAxisSpacing: 8,
//         ),
//         itemBuilder: (context, index) {
//           return InkWell(
//             onTap: () {
//               // Action to perform when an image is tapped
//             },
//             child: Card(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Image.file(
//                     images[index],
//                     width: 100,
//                     height: 100,
//                     fit: BoxFit.cover,
//                   ),
//                   SizedBox(height: 8),
//                   Text(
//                     images[index].path.split('/').last,
//                     style: TextStyle(fontWeight: FontWeight.bold),
//                   ),
//                   SizedBox(height: 8),
//                   ElevatedButton(
//                     onPressed: () {
//                       setState(() {
//                         images.removeAt(index);
//                       });
//                       // Remove image from database here
//                     },
//                     child: Icon(Icons.remove),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//       floatingActionButton: Padding(
//         padding: const EdgeInsets.only(left: 26.0),
//         child: Align(
//           alignment: Alignment.bottomLeft,
//           child: FloatingActionButton(
//             onPressed: _getImageFromDevice,
//             child: Icon(Icons.add),
//           ),
//         ),
//       ),
//     );
//   }
// }


