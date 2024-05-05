import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:minor_project/Provider/locationProvider.dart';
import 'package:minor_project/Provider/userProvider.dart';

class LocationHomePage extends ConsumerStatefulWidget {
  const LocationHomePage({Key? key}) : super(key: key);

  @override
  ConsumerState<LocationHomePage> createState() => _LocationHomePageState();
}

class _LocationHomePageState extends ConsumerState<LocationHomePage> {
  @override
  void initState() {
    super.initState();
    _getCaretakerLocation();
  }

  // check permission and get location
  Future<void> _getCaretakerLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return;
      }
    }
    final prevLocation = await Geolocator.getLastKnownPosition();
    if (prevLocation != null) {
      ref
          .read(locationStateProvider.notifier)
          .setLocation(LatLng(prevLocation.latitude, prevLocation.longitude));
    }
    Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.low,
        distanceFilter: 10,
      ),
    ).listen((Position position) async {
      ref
          .read(locationStateProvider.notifier)
          .setLocation(LatLng(position.latitude, position.longitude));
    });
  }

  @override
  Widget build(BuildContext context) {
    final caretakerLocation =
        ref.watch(locationStateProvider).careTakerLocation;
    log("Caretaker Location: $caretakerLocation");
    double calculateDistance(LatLng patientLocation) {
      double distanceInMeters = Geolocator.distanceBetween(
        caretakerLocation!.latitude,
        caretakerLocation.longitude,
        patientLocation.latitude,
        patientLocation.longitude,
      );
      return distanceInMeters;
    }

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/gmap.webp',
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: AppBar(
              title: Text('Caretaker Location'),
              centerTitle: true,
              backgroundColor: Colors.transparent,
              elevation: 4,
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: StreamBuilder<LatLng>(
                stream: ref
                    .read(locationStateProvider.notifier)
                    .getLocationStream(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }

                  if (!snapshot.hasData || snapshot.data == LatLng(0.0, 0.0)) {
                    return CircularProgressIndicator();
                  }

                  LatLng patientLocation = snapshot.data!;

                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.5),
                              blurRadius: 10,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            'Latitude: ${patientLocation.latitude.toStringAsFixed(6)}, Longitude: ${patientLocation.longitude.toStringAsFixed(6)}',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      if (caretakerLocation != LatLng(0.0, 0.0))
                        Text(
                          "Patient is ${(calculateDistance(patientLocation) / 1000).toStringAsFixed(2)} KM away from You",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
