//  caretaker side

// ignore_for_file: prefer_const_constructors

import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:minor_project/Pages/location/googleMap.dart';

class LocationHomePage extends StatefulWidget {
  const LocationHomePage({super.key});

  @override
  State<LocationHomePage> createState() => _LocationHomePageState();
}

class _LocationHomePageState extends State<LocationHomePage> {
  late Position _currentPosition;
  double _distance = 0.0;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _getPatientLocation();
    _timer =
        Timer.periodic(Duration(seconds: 10), (timer) => _getPatientLocation());
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best);
      setState(() {
        _currentPosition = position;
        // print(_currentPosition);
      });
    } catch (e) {
      print("Error: $e");
    }
  }

  _getPatientLocation() async {
    try {
      final response = await http.get(Uri.parse(
          'https://assistalzheimer.onrender.com/api/location/patient/?patientId=6526efe2c7925af873dacc6f'));

      // print(response.body.toString());
      var data = jsonDecode(response.body);
      log(data["message"]);
      if (data["success"] == true) {
        double patientLatitude = double.parse(data['latitude']);
        double patientLongitude = double.parse(data['longitude']);
        _getCurrentLocation();
        _distance = Geolocator.distanceBetween(
          _currentPosition.latitude,
          _currentPosition.longitude,
          patientLatitude,
          patientLongitude,
        );
        // print(_distance);
        setState(() {});
      }
    } catch (e) {
      log(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        Container(
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
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: createGradient(_distance),
                ),
                child: Center(
                  child: _distance == 0.0
                      ? CircularProgressIndicator()
                      : Text(
                          '${_distance.toInt()} m',
                          style: TextStyle(
                            // color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "Patient is ${_distance.toInt()} m away from You",
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
    stops: [0.0, 0.4, 1.0],
    center: Alignment.center,
    radius: 0.7,
    focal: Alignment.center,
    focalRadius: 0.1,
  );
}

/*****************************************************
   * 
   * 
  await _determinePosition().then((value) => log(value.toString()));
   * 
   *
  final LocationSettings locationSettings = LocationSettings(
    accuracy: LocationAccuracy.high,
    distanceFilter: 100,
  );
  StreamSubscription<Position> positionStream =
      Geolocator.getPositionStream(locationSettings: locationSettings)
          .listen((Position? position) {
    log(position == null
        ? 'Unknown'
        : '${position.latitude.toString()}, ${position.longitude.toString()}');
  });
   **************************************************/

Future<Position> _determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  // Test if location services are enabled.
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // Location services are not enabled don't continue
    // accessing the position and request users of the
    // App to enable the location services.
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
  // continue accessing the position of the device.
  return await Geolocator.getCurrentPosition();
}
