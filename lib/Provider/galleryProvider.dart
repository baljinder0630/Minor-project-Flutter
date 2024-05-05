import 'dart:developer';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:minor_project/Provider/userProvider.dart';
import 'package:uuid/uuid.dart';
import 'package:firebase_storage/firebase_storage.dart';

final GalleryProvider =
    StateNotifierProvider<Gallery, GalleryState>(((ref) => Gallery(ref: ref)));

class Gallery extends StateNotifier<GalleryState> {
  StateNotifierProviderRef ref;

  Gallery({required this.ref}) : super(GalleryState()) {}

  uploadImage({required File image, required String caption}) async {
    try {
      state = state.copyWith(imageUploadingStatus: Uploading.uploading);
      final uuid = Uuid().v1();
      final reference = FirebaseStorage.instance.ref().child('gallery/$uuid');
      if (reference == null) {
        state = state.copyWith(imageUploadingStatus: Uploading.failed);
        return false;
      }
      await reference.putFile(image).then((value) async {
        final url = await value.ref.getDownloadURL();
        await FirebaseFirestore.instance
            .collection('gallery')
            .doc(ref.read(authStateProvider).user.id)
            .collection('images')
            .doc(uuid)
            .set({
          'url': url,
          'caption': caption,
          'timestamp': DateTime.now().millisecondsSinceEpoch
        });
      });

      state = state.copyWith(imageUploadingStatus: Uploading.uploaded);
      return true;
    } catch (e) {
      log(e.toString());
      state = state.copyWith(imageUploadingStatus: Uploading.failed);
      return false;
    }
  }

  getImageStream() {
    return FirebaseFirestore.instance
        .collection('gallery')
        .doc(ref.read(authStateProvider).user.id)
        .collection('images')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }
}

class GalleryState {
  Uploading imageUploadingStatus;

  GalleryState({this.imageUploadingStatus = Uploading.uploaded});

  GalleryState copyWith({Uploading? imageUploadingStatus}) {
    return GalleryState(
        imageUploadingStatus:
            imageUploadingStatus ?? this.imageUploadingStatus);
  }
}

enum Uploading { uploading, uploaded, failed }
