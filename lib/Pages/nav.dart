import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:minor_project/Pages/Gallery/galleryPage.dart';
import 'package:minor_project/Pages/QrPages/ScanQrScreen.dart';
import 'package:minor_project/Pages/WelcomeScreen/welcome_screen.dart';
import 'package:minor_project/Provider/socketProvider.dart';
import 'package:minor_project/Provider/userProvider.dart';
import 'package:minor_project/Pages/location/location_home.dart';
import 'package:minor_project/to_do/app/app.dart';
import 'package:flutter/material.dart';

class Nav extends ConsumerStatefulWidget {
  const Nav({super.key});

  @override
  _NavState createState() => _NavState();
}

class _NavState extends ConsumerState<Nav> {
  int index = 0;

  Role? role;
  // String? role = "patient";

  @override
  Widget build(BuildContext context) {
    ref.watch(socketProvider.notifier);

    role = ref.watch(authStateProvider).role;
    log("Role: $role");
    const screen1 = [
      TodoHome(),
      // GalleryPage(),
      // Center(child: Text("gallery", style: TextStyle(fontSize: 72))),
      GalleryPage(),

      LocationHomePage(),
      // QrCodePage()
    ];
    const screen2 = [
      TodoHome(),
      // Center(child: Text("gallery", style: TextStyle(fontSize: 72))),
      GalleryPage(),
      ScanQrScreen()
    ];
    if (role == Role.careTaker) {
      return Scaffold(
        body: screen1[index],
        floatingActionButton: CircleAvatar(
          child: GestureDetector(
            onLongPress: () {
              ref.read(authStateProvider.notifier).logout();
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => const WelcomeScreen()));
            },
            child: const Icon(Icons.logout),
          ),
        ),
        bottomNavigationBar: NavigationBarTheme(
          data: const NavigationBarThemeData(
              // indicatorColor: Colors.purple,
              ),
          child: NavigationBar(
              selectedIndex: index,
              onDestinationSelected: (index) =>
                  setState(() => this.index = index),
              destinations: const [
                NavigationDestination(icon: Icon(Icons.list), label: "ToDo"),
                NavigationDestination(
                    icon: Icon(Icons.camera), label: "Gallery"),
                NavigationDestination(icon: Icon(Icons.map), label: "Location"),
                // NavigationDestination(
                //     icon: Icon(Icons.qr_code), label: "QR Code")
              ]),
        ),
      );
    } else if (role == Role.patient) {
      ref.watch(socketProvider.notifier).sendLocation();

      return Scaffold(
        body: screen2[index],
        floatingActionButton: CircleAvatar(
          child: GestureDetector(
            onLongPress: () {
              ref.read(authStateProvider.notifier).logout();
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => const WelcomeScreen()));
            },
            child: const Icon(Icons.logout),
          ),
        ),
        bottomNavigationBar: NavigationBarTheme(
          data: const NavigationBarThemeData(),
          child: NavigationBar(
              selectedIndex: index,
              onDestinationSelected: (index) =>
                  setState(() => this.index = index),
              destinations: const [
                NavigationDestination(icon: Icon(Icons.list), label: "ToDo"),
                NavigationDestination(
                    icon: Icon(Icons.camera), label: "Gallery"),
                NavigationDestination(
                    icon: Icon(Icons.qr_code), label: "QR Code")
              ]),
        ),
      );
    } else {
      return const Scaffold(
        body: Center(
          child: CupertinoActivityIndicator(),
        ),
      );
    }
  }
}
