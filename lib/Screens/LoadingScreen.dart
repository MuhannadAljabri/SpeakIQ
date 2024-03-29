import 'package:speak_iq/Screens/home_navigation_screen.dart';
import 'package:speak_iq/style/route_animation.dart';

import '../backend/firebase.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import '../firebase_options.dart';
import 'dart:async';
import 'package:getwidget/getwidget.dart';
import '../style/colors.dart';



class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    super.initState();
    // Start a timer to navigate after 3 seconds
    Timer(Duration(seconds: 5), () {
      // Navigate to the home screen
       Navigator.of(context).pushAndRemoveUntil(slidingFromLeft(const HomeNavigationScreen()), (Route<dynamic> route) => false);

    });
  }

   @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: GFLoader( // Using GFLoader circular loading indicator
          type: GFLoaderType.circle,
          loaderColorOne: ColorsReference.lightBlue,
          loaderColorTwo: ColorsReference.darkBlue,
          loaderColorThree: ColorsReference.lightBlue,
        ),
      ),
    );
  }
}
