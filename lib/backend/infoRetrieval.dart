import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../backend/firebase.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:cached_network_image/cached_network_image.dart';

class loadUserInfo {


  String firstName = "";

  final DatabaseReference _userssRef =
      FirebaseDatabase.instance.ref().child('users');


}

class loadSpeakerInfo{

  
}