import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:speak_iq/Screens/SpeakerSignup.dart';
import 'package:speak_iq/Screens/UserSignup.dart';
import 'package:speak_iq/Screens/forgot_password.dart';
import 'package:speak_iq/Screens/login.dart';
import 'package:speak_iq/style/colors.dart';
import 'package:speak_iq/style/route_animation.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:speak_iq/style/style.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final formField = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            body: SingleChildScrollView(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
          Stack(
            children: [
              Container(
                height: 200,
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 245, 245, 245),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(100),
                    bottomRight: Radius.circular(100),
                  ),
                ),
                child: Container(
                  alignment: Alignment.center,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          'assets/speaksy_blue_logo.svg',
                          height: 100,
                          width: 200,
                        ),
                        SizedBox(height: 16),
                        const Text(
                          'Reset your password',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFF212121),
                            fontSize: 16,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w700,
                            height: 0,
                          ),
                        ),
                      ]),
                ),
              ),
              Container(
                height: 200,
                decoration: const BoxDecoration(
                  color: Color.fromRGBO(0, 0, 0, 0),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(100),
                    bottomRight: Radius.circular(100),
                  ),
                ),
                child: IconButton(
                    alignment: Alignment.topLeft,
                    padding: EdgeInsets.only(left: 30, top: 50),
                    iconSize: 28,
                    icon: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      // Navigate back to the previous screen
                      Navigator.pop(context);
                    }),
              )
            ],
          ),
          const Padding(
                  padding: EdgeInsets.only(top: 50, bottom: 30, left: 50, right: 50),
                  child: Text(
                    "Enter your email below! A password reset email will be sent to you if an account exists.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      color: Colors.black,
                      fontSize: 18,
                    ),
                  )),
          Form(
              key: formField,
              child: Column(children: [
                // Email field
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 10, 16, 29),
                  child: Row(children: [
                    const SizedBox(height: 20),
                    Expanded(
                        child: RequiredTextField(
                      hintText: "Enter your email",
                      labelText: "Email",
                      textController: emailController,
                    )),
                  ]),
                ),
              ])),
          const SizedBox(height: 0),
          Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
              child: Container(
                height: 50,
                width: 500,
                decoration: BoxDecoration(
                  color: ColorsReference.darkBlue,
                  borderRadius: BorderRadius.circular(50.0),
                ),
                child: TextButton(
                    onPressed: () {
                      handleRequest();
                    },
                    child: const Text("Send",
                        style: TextStyle(
                          color: Colors.white,
                        ))),
              )),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text("Remember the password?",
                style: TextStyle(
                    color: Colors.black.withOpacity(0.5), fontSize: 14)),
            TextButton(
                onPressed: () {
                  Navigator.of(context).push(slidingFromDown(LoginScreen()));
                },
                child: const Text(
                  "Login",
                  style: TextStyle(
                    color: ColorsReference.lightBlue,
                  ),
                ))
          ]),
        ]))));
  }

  Future handleRequest() async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailController.text.trim());
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Password Reset Link Sent', style: TextStyle(color: Colors.white),),
              backgroundColor: ColorsReference.darkBlue,
              content:
                  const Text('Please check your email to reset your password', style: TextStyle(color: Colors.white),),
              actions: <Widget>[
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.pop(context); // Close the dialog
                    Navigator.pop(context); // Return to the login page
                  },
                ),
              ],
            );
          });
    } on FirebaseAuthException catch (e) {
      print(e);
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Invalid Email'),
              content: const Text('Please enter a valid email address.'),
              actions: <Widget>[
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.pop(context); // Close the dialog
                  },
                ),
              ],
            );
          });
    }
  }
}
