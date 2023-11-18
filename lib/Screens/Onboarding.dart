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
    return Scaffold(
        body: Stack(children: [
      PageView(
        controller: _controller,
        onPageChanged: (index) {
          setState(() {
            lastPage = (index == 1);
          });
        },
        children: [
          Container(
              color: Colors.white,
              //child:Image(image: AssetImage('assets/MicDropLogoMain.png'))
              child: const Column(
                  //crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Image(image: AssetImage('assets/MicDropLogoMain.png')),
                    Center(
                      child: Text(
                        'Text about the features',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            height: 5,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Center(
                        child: Text(
                            'asdasdasddddasdkljaslkdlasdjlasjdlkadddddddddddddddaaaaaaa',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                            )))
                  ])),
          Container(
              color: Colors.white,
              child: const Column(children: [
                Image(image: AssetImage('assets/MicDropLogoMain.png')),
                Center(
                  child: Text(
                    'Text about the features',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        height: 5,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Center(
                    child: Text(
                        'asdasdasddddasdkljaslkdlasdjlasjdlkadddddddddddddddaaaaaaa',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                        )))
              ])),
        ],
      ),
      Container(
          alignment: Alignment(0, 0.80),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            GestureDetector(
              onTap: () {
                _controller.previousPage(
                    duration: Duration(milliseconds: 500),
                    curve: Curves.easeIn);
              },
              child: const Text('< PREVIOUS',
                  style: TextStyle(
                    color: Color.fromARGB(255, 42, 142, 150),
                    fontSize: 20,
                  )),
            ),
            SmoothPageIndicator(controller: _controller, count: 2),

            //next button
            lastPage
                ? GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return HomeScreen();
                          },
                        ),
                      );
                    },
                    child: const Text('GET STARTED >',
                        style: TextStyle(
                          color: Color.fromARGB(255, 42, 142, 150),
                          fontSize: 20,
                        )))
                : GestureDetector(
                    onTap: () {
                      _controller.nextPage(
                        duration: Duration(milliseconds: 500),
                        curve: Curves.easeIn,
                      );
                    },
                    child: const Text('NEXT >',
                        style: TextStyle(
                          color: Color.fromARGB(255, 42, 142, 150),
                          fontSize: 20,
                        )))
          ]))
    ]));
  }
}
