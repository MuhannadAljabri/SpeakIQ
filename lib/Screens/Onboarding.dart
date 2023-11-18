import 'package:flutter/rendering.dart';
import 'package:speak_iq/main.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:flutter/material.dart';

class OnboardingScreen extends StatefulWidget {
  OnboardingScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _Onboard createState() => _Onboard();
}

class _Onboard extends State<OnboardingScreen> {
  final PageController _controller = PageController();

  bool lastPage = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(children: [
          Column(
            children: [
              Container(
                color: Colors.white,
                child: Column(children: [
                  Image(image: AssetImage('assets/onboard.png')),
                  Container(
                    alignment: Alignment.bottomCenter,
                    height: MediaQuery.sizeOf(context).height * 0.5,
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 245, 245, 245),
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(100),
                        topLeft: Radius.circular(100),
                      ),
                    ),
                    child: Container(
                      width: MediaQuery.sizeOf(context).width * 0.9,
                      child: const Column(
                        children: [
                          Text(
                            'Text about the features',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                height: 5,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                            ),
                          ),
                          Spacer(),
                          Row()
                        ],
                      ),
                    ),
                  )
                ]),
              )
            ],
          )
        ]),
      ),
    );
  }
}
