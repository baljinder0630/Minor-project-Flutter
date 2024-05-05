// ignore_for_file: curly_braces_in_flow_control_structures

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:local_auth/local_auth.dart';

final settingProvider =
    StateNotifierProvider<UserSettings, SettingState>((ref) => UserSettings());

class UserSettings extends StateNotifier<SettingState> {
  UserSettings() : super(SettingState(isBiometricEnabled: false)) {
    fetchLocalAuth();
  }

  Future<bool> isDeviceSupportLock() async {
    final LocalAuthentication auth = LocalAuthentication();
    if (await auth.isDeviceSupported()) {
      return true;
    }
    return false;
  }

  setLocalAuth(bool value, context) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    if (!await isDeviceSupportLock()) {
      state = state.copyWith(isBiometricEnabled: false);
      pref.setBool('localAuth', false);
      log("Lock Disabled");

      if (value)
        showDialog(
            context: context,
            builder: (context) {
              return const AlertDialog(
                title: Text("Lock Setup Required"),
                content: Text(
                    "To use this feature, you need to set up a lock on your device."),
              );
            });
      return;
    }
    pref.setBool('localAuth', value);
    state = state.copyWith(isBiometricEnabled: value);
  }

  Future<void> fetchLocalAuth() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    if (!await isDeviceSupportLock()) {
      state = state.copyWith(isBiometricEnabled: false);
      pref.setBool('localAuth', false);
      log("Lock Disabled");
      return;
    }
    final res = pref.getBool('localAuth');
    state = state.copyWith(isBiometricEnabled: res ?? false);
    log("Lock state: $state");
  }
}

class SettingState {
  final bool isBiometricEnabled;

  SettingState({required this.isBiometricEnabled});

  SettingState copyWith({bool? isBiometricEnabled}) {
    return SettingState(
      isBiometricEnabled: isBiometricEnabled ?? this.isBiometricEnabled,
    );
  }
}
