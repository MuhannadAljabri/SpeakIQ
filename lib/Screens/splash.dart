import 'dart:async';
import 'package:flutter/material.dart';
import 'package:speak_iq/main.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
      const Duration(seconds: 2),
      () {
        // Navigate to the main screen after 2 seconds
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Onboard()),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image(image: AssetImage('assets/MicDropLogoMain.png')),
      ),
    );
  }
}
