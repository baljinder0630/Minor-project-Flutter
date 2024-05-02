import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:minor_project/Pages/QrPages/qrCodePage.dart';
import 'package:minor_project/Pages/nav.dart';
import 'package:minor_project/Pages/WelcomeScreen/welcome_screen.dart';
import 'package:minor_project/Provider/userProvider.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    ref.listen(authStateProvider, (previous, next) {
      log("Listening .....${next.appStatus}");
      log(next.user.toString());
      if (next.appStatus == AppStatus.authenticated) {
        if (ref.watch(authStateProvider).user.role == 'careTaker') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const QrCodePage(),
            ),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const Nav(),
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
      backgroundColor: Color.fromARGB(255, 237, 211, 79),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            child: Image.asset("assets/icons/appLogo.png",
                width: 200, height: 300),
          )
        ],
      )),
    );
  }
}
