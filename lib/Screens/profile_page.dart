import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:speak_iq/Screens/home.dart';
import 'package:speak_iq/Screens/home_navigation_screen.dart';
import '../backend/firebase.dart';
import '../Style/colors.dart';
import '../Style/route_animation.dart';
import './user_personal_info.dart';
import './speaker_personal_info.dart';
import './privacy_policy.dart';
import './terms_and_conditions.dart';
import './Home.dart';



class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {

  String userStatus = "";
  bool isSpeaker = false; // Flag to check if the user is a speaker

  String firstName = "";
  String userCreationTime = "";

  final DatabaseReference _speakersRef =
      FirebaseDatabase.instance.ref().child('speaker_requests');

  final DatabaseReference _userssRef =
      FirebaseDatabase.instance.ref().child('users');

  @override
  void initState() {
    super.initState();
    loadData(); // Load data when the widget is initialized
  }

  Future<void> loadData() async {
    await loadUsers(); // Load user info
    await checkIfSpeaker(); // Check if the user is a speaker
    setState(() {
      // Set the state to update the UI
    });
  }

  Future<void> loadUsers() async {
    GetUserInfo try1 = GetUserInfo();
    firstName = await try1.loadUserInfo();
    User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        DateTime creationTime = user.metadata.creationTime!;
        DateFormat formatter = DateFormat.yMd();
        userCreationTime = formatter.format(creationTime);
      }
  }

  Future<void> checkIfSpeaker() async {
    // Assuming you're using Firebase Authentication

    User? user = FirebaseAuth.instance.currentUser;
    
    final speakerSnapshot = await _speakersRef.child(user!.uid).once();
    final userSnapshot = await _userssRef.child(user!.uid).once();

    if (speakerSnapshot.snapshot.value != null && userSnapshot.snapshot.value != null) {

      Map<dynamic, dynamic> speakerData =
          speakerSnapshot.snapshot.value as Map<dynamic, dynamic>;

      Map<dynamic, dynamic> userData =
          userSnapshot.snapshot.value as Map<dynamic, dynamic>;

      setState(() {
        userStatus = speakerData["status"];
        isSpeaker = true; // User is a speaker
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Container(
              height: 150,
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 245, 245, 245),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(100),
                  bottomRight: Radius.circular(100),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              firstName,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w700,
                height: 0,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              userCreationTime,
              style: TextStyle(
                color: Colors.black.withOpacity(0.5),
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Column(
                children: [
                  // Personal Information Box
                  buttonBox('Personal Information', Icons.person_outline, () {
                    if (isSpeaker){
                      Navigator.of(context).push(slidingFromLeft(const SpeakerPersonalInfo()));
                    } else {
                      Navigator.of(context).push(slidingFromLeft(const UserPersonalInfo()));
                    }
                  }),

                  // Privacy Policy Box
                  buttonBox('Privacy Policy', Icons.privacy_tip_outlined, () {
                    Navigator.of(context).push(slidingFromLeft(const PrivacyPolicy()));
                  }),

                  // Terms and Conditions Box
                  buttonBox('Terms and Conditions', Icons.edit_note_outlined, () {
                    Navigator.of(context).push(slidingFromLeft(const TermsAndConditions()));
                  }),

                  Expanded(
                        child: Container(
                        ),
                      ),
                  // Logout Box
                  buttonBox('Logout', Icons.logout_outlined, () async {
                    await FirebaseAuth.instance.signOut(); // Sign out the user from Firebase
                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    prefs.setBool('isLoggedIn', false);
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      '/login',
                      (Route<dynamic> route) => false,
                    );
                  }),
                  const SizedBox(height: 20),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      "Ver. 0.0.1",
                      style: TextStyle(
                        color: Colors.black.withOpacity(0.5),
                        fontSize: 14,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buttonBox(String title, IconData frontIcon, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          padding: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
            side: const BorderSide(
              width: 2.0,
              color: ColorsReference.borderColorGray,
            ),
          ),
          elevation: 0, // Set elevation to 0 to remove the shadow
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  frontIcon,
                  color: ColorsReference.textColorBlack,
                  size: 24,
                ),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Poppins',
                  ),
                ),
              ],
            ),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              color: ColorsReference.textColorBlack,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
