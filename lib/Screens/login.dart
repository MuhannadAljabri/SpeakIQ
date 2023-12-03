import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:speak_iq/Screens/SpeakerSignup.dart';
import 'package:speak_iq/Screens/UserSignup.dart';
import 'package:speak_iq/Screens/forgot_password.dart';
import 'package:speak_iq/style/colors.dart';
import 'package:speak_iq/style/route_animation.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:speak_iq/style/style.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => LoginState();
}

class LoginState extends State<LoginScreen> {
  final formField = GlobalKey<FormState>();
  TextEditingController passwordController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  bool passwordVisible = true;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            body: SingleChildScrollView(
      child: ConstrainedBox(
          constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height -
                  MediaQuery.of(context).padding.top),
          child: content()),
    )));
  }

  Widget content() {
    return Column(children: [
      Stack(
        //alignment: Alignment.center,
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
            'assets/speaksy_blue_logo.svg', height: 100, width: 200,),
            SizedBox(height: 16,),
          
                    
                    
                    const Text(
                      'Login to your account',
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
        ],
      ),
      const SizedBox(height: 10),
      Form(
          key: formField,
          child: Column(children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
              child: Row(children: [
                const SizedBox(height: 20),
                Expanded(
                  child: RequiredTextField(hintText: "Enter your email", labelText: "Email", textController: emailController)
                ),
              ]),
            ),
            const SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
              child: Row(children: [
                const SizedBox(height: 20),
                Expanded(
                  child: Container(
                      child: TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'This field is required';
                          }
                        },
                        controller: passwordController,
                        obscureText: passwordVisible,
                        decoration: InputDecoration(
                          labelStyle: TextStyle(color: ColorsReference.textColorBlack),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                width: 2.0,
                                color: Color.fromRGBO(206, 206, 206, 0.5)),
                            borderRadius: BorderRadius.circular(50.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                width: 2.0,
                                color: Color.fromRGBO(44, 44, 44, 0.494)),
                            borderRadius: BorderRadius.circular(50.0),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(50.0),
                          ),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          labelText: 'Password',
                          hintText: 'Enter your password',
                          contentPadding:
                              const EdgeInsets.only(top: 20, left: 25),
                          suffixIcon: IconButton(
                            color: ColorsReference.darkBlue,
                            icon: Icon(passwordVisible
                                ? Icons.visibility_off
                                : Icons.visibility),
                            onPressed: () {
                              setState(
                                () {
                                  passwordVisible = !passwordVisible;
                                },
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                ),
              ]),
            ),
          ])),
      const SizedBox(height: 0),
      Padding(
          padding: const EdgeInsets.only(right: 16),
          child: Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {
                Navigator.of(context)
                    .push(slidingFromDown(ForgotPasswordScreen()));
              },
              child: const Text("Forgot password?",
                  style: TextStyle(
                    color: ColorsReference.lightBlue,
                  )),
            ),
          )),
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
                  if (formField.currentState!.validate()) {
                    FirebaseAuth.instance
                        .signInWithEmailAndPassword(
                            email: emailController.text,
                            password: passwordController.text)
                        .then((value) {
                      Navigator.pushReplacementNamed(context, '/home');
                    }).onError((error, stackTrace) {
                      if (kDebugMode) {
                        print("Error ${error.toString()}");
                        // const snackBar = SnackBar(
                        //   content: Text('Account not found. Please check your username or password and try again.'),
                        //   backgroundColor: Color(0xFF2CA6A4),
                        //   behavior: SnackBarBehavior.floating,
                        //   duration: Duration(seconds: 3), // Adjust the duration as needed
                        // );
                        // ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        AlertDialog alert = AlertDialog(
                          title: Text("Account Not Found"),
                          content: Text(
                              "Account not found. Kindly verify your username or password and try again."),
                          actions: [
                            TextButton(
                              child: Text("OK"),
                              onPressed: () {},
                            )
                          ],
                        );

                        // show the dialog
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return alert;
                          },
                        );
                      }
                    });
                  }
                },
                child: const Text("Login",
                    style: TextStyle(
                      color: Colors.white,
                    ))),
          )),
      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text("Don't have an account?",
            style:
                TextStyle(color: Colors.black.withOpacity(0.5), fontSize: 14)),
        TextButton(
            onPressed: () {
              Navigator.of(context).push(slidingFromDown(UserSignup()));
            },
            child: const Text(
              "Register",
              style: TextStyle(
                color: ColorsReference.lightBlue,
              ),
            ))
      ]),
      const Spacer(),
     Padding(padding: EdgeInsets.only(bottom: 30),child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text("Are you a speaker?",
            style:
                TextStyle(color: Colors.black.withOpacity(0.5), fontSize: 14)),
        TextButton(
            onPressed: () {
              Navigator.of(context).push(slidingFromDown(SpeakerSignUp()));
            },
            child: const Text(
              "Join Now",
              style: TextStyle(
                color: ColorsReference.lightBlue,
              ),
            ))
      ]))
    ]);
  }

  bool isEmail(String em) {
    String p =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = RegExp(p);
    return regExp.hasMatch(em);
  }
}
