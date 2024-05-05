import 'dart:convert';
import 'dart:developer';

import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:local_auth/local_auth.dart';
import 'package:minor_project/Provider/locationProvider.dart';
import 'package:minor_project/constants.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:minor_project/models/assignedPatient.dart';
import 'package:minor_project/models/user_model.dart';
import 'package:minor_project/to_do/providers/providers.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final authStateProvider =
    StateNotifierProvider<UserAuth, AuthState>(((ref) => UserAuth(ref: ref)));

class UserAuth extends StateNotifier<AuthState> {
  StateNotifierProviderRef ref;

  UserAuth({required this.ref})
      : super(AuthState(
          user: FirebaseAuth.instance.currentUser == null
              ? UserModel(email: '', id: '', name: '', role: '')
              : UserModel(
                  email: FirebaseAuth.instance.currentUser!.email!,
                  id: FirebaseAuth.instance.currentUser!.uid,
                  name: FirebaseAuth.instance.currentUser!.displayName ?? '',
                  role: '',
                ),
          authStatus: AuthStatus.initial,
          appStatus: AppStatus.inital,
          currentPatient: CurrentPatient(email: '', id: '', name: ''),
          role: Role.initial,
        )) {
    checkAuthentication();
  }

  Future<void> authenticate() async {
    try {
      final LocalAuthentication auth = LocalAuthentication();
      if (await auth.isDeviceSupported()) {
        log("*Authentication*---- Device is supported");
        while (!await auth.authenticate(
          localizedReason: 'Please authenticate ',
          options: const AuthenticationOptions(
            stickyAuth: true,
            biometricOnly: false,
          ),
        )) {
          state = state.copyWith(appStatus: AppStatus.inital);
        }
      }
    } on PlatformException catch (e) {
      log("*Authentication*---- " + e.message.toString());
    }
  }

