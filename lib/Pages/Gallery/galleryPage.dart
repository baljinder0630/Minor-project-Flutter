import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GalleryPage extends ConsumerStatefulWidget {
  const GalleryPage({super.key});

  @override
  ConsumerState<GalleryPage> createState() => _GalleryPageState();
}

class _GalleryPageState extends ConsumerState<GalleryPage> {
  @override
  Widget build(BuildContext context) {
    // ref.listen(socketProvider, ((previous, next) => print(next)));
    // ref.watch(socketProvider.notifier).listenLocation();
    // ref.watch(socketProvider.notifier).sendLocation();
    return Container();
  }
}

// import 'dart:async';
// import 'dart:developer';
// import 'dart:ui';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:uuid/uuid.dart';

//  class GalleryPage extends ConsumerStatefulWidget {
//   const GalleryPage({super.key});

//   @override
//   ConsumerState<GalleryPage> createState() => _GalleryPageState();
// }

// class GalleryPageState extends ConsumerState<GalleryPage> {
//   final _formKey = GlobalKey<FormState>();
//   final _subjectController = TextEditingController();
//   final _descriptionController = TextEditingController();
//   final _picker = ImagePicker();
//   bool _saveButtonClicked = false;
//   File? _imageFile;

//   uploadPost() async {
//     PostModel post = PostModel(
//       id: Uuid().v4(),
//       subject: _subjectController.text,
//       description: _descriptionController.text,
//       imgUrl: "",
//       userId: ref.read(authStateProvider).user!.uid,
//       username: ref.read(authStateProvider).user!.displayName,
//       createdTime: Timestamp.fromDate(DateTime.now()),
//       createdByAvatar: ref.read(authStateProvider).user!.photoURL,
//     );
//     if (await ref
//         .watch(communityProvider.notifier)
//         .uploadPost(post, _imageFile)) {
//       showSuccessDialog();
//       setState(() {
//         _subjectController.text = "";
//         _descriptionController.text = "";
//         _imageFile = null;
//       });
//     }
//   }
//   showSuccessDialog() {
//     showGeneralDialog(
//         context: context,
//         transitionDuration: Duration(milliseconds: 300),
//         barrierDismissible: true,
//         barrierLabel: '',
//         transitionBuilder: (context, anim1, anim2, child) {
//           return SlideTransition(
//             position: Tween<Offset>(
//               begin: const Offset(0, 1),
//               end: Offset.zero,
//             ).animate(anim1),
//             child: child,
//           );
//         },
//         pageBuilder: (context, ani1, ani2) {
//           int counter = 3;
//           Timer.periodic(Duration(seconds: 1), (Timer t) {
//             if (counter < 1) {
//               Navigator.of(context).pop();
//               t.cancel();
//             } else {
//               counter--;
//             }
//           });
//           return BackdropFilter(
//             filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
//             child: SimpleDialog(
//               elevation: 0,
//               backgroundColor: Colors.transparent,
//               children: [
//                 Container(
//                   width: 378.w,
//                   padding: EdgeInsets.all(19.20.r),
//                   decoration: ShapeDecoration(
//                     color: Color(0xFFFEFEFE),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(28.80.r),
//                     ),
//                     shadows: const [
//                       BoxShadow(
//                         color: Color(0x3F000000),
//                         blurRadius: 12,
//                         offset: Offset(1.20, 1.20),
//                         spreadRadius: 0,
//                       )
//                     ],
//                   ),
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       Text(
//                         'Posted Successfully',
//                         style: TextStyle(
//                           color: Color(0xFF201F24),
//                           fontSize: 19.20.sp,
//                           fontFamily: 'Outfit',
//                           fontWeight: FontWeight.w600,
//                           height: 0,
//                           letterSpacing: 0.38.sp,
//                         ),
//                       ),
//                       SizedBox(height: 19.20.h),
//                       Image.asset(
//                         "lib/assets/Community/PostSuccessfully.png",
//                         fit: BoxFit.contain,
//                       ),
//                       SizedBox(height: 19.20.h),
//                       Container(
//                         child: Column(
//                           mainAxisSize: MainAxisSize.min,
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           children: [
//                             Text(
//                               'THANKYOU',
//                               textAlign: TextAlign.center,
//                               style: TextStyle(
//                                 color: Color(0xFF5272FC),
//                                 fontSize: 19.20.sp,
//                                 fontStyle: FontStyle.italic,
//                                 fontFamily: 'Poppins',
//                                 fontWeight: FontWeight.w800,
//                                 height: 0,
//                                 letterSpacing: 4.03.sp,
//                               ),
//                             ),
//                             SizedBox(height: 9.60.h),
//                             SizedBox(
//                               width: 323.52.w,
//                               child: Text(
//                                 '"HOPE IS LIKE A FLAME; IT CAN NEVER BE EXTINGUISHED, EVEN IN THE DARKEST OF TIMES." WE HOPE YOU GET A BETTER SUPPORT',
//                                 textAlign: TextAlign.center,
//                                 style: TextStyle(
//                                   color: Color(0xFF201F24),
//                                   fontSize: 13.44.sp,
//                                   fontFamily: 'Outfit',
//                                   fontWeight: FontWeight.w400,
//                                   height: 0,
//                                   letterSpacing: 0.54.sp,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       SizedBox(height: 19.20.h),
//                       Text(
//                         'further Notifications Will be Updated ',
//                         textAlign: TextAlign.center,
//                         style: TextStyle(
//                           color: Color(0xFF201F24),
//                           fontSize: 13.44.sp,
//                           fontFamily: 'Outfit',
//                           fontWeight: FontWeight.w400,
//                           height: 0,
//                           letterSpacing: 0.54.sp,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           );
//         });
//   }

//   showCameraOptions() {
//     showModalBottomSheet(
//       context: context,
//       builder: (context) {
//         return Container(
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.only(
//               topLeft: Radius.circular(20.r),
//               topRight: Radius.circular(20.r),
//             ),
//           ),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Padding(
//                 padding: EdgeInsets.all(16.r),
//                 child: const Text(
//                   'Choose an option',
//                   style: TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//               ListTile(
//                 onTap: () async {
//                   await _getImage(ImageSource.camera);
//                   Navigator.pop(context);
//                 },
//                 leading: Icon(Icons.camera_alt, color: Colors.blue),
//                 title: Text("Camera", style: TextStyle(color: Colors.blue)),
//               ),
//               ListTile(
//                 onTap: () async {
//                   await _getImage(ImageSource.gallery);
//                   Navigator.pop(context);
//                 },
//                 leading: Icon(Icons.photo, color: Colors.blue),
//                 title: Text("Gallery", style: TextStyle(color: Colors.blue)),
//               ),
//               SizedBox(height: 20.h)
//             ],
//           ),
//         );
//       },
//     );
//   }

//   imagePreview() {
//     showGeneralDialog(
//       barrierDismissible: true,
//       barrierLabel: '',
//       context: context,
//       pageBuilder: (context, anim1, anim2) => BackdropFilter(
//         filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
//         child: SimpleDialog(
//           title: Text(
//             'Preview',
//             style: TextStyle(
//               fontSize: 18.0,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(20.r),
//           ),
//           children: [
//             Container(
//               padding: EdgeInsets.all(16.0.r),
//               child: Hero(
//                 tag: 'PostImage',
//                 child: Image.file(_imageFile!),
//               ),
//             ),
//             TextButton(
//                 onPressed: () {
//                   setState(() {
//                     _imageFile = null;
//                   });
//                   context.popRoute();
//                 },
//                 child: Text("Remove"))
//           ],
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final uploadArticleStatus =
//         ref.watch(communityProvider).uploadArticleStatus;
//     return GestureDetector(
//       onTap: () => FocusScope.of(context).unfocus(),
//       child: Scaffold(
//         appBar: AppBar(
//           elevation: 0,
//           leadingWidth: 100.w,
//           centerTitle: true,
//           leading: Center(child: MyBackButton()),
//           title: Text(
//             'Post Article',
//             style: TextStyle(
//               color: Color(0xFF201F24),
//               fontSize: 20.sp,
//               fontFamily: 'Outfit',
//               fontWeight: FontWeight.w500,
//               height: 0,
//               letterSpacing: 0.40.sp,
//             ),
//           ),
//         ),
//         body: SingleChildScrollView(
//           physics: BouncingScrollPhysics(),
//           child: Form(
//             key: _formKey,
//             child: Column(
//               children: [
//                 SizedBox(
//                   height: 15.h,
//                 ),
//                 Center(
//                   child: Container(
//                     width: 302.w,
//                     color: Color(0xff000000),
//                     height: 1.h,
//                   ),
//                 ),
//                 SizedBox(height: 32.h),
//                 Container(
//                   // Subject text field
//                   width: 337.w,
//                   // height: 55.h,
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(30.r),
//                     boxShadow: const [
//                       BoxShadow(
//                         color: Color(0x3F000000),
//                         blurRadius: 5,
//                         offset: Offset(0, 0),
//                         spreadRadius: 0,
//                       )
//                     ],
//                   ),
//                   child: TextFormField(
//                     controller: _subjectController,
//                     maxLength: 200,
//                     onEditingComplete: () {
//                       FocusScope.of(context).nextFocus();
//                     },
//                     autovalidateMode: AutovalidateMode.onUserInteraction,
//                     validator: (value) {
//                       if (value == "" || value == null) {
//                         return 'Please enter some text';
//                       } else if (value.trim().length < 10) {
//                         return 'Please enter atleast 10 characters';
//                       } else if (value.trim().length == 200) {
//                         return 'Maximum limit reached';
//                       }
//                       return null;
//                     },
//                     decoration: InputDecoration(
//                       counter: SizedBox.shrink(),
//                       contentPadding: EdgeInsets.all(10.r),
//                       filled: true,
//                       fillColor: Color(0xFFFEFEFE),
//                       hintText: "Subject- What's the article about",
//                       hintStyle: TextStyle(
//                         color: Color(0xFF201F24),
//                         fontSize: 14.sp,
//                         fontFamily: 'Outfit',
//                         fontWeight: FontWeight.w400,
//                         height: 0,
//                         letterSpacing: 1.40.sp,
//                       ),
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(30.r),
//                         borderSide: BorderSide.none,
//                       ),
//                       enabledBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(30.r),
//                         borderSide: BorderSide.none,
//                       ),
//                       focusedBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(30.r),
//                         borderSide: BorderSide.none,
//                       ),
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 21.h),
//                 Container(
//                   // Description text field
//                   width: 337.w,
//                   height: 573.h,
//                   decoration: ShapeDecoration(
//                     color: Color(0xFFFEFEFE),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(30.r),
//                     ),
//                     shadows: const [
//                       BoxShadow(
//                         color: Color(0x3F000000),
//                         blurRadius: 5,
//                         offset: Offset(0, 0),
//                         spreadRadius: 0,
//                       )
//                     ],
//                   ),
//                   child: Column(
//                     children: [
//                       Container(
//                         height: 399.h,
//                         child: TextFormField(
//                           controller: _descriptionController,
//                           maxLength: 5000,
//                           autovalidateMode: AutovalidateMode.onUserInteraction,
//                           validator: (value) {
//                             if (value == "" || value == null) {
//                               return 'Please enter some text';
//                             } else if (value.trim().length < 200) {
//                               return 'Please enter atleast 200 characters';
//                             } else if (value.trim().length == 5000) {
//                               return 'Maximum limit reached';
//                             }
//                             return null;
//                           },
//                           maxLines: 16.h.toInt(),
//                           decoration: InputDecoration(
//                             counter: SizedBox.shrink(),
//                             contentPadding: EdgeInsets.all(10.r),
//                             filled: true,
//                             fillColor: Color(0xFFFEFEFE),
//                             hintText: "Description minimum of 200 Words",
//                             hintStyle: TextStyle(
//                               color: Color(0xFF201F24),
//                               fontSize: 14.sp,
//                               fontFamily: 'Outfit',
//                               fontWeight: FontWeight.w400,
//                               height: 0,
//                               letterSpacing: 1.40.sp,
//                             ),
//                             border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(30.r),
//                               borderSide: BorderSide.none,
//                             ),
//                             enabledBorder: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(30.r),
//                               borderSide: BorderSide.none,
//                             ),
//                             focusedBorder: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(30.r),
//                               borderSide: BorderSide.none,
//                             ),
//                           ),
//                         ),
//                       ),
//                       Center(
//                         child: Container(
//                           width: 284.w,
//                           color: Color(0xff000000),
//                           height: 1.h,
//                         ),
//                       ),
//                       SizedBox(
//                         height: 25.h,
//                       ),
//                       Row(
//                         children: [
//                           Padding(
//                             padding: EdgeInsets.only(left: 29.w),
//                             child: GestureDetector(
//                               onTap: () {
//                                 showCameraOptions();
//                               },
//                               child: Container(
//                                 width: 103.35.w,
//                                 height: 127.40.h,
//                                 decoration: ShapeDecoration(
//                                   color: Color(0xFFFFFBFB),
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(15),
//                                   ),
//                                   shadows: [
//                                     BoxShadow(
//                                       color: _saveButtonClicked &&
//                                               _imageFile == null
//                                           ? Colors.red
//                                           : Color(0x3F000000),
//                                       blurRadius: 5,
//                                       offset: Offset(0, 0),
//                                       spreadRadius: 0,
//                                     )
//                                   ],
//                                 ),
//                                 child: Column(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: [
//                                     Container(
//                                       width: 45.50,
//                                       height: 45.50,
//                                       clipBehavior: Clip.antiAlias,
//                                       decoration: ShapeDecoration(
//                                         shape: RoundedRectangleBorder(
//                                           borderRadius:
//                                               BorderRadius.circular(15),
//                                         ),
//                                       ),
//                                       child: Icon(Icons.add_circle_rounded,
//                                           size: 45.5.r,
//                                           color: Color(0xFF76A095)),
//                                     ),
//                                     SizedBox(height: 13.h),
//                                     Container(
//                                       width: 88.40.w,
//                                       child: Text(
//                                         'Upload Images',
//                                         textAlign: TextAlign.center,
//                                         style: TextStyle(
//                                           color: _saveButtonClicked &&
//                                                   _imageFile == null
//                                               ? Colors.red
//                                               : Color(0xFF76A095),
//                                           fontSize: 9.10.sp,
//                                           fontFamily: 'Poppins',
//                                           fontWeight: FontWeight.w600,
//                                           height: 0,
//                                           letterSpacing: 0.18.sp,
//                                         ),
//                                       ),
//                                     )
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ),
//                           _imageFile == null
//                               ? SizedBox()
//                               : Hero(
//                                   tag: 'PostImage',
//                                   child: GestureDetector(
//                                     onTap: () {
//                                       imagePreview();
//                                     },
//                                     child: Container(
//                                       width: 125.r,
//                                       height: 125.r,
//                                       margin: EdgeInsets.only(left: 29.w),
//                                       decoration: ShapeDecoration(
//                                         image: DecorationImage(
//                                           image: FileImage(_imageFile!),
//                                           fit: BoxFit.cover,
//                                         ),
//                                         shape: RoundedRectangleBorder(
//                                           borderRadius:
//                                               BorderRadius.circular(15.r),
//                                         ),
//                                         shadows: const [
//                                           BoxShadow(
//                                             color: Color(0x3F000000),
//                                             blurRadius: 5,
//                                             offset: Offset(0, 0),
//                                             spreadRadius: 0,
//                                           )
//                                         ],
//                                       ),
//                                       // child: Container(
//                                       //   height:
//                                       //   child: Image.file(
//                                       //     _imageFile!,
//                                       //     fit: BoxFit.cover,
//                                       //   ),
//                                       // ),
//                                     ),
//                                   ),
//                                 )
//                         ],
//                       )
//                     ],
//                   ),
//                 ),
//                 SizedBox(height: 25.h),
//                 GestureDetector(
//                   onTap: () async {
//                     if (_imageFile == null) {
//                       setState(() {
//                         _saveButtonClicked = true;
//                       });
//                     }
//                     if (_formKey.currentState!.validate() &&
//                         _imageFile != null &&
//                         uploadArticleStatus != UploadArticleStatus.processing) {
//                       // Process data.
//                       await uploadPost();
//                     }
//                   },
//                   child: Container(
//                     width: 180.w,
//                     height: 47.h,
//                     padding:
//                         EdgeInsets.symmetric(horizontal: 27.w, vertical: 6.h),
//                     decoration: ShapeDecoration(
//                       color:
//                           uploadArticleStatus == UploadArticleStatus.processing
//                               ? Color.fromARGB(255, 106, 133, 252)
//                               : Color(0xFF5272FC),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(30.r),
//                       ),
//                     ),
//                     child: uploadArticleStatus == UploadArticleStatus.processing
//                         ? Center(
//                             child: SizedBox(
//                               width: 20.r,
//                               height: 20.r,
//                               child: const CircularProgressIndicator(
//                                 color: Colors.white,
//                                 strokeWidth: 2,
//                               ),
//                             ),
//                           )
//                         : Text(
//                             'Save',
//                             textAlign: TextAlign.center,
//                             style: TextStyle(
//                               color: Color(0xFFF9F8FD),
//                               fontSize: 28.sp,
//                               fontFamily: 'Outfit',
//                               fontWeight: FontWeight.w600,
//                               height: 0,
//                               letterSpacing: 1.12.sp,
//                             ),
//                           ),
//                   ),
//                 )
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
