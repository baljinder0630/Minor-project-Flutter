import 'package:minor_project/Pages/qrCodePage.dart';
import 'package:minor_project/Pages/qrScannerPage.dart';
import 'package:minor_project/location/location_home.dart';
import 'package:minor_project/to_do/app/app.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class NavPatient extends StatefulWidget {
  const NavPatient({super.key});

  @override
  State<NavPatient> createState() => _NavState();
}

class _NavState extends State<NavPatient> {
  int index = 0;
  // SharedPreferences prefs =await
  //     SharedPreferences.getInstance() as SharedPreferences;
  String? role = "";
  final screens = [
    TodoHome(),
    Center(child: Text("gallery", style: TextStyle(fontSize: 72))),
    LocationHomePage(),
    QRScanPage()
  ];

  @override
  void initState() {
    // TODO: implement initState
    // role = prefs.getString("role") == "" ? "patient" : prefs.getString("role");

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[index],
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          indicatorColor: Colors.purple,
        ),
        child: NavigationBar(
            selectedIndex: index,
            onDestinationSelected: (index) =>
                setState(() => this.index = index),
            destinations: [
              NavigationDestination(icon: Icon(Icons.list), label: "ToDo"),
              NavigationDestination(icon: Icon(Icons.camera), label: "Gallery"),
              NavigationDestination(icon: Icon(Icons.map), label: "Location"),
              NavigationDestination(
                  icon: Icon(Icons.qr_code), label: "QR Code"),
            ]),
      ),
    );
  }
}
