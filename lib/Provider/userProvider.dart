import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:minor_project/constants.dart';
import 'package:minor_project/models/assignedPatient.dart';
import 'package:minor_project/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

final authStateProvider =
    StateNotifierProvider<UserAuth, AuthState>(((ref) => UserAuth()));

class UserAuth extends StateNotifier<AuthState> {
  UserAuth()
      : super(AuthState(
          user: User(email: '', id: '', name: '', role: '', contactNumber: ''),
          authStatus: AuthStatus.initial,
          appStatus: AppStatus.inital,
          currentPatient: CurrentPatient(email: '', id: '', name: ''),
          role: Role.initial,
        )) {
    checkAuthentication();
  }

  Future<void> checkAuthentication() async {
    log("In Check Authentication function");
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final accessToken = prefs.getString("AT");
    final refreshToken = prefs.getString("RT");

    log("Access Token: $accessToken");
    log("Refresh Token: $refreshToken");

    if (accessToken == null ||
        accessToken.isEmpty ||
        refreshToken == null ||
        refreshToken.isEmpty) {
      state = state.copyWith(appStatus: AppStatus.unauthenticated);
      return;
    }
    try {
      String url = '$host/auth/verifytoken';
      log(url);
      var header = {'Content-Type': 'application/json'};

      var response = await http.post(
        Uri.parse(url),
        headers: header,
        body: json.encode({'token': accessToken}),
      );

      log(json.decode(response.body)["message"]);

      if (response.statusCode != 200) {
        log("Call for refresh token");
        // var email = json.decode(response.body)["email"];
        String url2 = '$host/auth/refreshToken';
        response = await http.post(
          Uri.parse(url2),
          headers: header,
          body: json.encode({'refreshToken': refreshToken}),
        );

        if (response.statusCode == 200) {
          final newAccessToken = json.decode(response.body)["newAccessToken"];
          final newRefreshToken = json.decode(response.body)["newRefreshToken"];
          prefs.setString("AT", newAccessToken);
          prefs.setString("RT", newRefreshToken);

          log("New Access Token: $newAccessToken");
          log("New Refresh Token: $newRefreshToken");
        } else {
          await prefs.clear();
          state = state.copyWith(appStatus: AppStatus.unauthenticated);
          log("Invalid Refresh Token");
        }
      }
      var data = json.decode(response.body);
      log(data.toString());
      await getUserInfo(data["userId"], data["role"]);
      if (state.role == Role.careTaker) await getAssignedPatients();
      // await
      state = state.copyWith(
        appStatus: AppStatus.authenticated,
      );
    } catch (e) {
      state = state.copyWith(appStatus: AppStatus.unauthenticated);
      print(e);
    }
  }

  getUserInfo(String userId, String role) async {
    log("UserId: $userId Role: $role");
    log("In Get User Info function");
    try {
      String url = '$host/profile/getUserInfo';
      var header = {'Content-Type': 'application/json'};

      final response = await http.post(
        Uri.parse(url),
        headers: header,
        body: json.encode({'userId': userId, 'role': role}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        log(data.toString());
        state = state.copyWith(
          user: User(
            email: data["email"],
            id: data["userId"],
            name: data["name"],
            role: role.toString(),
          ),
          role: role == "patient" ? Role.patient : Role.careTaker,
        );

        log("User: ${state.user}");
        return;
      }
      log("User info not found");
    } catch (e) {
      log(e.toString());
    }
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
      String url = '$host/auth/signup/?role=$role';
      var header = {'Content-Type': 'application/json'};

      final response = await http.post(
        Uri.parse(url),
        headers: header,
        body: json.encode({
          'email': email,
          'password': password,
          'name': name,
          'contactNumber': contactNumber
        }),
      );

      log(json.decode(response.body)["message"] ?? "No message at signup");

      if (response.statusCode == 200) {
        log("Signup successful");
        await signIn(email: email, password: password, role: role);
        state = state.copyWith(authStatus: AuthStatus.processed);
        return {"success": true, "message": "User created successfully"};
      } else {
        log("Signup unsuccessful");
        state = state.copyWith(authStatus: AuthStatus.error);
        return {"success": false, "message": "Something went wrong"};
      }
    } catch (e) {
      log(e.toString());
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
      String url = '$host/auth/signin/?role=$role';
      var header = {'Content-Type': 'application/json'};

      final response = await http.post(
        Uri.parse(url),
        headers: header,
        body: json.encode({
          'email': email,
          'password': password,
          'role': role,
        }),
      );

      final data = json.decode(response.body);
      log(data.toString());
      if (data["success"]) {
        final data = jsonDecode(response.body);
        final accessToken = data["accessToken"] ?? "";
        final refreshToken = data["refreshToken"] ?? "";

        state = state.copyWith(authStatus: AuthStatus.processed);
        state = state.copyWith(appStatus: AppStatus.authenticated);

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString("AT", accessToken);
        await prefs.setString("RT", refreshToken);

        log("Signin successful");
        await getUserInfo(data["userId"], role);
        // checkAuthentication();
        return {"success": true, "message": "User signed in successfully"};
      } else {
        log("Signin unsuccessful");
        state = state.copyWith(authStatus: AuthStatus.error);
        return {"success": false, "message": "Something went wrong"};
      }
    } catch (e) {
      log(e.toString());
      return {"success": false, "message": "Something went wrong"};
    }
  }

  Future<bool> allocateCareTaker(String url) async {
    url += "patientId=" + state.user.id;
    log(url);

    try {
      var header = {'Content-Type': 'application/json'};

      final response = await http.post(
        Uri.parse(url),
        headers: header,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        log("Inside allocate caretaker 200 case" + data["message"]);

        return true;
      } else {
        return false;
      }
    } catch (e) {
      log(e.toString());
      return false;
    }
  }

  getAssignedPatients() async {
    try {
      String url = '$host/patientAssigned?caretakerId=${state.user.id}';
      log(url);
      var header = {'Content-Type': 'application/json'};
      final response = await http.get(
        Uri.parse(url),
        headers: header,
      );
      log(response.body);
      final data = json.decode(response.body);
      if (data["success"] == true) {
        state = state.copyWith(
            user: User(
          email: state.user.email,
          id: state.user.id,
          name: state.user.name,
          role: state.user.role,
          assignedPatients: data["patientIds"],
        ));
        // data["patientIds"];
      }
    } catch (e) {
      log(e.toString());
    }
  }

  Future<Map<String, dynamic>> getPatientInfo(
      String userId, String role) async {
    log("UserId: $userId Role: $role");
    log("In Get User Info function");
    try {
      String url = '$host/profile/getUserInfo';
      var header = {'Content-Type': 'application/json'};

      final response = await http.post(
        Uri.parse(url),
        headers: header,
        body: json.encode({'userId': userId, 'role': role}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        log(data.toString());

        log("User: ${state.user}");
        return {
          "email": data["email"],
          "name": data["name"],
          "userId": userId,
          "role": role.toString(),
        };
      }

      log("User info not found");
      return {
        "email": "",
        "name": "",
        "role": "",
      };
    } catch (e) {
      log(e.toString());
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

  // TODO: Implement logout
  Future<void> logout() async {
    log("In logout function");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // final refreshToken = prefs.getString("RT");
    await prefs.clear();
    state = state.copyWith(appStatus: AppStatus.unauthenticated);
  }
}

class AuthState {
  User user;
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
    User? user,
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
