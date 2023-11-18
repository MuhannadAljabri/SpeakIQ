//import 'dart:html';
import 'package:flutter/material.dart';
import 'package:speak_iq/Screens/SpeakerSignup.dart';
import '../Screens/splash.dart';
import '../Screens/UserSignup.dart';
import '../Screens/login.dart';
import '../Screens/Home.dart';
import '../Screens/Onboarding.dart';
//import 'package:firebase_core/firebase_core.dart';
//import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //await Firebase.initializeApp( options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    //return const MaterialApp(
    //home: SplashScreen(),
    //);
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/user_signup': (context) => const UserSignup(),
        '/home': (context) => const HomeScreen(),
<<<<<<< Updated upstream
        '/onboarding': (context) => OnboardingScreen(),
        '/login': (context) => const LoginScreen(),
=======
        '/onboarding': (context) => const OnboardingScreen(),
        '/login':(context) => const LoginScreen(),
        '/speaker_signup':(context) => const UploadImageAndPDF()
>>>>>>> Stashed changes
      },
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Main Screen'),
      ),
      body: const Center(
        child: Text('Welcome to the main screen!'),
      ),
    );
  }
}
