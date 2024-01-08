// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:geolocator/geolocator.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:minor_project/Provider/userProvider.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'dart:developer';

final socketProvider = StateNotifierProvider((ref) => SocketNotifier(
    role: "careTaker", userId: ref.watch(authStateProvider).user.id));

class SocketNotifier extends StateNotifier<IO.Socket> {
  LatLng? patientLocation;
  String role;
  String userId;
  bool mounted = true;
  StreamSubscription<Position>? positionStreamSubscription;

  // SocketNotifier({required this.role, required this.userId})
  //     : super(IO.io('http://192.168.101.5:5000',
  //           IO.OptionBuilder().setTransports(['websocket']).build())) {
  //   connect();
  // }
  SocketNotifier({required this.role, required this.userId})
      : super(IO.io('https://assistalzheimer.onrender.com',
            IO.OptionBuilder().setTransports(['websocket']).build())) {
    connect();
  }

  @override
  void dispose() {
    mounted = false;
    super.dispose();
  }

  void connect() {
    if (!mounted) return;

    state.connect();
    // state.on('updateLocation', (data) => log("data.toString()"));

    state.onConnect((data) {
      log(state.id.toString());
      registerUser();
      listenLocation();
    });
  }

  void listenLocation() {
    log("Listening, connected: ${state.connected}");
    state.on('updateLocation', (data) {
      log(data.toString());
      var lat = data['latitude'];
      var lng = data['longitude'];
      patientLocation = LatLng(lat, lng);
    });
  }

  void registerUser() {
    if (!mounted) return;
    if (this.userId == null || this.role == null) {
      log("empty user id or role in registerUser");
      return;
    }
    state.emit('registerSocket', {'role': this.role, 'userId': this.userId});
    log('Socket registered');
  }

  void sendLocation() {
    if (!mounted) return;
    if (this.userId == null || this.role == null) {
      log("empty user id or role in sendLocation");
      return;
    }
    final LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 0,
    );
    final positionStream =
        Geolocator.getPositionStream(locationSettings: locationSettings);

    positionStreamSubscription = positionStream.listen(
      (Position position) {
        // if (mounted) {
        // log("message");
        // log(userId);
        state.emit('updateLocation', {
          'latitude': position.latitude,
          'longitude': position.longitude,
          'role': this.role,
          'userId': this.userId,
        });
        // }
        log(position == null
            ? 'Unknown'
            : '${position.latitude.toString()}, ${position.longitude.toString()}');
      },
      onError: (error) {
        // Handle the error...
        log('An error occurred: $error');
      },
    );
  }

  void stopListening() {
    positionStreamSubscription?.cancel();
    positionStreamSubscription = null;
  }

  void disconnect() {
    state.disconnect();
    state.onDisconnect((_) {
      log('Disconnected from socket');
    });
  }
}
