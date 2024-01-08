import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:minor_project/Provider/socketProvider.dart';

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
