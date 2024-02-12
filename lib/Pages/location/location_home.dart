//  caretaker side

// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:minor_project/Pages/location/googleMap.dart';
import 'package:minor_project/Provider/socketProvider.dart';

class LocationHomePage extends ConsumerStatefulWidget {
  const LocationHomePage({super.key});

  @override
  ConsumerState<LocationHomePage> createState() => _LocationHomePageState();
}

class _LocationHomePageState extends ConsumerState<LocationHomePage> {
  @override
  Widget build(BuildContext context) {
    LatLng patientLocation =
        ref.read(socketProvider.notifier).patientLocation ?? LatLng(0, 0);

    return Scaffold(
        body: Stack(
      children: [
        SizedBox(
            height: double.infinity,
            child: Image.asset(
              'assets/images/gmap.webp',
              fit: BoxFit.cover,
            )),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 70,
            ),
            Center(
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: createGradient(patientLocation.latitude),
                ),
                child: Center(
                  child: 200 == 0.0
                      ? CircularProgressIndicator()
                      : Text(
                          '$patientLocation m',
                          style: TextStyle(
                            // color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "Patient is ${200.toInt()} m away from You",
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 50,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: ElevatedButton(
                onPressed: () async {
                  Navigator.of(context).push(MaterialPageRoute(builder: (c) {
                    return GoogleMapPage();
                  }));
                },
                child: const Text("Get Location"),
              ),
            ),
          ],
        ),
      ],
    ));
  }
}

Gradient createGradient(double distance) {
  Color startColor;
  Color endColor;
  Color innerColor;

  if (distance < 1000) {
    // Green side for distances less than 1000
    startColor = Color(0xFF4CAF50); // Green color
    endColor = Color(0xFF2E7D32); // Darker green color
    innerColor = Colors.white; // Inner color for distances less than 1000
  } else {
    // Red side for distances greater than or equal to 1000
    startColor = Color(0xFFE57373); // Light red color
    endColor = Color(0xFFD32F2F); // Darker red color
    innerColor = Colors
        .white; // You can choose a different color for the inner side here
  }

  return RadialGradient(
    colors: [innerColor, startColor, endColor],
    stops: const [0.0, 0.4, 1.0],
    center: Alignment.center,
    radius: 0.7,
    focal: Alignment.center,
    focalRadius: 0.1,
  );
}

Future<Position> _determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return Future.error('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.');
  }

  return await Geolocator.getCurrentPosition();
}
