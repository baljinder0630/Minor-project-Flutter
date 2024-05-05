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

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:minor_project/Pages/Gallery/imagePickerScreen.dart';
import 'package:minor_project/Pages/Gallery/scanObject.dart';
import 'package:minor_project/Provider/galleryProvider.dart';
import 'package:minor_project/constants.dart';
import 'package:minor_project/to_do/widgets/display_white_text.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class GalleryPage extends ConsumerStatefulWidget {
  const GalleryPage({Key? key}) : super(key: key);

  @override
  _GalleryPageState createState() => _GalleryPageState();
}

class _GalleryPageState extends ConsumerState<GalleryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: DisplayWhiteText(
          text: 'Gallery',
          size: 24,
        ),
        centerTitle: true,
        leading: SizedBox(),
        backgroundColor: kPrimaryColor,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: ref.read(GalleryProvider.notifier).getImageStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error fetching data'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No images available'));
          }
          List<DocumentSnapshot> documents = snapshot.data!.docs;
          return GridView.builder(
            itemCount: documents.length,
            physics: BouncingScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemBuilder: (context, index) {
              var image = documents[index]['url'];
              var imageName = documents[index]['caption'];
              return InkWell(
                onTap: () {
                  // preview in dialog box
                  showDialog(
                    context: context,
                    builder: (context) {
                      return Dialog(
                        child: Stack(
                          children: [
                            Container(
                              width: 300,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: NetworkImage(image),
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                            Positioned(
                              right: 0,
                              child: IconButton(
                                icon: Icon(Icons.close),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 15),
                              alignment: Alignment.topCenter,
                              child: Text(
                                imageName,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: Colors.black,
                                ),
                              ),
                            )
                          ],
                        ),
                      );
                    },
                  );
                },
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Container(
                    margin: EdgeInsets.all(8),
                    padding: EdgeInsets.all(8),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              image: DecorationImage(
                                image: NetworkImage(image),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        Text(
                          imageName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.menu_close,
        children: [
          SpeedDialChild(
            child: Icon(Icons.add),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ImagePickerScreen()));
            },
          ),
          SpeedDialChild(
            child: Icon(Icons.camera),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ObjectDetectorView()));
            },
          ),
          // Add more SpeedDialChild widgets if you want more options in your speed dial.
        ],
      ),
    );
  }
}
