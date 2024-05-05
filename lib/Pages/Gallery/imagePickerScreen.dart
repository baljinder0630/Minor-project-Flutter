import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:minor_project/Provider/galleryProvider.dart';
import 'package:minor_project/constants.dart';

class ImagePickerScreen extends ConsumerStatefulWidget {
  @override
  _ImagePickerScreenState createState() => _ImagePickerScreenState();
}

class _ImagePickerScreenState extends ConsumerState<ImagePickerScreen> {
  TextEditingController _captionController = TextEditingController();
  ImagePicker _picker = ImagePicker();
  XFile? _pickedImage;
  final key = GlobalKey<FormState>();

  Future<void> _pickImage() async {
    final pickedImage =
        await _picker.pickImage(source: ImageSource.gallery, imageQuality: 50);
    setState(() {
      _pickedImage = pickedImage; // Set _pickedImage to the pickedImage
    });
  }

  @override
  Widget build(BuildContext context) {
    final uploadStatus = ref.watch(GalleryProvider).imageUploadingStatus;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pick Image and Caption'),
        backgroundColor: kPrimaryColor, // Change app bar color
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: key,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _pickedImage != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.file(
                        File(_pickedImage!.path),
                        width: 200,
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                    )
                  : const Placeholder(
                      color: Colors.grey,
                      fallbackWidth: 200,
                      fallbackHeight: 200,
                    ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _pickImage,
                child: const Text('Pick Image'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _captionController,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter caption';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  hintText: 'Enter Caption',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  if (key.currentState!.validate() &&
                      _pickedImage != null &&
                      uploadStatus != Uploading.uploading) {
                    if (await ref.read(GalleryProvider.notifier).uploadImage(
                          image: File(_pickedImage!.path),
                          caption: _captionController.text,
                        )) {
                      _pickedImage = null;
                      _captionController.clear();
                      Navigator.pop(context);
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        backgroundColor: Colors.red,
                        content: Text('Please pick an image and enter caption'),
                      ),
                    );
                  }
                },
                child: uploadStatus == Uploading.uploading
                    ? Container(
                        width: 60,
                        child: const Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation(Colors.white),
                            strokeWidth: 5.0,
                          ),
                        ),
                      )
                    : const Text('Upload Image'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
