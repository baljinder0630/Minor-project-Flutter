import 'dart:developer';

import 'package:geolocator/geolocator.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:minor_project/Provider/userProvider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final locationStateProvider =
    StateNotifierProvider<UserLocation, LocationState>(
        ((ref) => UserLocation(ref: ref)));

class UserLocation extends StateNotifier<LocationState> {
  StateNotifierProviderRef ref;

  UserLocation({required this.ref})
      : super(LocationState(
          careTakerLocation: LatLng(0, 0),
        )) {
    ref.listen(authStateProvider, (previous, next) {
      if (next.role == Role.patient) {
        sendLocation();
      }
    });
  }

  sendLocation() async {
    try {
      //  checking for permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return;
        }
      }
      //  listening to locatoin change and store to firebase
      Geolocator.getPositionStream(
          locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.low,
        distanceFilter: 10,
      )).listen((Position position) async {
        await FirebaseFirestore.instance
            .collection('location')
            .doc(ref.read(authStateProvider).user.id)
            .set({
          'latitude': position.latitude,
          'longitude': position.longitude,
        });
      });
    } catch (e) {
      print(e);
    }
  }

  Stream<LatLng> getLocationStream() {
    // Replace this with your actual Firestore location stream
    return FirebaseFirestore.instance
        .collection('location')
        .doc(ref.watch(authStateProvider).currentPatient!.id)
        .snapshots()
        .map((snapshot) => LatLng(
              snapshot.data()?['latitude'],
              snapshot.data()?['longitude'],
            ));
  }

  setLocation(LatLng location) {
    state = state.copyWith(location: location);
  }
}

class LocationState {
  LatLng? careTakerLocation;
  LocationState({this.careTakerLocation});

  LocationState copyWith({LatLng? location}) {
    return LocationState(careTakerLocation: location ?? this.careTakerLocation);
  }
}
