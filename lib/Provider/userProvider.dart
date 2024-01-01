import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:minor_project/constants.dart';
import 'package:minor_project/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

final authStateProvider =
    StateNotifierProvider<UserAuth, AuthState>(((ref) => UserAuth()));

class UserAuth extends StateNotifier<AuthState> {
  UserAuth()
      : super(AuthState(
          user: User(
              email: '', id: '', name: '', role: 'patient', contactNumber: ''),
          authStatus: AuthStatus.initial,
          appStatus: AppStatus.inital,
        )) {
    checkAuthentication();
  }

  Future<void> checkAuthentication() async {
    log("In Check Authentication function");
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final accessToken = 'prefs.getString("AT")';
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
      var header = {'Content-Type': 'application/json'};

      final response = await http.post(
        Uri.parse(url),
        headers: header,
        body: json.encode({'token': accessToken}),
      );

      log(json.decode(response.body)["message"]);

      if (response.statusCode != 200) {
        log("Call for refresh token");
        // var email = json.decode(response.body)["email"];
        String url2 = '$host/auth/refreshToken';
        final response2 = await http.post(
          Uri.parse(url2),
          headers: header,
          body: json.encode({'refreshToken': refreshToken}),
        );

        if (response2.statusCode == 200) {
          state = state.copyWith(
            appStatus: AppStatus.authenticated,
          );
          final newAccessToken = json.decode(response2.body)["newAccessToken"];
          final newRefreshToken =
              json.decode(response2.body)["newRefreshToken"];
          prefs.setString("AT", newAccessToken);
          prefs.setString("RT", newRefreshToken);

          log("New Access Token: $newAccessToken");
          log("New Refresh Token: $newRefreshToken");
        } else {
          await prefs.clear();
          state = state.copyWith(appStatus: AppStatus.unauthenticated);
          log("Invalid Refresh Token");
        }
      } else {
        state = state.copyWith(
          appStatus: AppStatus.authenticated,
        );
        var data = json.decode(response.body);
        log(data.toString());
        await getUserInfo(data["email"], data["role"]);
      }
    } catch (e) {
      state = state.copyWith(appStatus: AppStatus.unauthenticated);
      print(e);
    }
  }

  getUserInfo(String email, String role) async {
    log("In Get User Info function");
    try {
      String url = '$host/profile/getUserInfo';
      var header = {'Content-Type': 'application/json'};

      final response = await http.post(
        Uri.parse(url),
        headers: header,
        body: json.encode({'email': email, 'role': role}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        log(data);
        state = state.copyWith(
          user: User(
              email: email,
              id: data["id"],
              name: data["name"],
              role: role,
              contactNumber: data["contactNumber"]),
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
        state = state.copyWith(authStatus: AuthStatus.processed);
        await getUserInfo(email, role);
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

      log(json.decode(response.body)["message"] ?? "No message at signin");

      if (response.statusCode == 200) {
        log("Signin successful");
        state = state.copyWith(authStatus: AuthStatus.processed);
        final data = jsonDecode(response.body);
        final accessToken = data["accessToken"];
        final refreshToken = data["refreshToken"];
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString("AT", accessToken);
        await prefs.setString("RT", refreshToken);
        await getUserInfo(email, role);
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
}

class AuthState {
  User user;
  AuthStatus? authStatus;
  AppStatus? appStatus;

  AuthState({
    required this.user,
    this.authStatus,
    this.appStatus,
  });

  AuthState copyWith({
    User? user,
    AuthStatus? authStatus,
    AppStatus? appStatus,
  }) {
    return AuthState(
      user: user ?? this.user,
      authStatus: authStatus ?? this.authStatus,
      appStatus: appStatus ?? this.appStatus,
    );
  }
}

enum AuthStatus { initial, processing, processed, error }

enum HistoryStatus { initial, processing, processed, error }

enum AppStatus { inital, authenticated, unauthenticated }
