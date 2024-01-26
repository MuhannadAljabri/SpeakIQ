import 'dart:ffi';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_svg/svg.dart';
import '../backend/firebase.dart';
import 'package:firebase_database/firebase_database.dart';
import '../style/colors.dart';
import 'package:cached_network_image/cached_network_image.dart';

class Speaker {
  final String userID;
  final String firstName;
  final String lastName;
  final List<String> topics;
  final List<String> languages;

  final String pictureUrl;

  Speaker(this.userID, this.firstName, this.pictureUrl, this.lastName,
      this.topics, this.languages);
}

class HomePage extends StatelessWidget {
  HomePage({super.key});

  Widget build(BuildContext context) {
    return MyHomePage();
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String userStatus = "";
  bool isSpeaker = false; // Flag to check if the user is a speaker

  String firstName = "";

  final DatabaseReference _speakersRef =
      FirebaseDatabase.instance.ref().child('speaker_requests');

  final DatabaseReference _userssRef =
      FirebaseDatabase.instance.ref().child('users');

  List<Speaker> _speakers = [];

  @override
  void initState() {
    super.initState();
    loadUsers();
    _loadSpeakers();
    checkIfSpeaker();
  }

  void checkIfSpeaker() async {
    // Assuming you're using Firebase Authentication
    User? user = FirebaseAuth.instance.currentUser;

    final snapshot = await _speakersRef.child(user!.uid).once();

    if (snapshot != null) {
      Map<dynamic, dynamic> userData =
          snapshot.snapshot.value as Map<dynamic, dynamic>;

      setState(() {
        userStatus = userData["status"];
        isSpeaker = true; // User is a speaker
        print(isSpeaker.toString());
      });
    }
  }

  Future<void> loadUsers() async {
    GetUserInfo try1 = GetUserInfo();
    firstName = await try1.loadUserInfo();
  }

  Future<void> _loadSpeakers() async {
    final snapshot = await _speakersRef.once();
    List<Speaker> speakers = [];

    Map<dynamic, dynamic> data =
        snapshot.snapshot.value as Map<dynamic, dynamic>;
    if (data != null) {
      data.forEach((key, value) {
        speakers.add(Speaker(
            key, // userID
            value['firstName'] ?? '',
            value['pictureUrl'] ?? '',
            value['lastName'] ?? '',
            List<String>.from(value['topics']),
            List<String>.from(value['languages'])));
      });
    }

    setState(() {
      _speakers = speakers;
    });
  }

  bool isFilterVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        title: Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: 'Good day,\n ',
                style: TextStyle(
                  color: Colors.black.withOpacity(0.5),
                  fontSize: 12,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w400,
                  height: 2,
                ),
              ),
              TextSpan(
                text: firstName,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                  height: 0,
                ),
              ),
            ],
          ),
        ),
        toolbarHeight: 75,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        actions: [
          // Filter button
          IconButton(
            iconSize: 30,
            padding: EdgeInsets.only(right: 16),
            icon: Icon(Icons.filter_list),
            onPressed: () {
              setState(() {
                isFilterVisible = !isFilterVisible;
              });
            },
            color: Colors.black,
          ),
        ],
      ),
      body: Column(children: [
        SizedBox(
          height: 5,
        ),
        if (userStatus.isNotEmpty && isSpeaker)
          Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Container(
                alignment: Alignment.center,
                width: 400,
                height: 50,
                decoration: BoxDecoration(
                  border: Border.all(color: ColorsReference.borderColorGray),
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Text(
                  "Your request's Status: $userStatus",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )),
        Expanded(
            child: ListView.builder(
                itemCount: _speakers.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
                    child: GestureDetector(
                        onTap: () {
                          final speakerId = _speakers[index].userID;
                          Navigator.pushNamed(
                            context,
                            '/speaker_profile',
                            arguments: speakerId,
                          );
                          // Handle box click, you can navigate to another screen or perform an action
                          print('Name clicked: ${_speakers[index].firstName}');
                        },
                        child: Container(
                          height: 144,
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: ColorsReference.borderColorGray),
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Column(
                            children: [
                              Container(
                                  width: double.maxFinite,
                                  height: 80,
                                  margin: EdgeInsets.only(left: 20, bottom: 5),
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                        color: ColorsReference.borderColorGray,
                                      ),
                                    ),
                                    color: Color.fromARGB(255, 255, 255, 255),
                                  ),
                                  child: Row(
                                      // Circle at the far left
                                      children: [
                                        ClipOval(
                                          child: Container(
                                            height: 65,
                                            width: 65,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: ColorsReference
                                                      .borderColorGray),
                                              color: Color.fromARGB(
                                                  255, 255, 255, 255),
                                              shape: BoxShape.circle,
                                            ),
                                            child: CachedNetworkImage(
                                              imageUrl:
                                                  _speakers[index].pictureUrl,
                                              placeholder: (context, url) =>
                                                  CircularProgressIndicator(),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      Icon(Icons.error),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 20,
                                        ),
                                        Text(
                                          '${_speakers[index].firstName} ${_speakers[index].lastName}',
                                          style: TextStyle(
                                            color: const Color.fromARGB(
                                                255, 0, 0, 0),
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ])),
                              // Name in the center

                              Padding(
                                  padding: EdgeInsets.only(top: 5, left: 20),
                                  child: Row(
                                    children: [
                                      SvgPicture.asset(
                                        "assets/hashtag_icon.svg",
                                        height: 15,
                                        width: 15,
                                        color: Colors.black,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        'Topics',
                                        style: TextStyle(
                                          color: const Color.fromARGB(
                                              255, 108, 108, 108),
                                          fontSize: 15,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      Wrap(
                                          spacing: 8.0,
                                          children: _speakers[index]
                                              .topics
                                              .map((topic) => Chip(
                                                      label: Text(
                                                    topic,
                                                    style:
                                                        TextStyle(fontSize: 12),
                                                  )))
                                              .toList()),
                                    ],
                                  ))
                            ],
                          ),
                        )),
                  );
                })),
      ]),
    );
  }
}
