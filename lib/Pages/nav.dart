import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:minor_project/Pages/QrPages/qrCodePage.dart';
import 'package:minor_project/Provider/userProvider.dart';
import 'package:minor_project/Pages/location/location_home.dart';
import 'package:minor_project/to_do/app/app.dart';
import 'package:flutter/material.dart';

class Nav extends ConsumerStatefulWidget {
  @override
  _NavState createState() => _NavState();
}

class _NavState extends ConsumerState<Nav> {
  int index = 0;

  String? role = "";

  @override
  Widget build(BuildContext context) {
    role = ref.watch(authStateProvider).user.role;
    log("Role: $role");
    const screens = [
      TodoHome(),
      Center(child: Text("gallery", style: TextStyle(fontSize: 72))),
      LocationHomePage(),
      QrCodePage()
    ];
    if (role == "careTaker") {
      return Scaffold(
        body: screens[index],
        bottomNavigationBar: NavigationBarTheme(
          data: const NavigationBarThemeData(
            indicatorColor: Colors.purple,
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
                NavigationDestination(
                    icon: Icon(Icons.qr_code), label: "QR Code")
              ]),
        ),
      );
    } else if (role == "patient") {
      return Scaffold(
        body: screens[index],
        bottomNavigationBar: NavigationBarTheme(
          data: const NavigationBarThemeData(
            indicatorColor: Colors.purple,
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
