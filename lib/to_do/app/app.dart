import 'package:flutter/material.dart';
import '../config/config.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TodoHome extends ConsumerWidget {
  const TodoHome({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final route = ref.watch(routesProvider);

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      routerConfig: route,
    );
  }
}
