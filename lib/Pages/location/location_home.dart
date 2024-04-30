//  caretaker side

// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:minor_project/Provider/socketProvider.dart';

class LocationHomePage extends ConsumerStatefulWidget {
  const LocationHomePage({super.key});

  @override
  ConsumerState<LocationHomePage> createState() => _LocationHomePageState();
}

class _LocationHomePageState extends ConsumerState<LocationHomePage> {
  LatLng caretakerLocation = LatLng(0.0, 0.0);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getCaretakerLocation();
  }

  Future<void> _getCaretakerLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // get the location of the caretaker.
    Position position = await Geolocator.getCurrentPosition();
    caretakerLocation = LatLng(position.latitude, position.longitude);
  }

  double calculateDistance(patientLocation) {
    double distanceInMeters = Geolocator.distanceBetween(
        caretakerLocation.latitude,
        caretakerLocation.longitude,
        patientLocation.latitude,
        patientLocation.longitude);
    return distanceInMeters;
  }

  @override
  Widget build(BuildContext context) {
    LatLng patientLocation = ref.watch(patientLocationProvider);

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
                  gradient: createGradient(
                      (calculateDistance(patientLocation) / 1000)),
                ),
                child: Center(
                  child: patientLocation == LatLng(0.0, 0.0)
                      ? CircularProgressIndicator()
                      : Text(
                          'Latitude: ${patientLocation.latitude}, Longitude: ${patientLocation.longitude}',
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
            if (caretakerLocation != LatLng(0.0, 0.0))
              Center(
                child: Text(
                  "Patient is ${(calculateDistance(patientLocation) / 1000).toInt().toString()} KM away from You",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ),
            SizedBox(
              height: 50,
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

  if (distance < 8) {
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