  Future<void> checkAuthentication() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final screenLock = prefs.getBool('localAuth');
    print("Checking authentication");
    print(FirebaseAuth.instance.currentUser.toString());
    try {
      if (screenLock == true && mounted) {
        await authenticate(); // biometric authentication
      }

      await FirebaseAuth.instance.authStateChanges().listen((User? user) async {
        if (user != null) {
          if (user.emailVerified || true) {
            await getUserInfo(user.uid);
            if (state.user.email == "")
              state = state.copyWith(appStatus: AppStatus.unauthenticated);
            print("User: ${state.user}");
            state = state.copyWith(appStatus: AppStatus.authenticated);
          }
        } else {
          state = state.copyWith(appStatus: AppStatus.unauthenticated);
        }
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> getUserInfo(String userId) async {
    DocumentSnapshot userDoc =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();
    if (!userDoc.exists) {
      return;
    }
    print("UserDoc: ${userDoc.data().toString()}");
    final data = userDoc.data() as Map<String, dynamic>;
    UserModel user = UserModel(
      email: data['email'],
      id: userId,
      name: data['name'],
      role: data['role'],
      contactNumber: data['contactNumber'],
    );
    // UserModel.fromJson(userDoc./data()); // Convert DocumentSnapshot to Map
    print("User model ");
    // Save user and role in the state
    state = state.copyWith(
        user: user,
        role: user.role == "patient" ? Role.patient : Role.careTaker);
  }

  Future<Map<String, dynamic>> signUp({
    required String email,
    required String password,
    required String name,
    required String contactNumber,
    required String role,
  }) async {
    try {
      state = state.copyWith(authStatus: AuthStatus.processing);

      // Create a new user
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Send email verification
      final user = FirebaseAuth.instance.currentUser;
      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
      }

      // Update user profile with name
      await user!.updateDisplayName(name);

      // Store additional user data in Firestore
      CollectionReference users =
          FirebaseFirestore.instance.collection('users');
      users.doc(user.uid).set({
        'name': name,
        'email': email,
        'contactNumber': contactNumber,
        'role': role,
      });

      state = state.copyWith(authStatus: AuthStatus.processed);
      return {"success": true, "message": "User created successfully"};
    } catch (e) {
      print(e.toString());
      state = state.copyWith(authStatus: AuthStatus.error);
      return {"success": false, "message": "Something went wrong"};
    }
  }

  Future<Map<String, dynamic>> signIn({
    required String email,
    required String password,
    required String role,
  }) async {
    try {
      state = state.copyWith(authStatus: AuthStatus.processing);

      // Sign in with email and password
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Get the user
      User? user = userCredential.user;

      if (user != null) {
        // Fetch user document from Firestore
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();
        UserModel userModel = UserModel(
          email: user.email!,
          id: user.uid,
          name: user.displayName ?? '',
          role: userDoc.get('role'),
          contactNumber: userDoc.get('contactNumber'),
        ); // Convert DocumentSnapshot to Map

        // Save user and role in the state
        state = state.copyWith(
            user: userModel,
            role: userModel.role == "patient" ? Role.patient : Role.careTaker,
            authStatus: AuthStatus.processed,
            appStatus: AppStatus.authenticated);

        print("Signin successful");
        return {"success": true, "message": "User signed in successfully"};
      } else {
        print("Signin unsuccessful");
        state = state.copyWith(authStatus: AuthStatus.error);
        return {"success": false, "message": "Something went wrong"};
      }
    } catch (e) {
      print(e.toString());
      state = state.copyWith(authStatus: AuthStatus.error);

      return {"success": false, "message": "Something went wrong"};
    }
  }

  Future<bool> allocateCareTaker(String caretakerId) async {
    try {
      log("In allocateCareTaker function" + caretakerId);

      // check if request already accepted
      DocumentSnapshot patientDoc = await FirebaseFirestore.instance
          .collection('patients')
          .doc(state.user.id)
          .get();

      if (patientDoc.exists) {
        Map<String, dynamic> data = patientDoc.data()
            as Map<String, dynamic>; // Convert DocumentSnapshot to Map
        if (data['type'] == 'accepted') {
          print("Request already accepted");
          return false;
        }
      }

      // Get a reference to the patient's document
      await FirebaseFirestore.instance
          .collection('patients')
          .doc(state.user.id)
          .set({
        'caretakerId': caretakerId,
        'patientId': state.user.id,
        'type': 'request',
      });

      print("Caretaker allocated successfully");
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  updatePatientType({patientId, type}) async {
    try {
      // Get a reference to the patient's document
      DocumentReference patientDoc =
          FirebaseFirestore.instance.collection('patients').doc(patientId);

      // Update the patient's document with the allocated caretaker's ID

      if (type == "rejected") {
        await patientDoc.delete();
        return;
      }
      await patientDoc.update({
        'type': type,
      });

      print("Patient type updated successfully");
    } catch (e) {
      print(e);
    }
  }

  Future<Map<String, dynamic>> getPatientInfo(String userId) async {
    print("In Get User Info function");
    try {
      // Get a reference to the patient's document
      DocumentSnapshot patientDoc = await FirebaseFirestore.instance
          .collection('patients')
          .doc(userId)
          .get();

      if (patientDoc.exists) {
        Map<String, dynamic> data = patientDoc.data() as Map<String, dynamic>;
        print(data.toString());

        print("User: ${state.user}");
        return {
          "email": data["email"],
          "name": data["name"],
          "userId": userId,
          "role": data["role"].toString(),
        };
      }

      print("User info not found");
      return {
        "email": "",
        "name": "",
        "role": "",
      };
    } catch (e) {
      print(e.toString());
      return {
        "email": "",
        "name": "",
        "role": "",
      };
    }
  }

  selectCurrentPatient(CurrentPatient currentPatient) {
    state = state.copyWith(currentPatient: currentPatient);
  }

  generateQRData() {
    try {
      final key = encrypt.Key.fromUtf8(mykey);
      final iv = encrypt.IV.fromLength(16);

      final encrypter = encrypt.Encrypter(encrypt.AES(key));

      final encrypted =
          encrypter.encrypt(state.user.id.toString() + ";" + signature, iv: iv);

      print("Encrypted user ID: ${encrypted.base64}");

      // Return both the encrypted data and the IV
      return jsonEncode({
        'encrypted': encrypted.base64,
        'iv': iv.base64,
      });
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  verifyQRData(data) {
    try {
      // Check if data is null or empty
      log(data);
      if (data == null || data.isEmpty) {
        log('Invalid QR data: Data is null or empty.');
        return null;
      }
      data = jsonDecode(data);

      // if (data is String) {
      //   data = jsonDecode(data);
      // }
      // Check if JSON data contains 'encrypted' and 'iv' keys
      if (!data.containsKey('encrypted') || !data.containsKey('iv')) {
        log('Invalid JSON data format: Missing keys.');
        return null;
      }

      final encryptedUserId = data['encrypted'];
      final ivString = data['iv'];

      final key = encrypt.Key.fromUtf8(mykey);
      final iv = encrypt.IV.fromBase64(ivString);

      final encrypter = encrypt.Encrypter(encrypt.AES(key));

      final decrypted = encrypter.decrypt64(encryptedUserId, iv: iv);

      // Split decrypted data and verify signature
      final parts = decrypted.split(';');
      if (parts.length != 2 || parts[1] != signature) {
        log('Invalid signature.');
        return null;
      }

      final userId = parts[0];
      log('Decrypted user ID: $userId');
      return userId;
    } catch (e) {
      log('Error: $e');
      return null;
    }
  }

  Future<void> logout() async {
    print("In logout function");

    try {
      // Sign out the user
      await FirebaseAuth.instance.signOut();

      // Clear local data
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await ref.read(tasksProvider.notifier).clearDb();
      await prefs.clear();

      // Update state
      // dispose all providers

      state = state.copyWith(
        user: UserModel(email: '', id: '', name: '', role: ''),
        authStatus: AuthStatus.initial,
        appStatus: AppStatus.unauthenticated,
        currentPatient: CurrentPatient(email: '', id: '', name: ''),
        role: Role.initial,
      );

      print("Logout successful");
    } catch (e) {
      print(e.toString());
    }
  }
}

class AuthState {
  UserModel user;
  AuthStatus? authStatus;
  AppStatus? appStatus;
  CurrentPatient? currentPatient;
  Role role;

  AuthState({
    required this.user,
    this.authStatus,
    this.appStatus,
    this.currentPatient,
    required this.role,
  });

  AuthState copyWith({
    UserModel? user,
    AuthStatus? authStatus,
    AppStatus? appStatus,
    CurrentPatient? currentPatient,
    Role? role,
  }) {
    return AuthState(
      user: user ?? this.user,
      authStatus: authStatus ?? this.authStatus,
      appStatus: appStatus ?? this.appStatus,
      currentPatient: currentPatient ?? this.currentPatient,
      role: role ?? this.role,
    );
  }
}

enum Role { initial, patient, careTaker }

enum AuthStatus { initial, processing, processed, error }

enum HistoryStatus { initial, processing, processed, error }

enum AppStatus { inital, authenticated, unauthenticated }
