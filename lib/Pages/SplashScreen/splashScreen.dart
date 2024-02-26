import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:minor_project/Pages/QrPages/ScanQrScreen.dart';
import 'package:minor_project/Pages/QrPages/qrCodePage.dart';
import 'package:minor_project/Pages/nav.dart';
import 'package:minor_project/Pages/WelcomeScreen/welcome_screen.dart';
import 'package:minor_project/Provider/socketProvider.dart';
import 'package:minor_project/Provider/userProvider.dart';

class SplashScreen extends ConsumerStatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    ref.listen(authStateProvider, (previous, next) {
      log("Listening ....." + next.appStatus.toString());
      log(next.user.toString());
      if (next.appStatus == AppStatus.authenticated) {
        if (ref.watch(authStateProvider).user.role == 'careTaker') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => QrCodePage(),
            ),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => Nav(),
            ),
          );
        }
      } else if (next.appStatus == AppStatus.unauthenticated) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const WelcomeScreen(),
          ),
        );
      }
    });
    return Scaffold(
      body: const Center(
        child: Text('Loading...'),
      ),
    );
  }
}
