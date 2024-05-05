import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:minor_project/Pages/Gallery/galleryPage.dart';
import 'package:minor_project/Pages/profile.dart';
import 'package:minor_project/Provider/locationProvider.dart';
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

  // String? role = "patient";

  @override
  Widget build(BuildContext context) {
    // ref.watch(socketProvider.notifier);

    final role = ref.watch(authStateProvider).role;
    log("Role: $role");
    const screen1 = [
      TodoHome(),
      // GalleryPage(),
      // Center(child: Text("gallery", style: TextStyle(fontSize: 72))),
      // GalleryPage(),

      LocationHomePage(),
      SettingPage(),
      // QrCodePage()
    ];
    const screen2 = [
      TodoHome(),
      // Center(child: Text("gallery", style: TextStyle(fontSize: 72))),
      GalleryPage(),
      SettingPage()
    ];
    if (role == Role.careTaker) {
      return Scaffold(
        body: screen1[index],
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

                NavigationDestination(icon: Icon(Icons.map), label: "Location"),
                NavigationDestination(
                    icon: Icon(Icons.settings), label: "Settings")
                // NavigationDestination(
                //     icon: Icon(Icons.qr_code), label: "QR Code")
              ]),
        ),
      );
    } else if (role == Role.patient) {
      // ref.watch(socketProvider.notifier).sendLocation();
      ref.read(locationStateProvider.notifier).sendLocation();

      return Scaffold(
        body: screen2[index],
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
                    icon: Icon(Icons.person), label: "Profile")
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
