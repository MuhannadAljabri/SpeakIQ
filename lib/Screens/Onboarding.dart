import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:speak_iq/Screens/login.dart';
import 'package:speak_iq/main.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:flutter/material.dart';
import 'package:speak_iq/style/route_animation.dart';

class OnboardingScreen extends StatefulWidget {
  OnboardingScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _Onboard createState() => _Onboard();
}

class _Onboard extends State<OnboardingScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: content(),
    ));
  }

  Widget content() {
    return Column(
      children: [
        // Your content above the colored box
        const Expanded(
          child: Column(
            children: [Image(image: AssetImage('assets/onboard.png'))],
          ),
        ),

        // Colored box from the bottom to the middle
        Container(
          height: MediaQuery.of(context).size.height / 2,
          decoration: const BoxDecoration(
            color: Color.fromARGB(255, 245, 245, 245),
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(100),
              topLeft: Radius.circular(100),
            ),
          ),
          child: Column(
            children: [
              const Text(
                'Text about the features',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    height: 5,
                    fontWeight: FontWeight.bold),
              ),
              const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                    ),
                  )),
              SizedBox(height: 66),
              Row(
                children: [
                  IconButton(
                    padding: EdgeInsets.only(left: 35, right: 10),
                    iconSize: 28,
                    icon: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: Color.fromRGBO(33, 33, 33, 0.2),
                    ),
                    onPressed: () {},
                  ),
                  const Text(
                    'PREVIOUS',
                    style: TextStyle(
                      color: Color.fromRGBO(33, 33, 33, 0.2),
                      fontFamily: 'Poppins',
                      fontSize: 16,
                      letterSpacing:
                          0 /*percentages not used in flutter. defaulting to zero*/,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  Spacer(),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(slidingFromLeft(LoginScreen()));
                    },
                    child: const Text(
                      'GET STARTED',
                      style: TextStyle(
                        color: Color.fromRGBO(44, 166, 164, 1),
                        fontFamily: 'Poppins',
                        fontSize: 16,
                        letterSpacing:
                            0 /*percentages not used in flutter. defaulting to zero*/,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                  IconButton(
                    padding: EdgeInsets.only(left: 10, right: 35),
                    iconSize: 28,
                    icon: const Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: Color.fromRGBO(44, 166, 164, 1),
                    ),
                    onPressed: () {
                      // Navigate back to the previous screen
                      Navigator.of(context).push(slidingFromLeft(LoginScreen()));
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
