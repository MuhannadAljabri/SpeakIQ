import 'package:flutter/material.dart';
import '../Style/colors.dart';
import '../Style/route_animation.dart';
import './user_personal_info.dart';
import './speaker_personal_info.dart';
import './privacy_policy.dart';
import './terms_and_conditions.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
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
            const Text(
              'Name',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF212121),
                fontSize: 16,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w700,
                height: 0,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              "Join on 10/10/2020",
              style: TextStyle(
                color: Colors.black.withOpacity(0.5),
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: [
                  // Personal Information Box
                  buttonBox('Personal Information', Icons.person_outline, () {
                    Navigator.of(context).push(slidingFromLeft(const UserPersonalInfo()));
                  }),

                  buttonBox('Speaker Personal Information', Icons.person_outline, () {
                    Navigator.of(context).push(slidingFromLeft(const SpeakerPersonalInfo()));
                  }),

                  // Privacy Policy Box
                  buttonBox('Privacy Policy', Icons.privacy_tip_outlined, () {
                    Navigator.of(context).push(slidingFromLeft(const PrivacyPolicy()));
                  }),

                  // Terms and Conditions Box
                  buttonBox('Terms and Conditions', Icons.edit_note_outlined, () {
                    Navigator.of(context).push(slidingFromLeft(const TermsAndConditions()));
                  }),

                  // Logout Box
                  buttonBox('Logout', Icons.logout_outlined, () {
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
