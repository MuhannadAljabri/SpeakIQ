import 'package:flutter/material.dart';
import 'package:speak_iq/Screens/SpeakerSignup.dart';
import 'package:speak_iq/Screens/forgot_password.dart';
import '../Screens/splash.dart';
import '../Screens/UserSignup.dart';
import '../Screens/login.dart';
import '../Screens/SpeakerProfile.dart';
import '../Screens/Onboarding.dart';
import '../Screens/home_navigation_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      // Routes
      routes: {
        '/': (context) => const SplashScreen(),
        '/user_signup': (context) => const UserSignup(),
        '/home': (context) => HomeNavigationScreen(),
        '/onboarding': (context) => OnboardingScreen(),
        '/login': (context) => const LoginScreen(),
        '/speaker_signup': (context) => const SpeakerSignUp(),
        '/forgot_password': (context) => const ForgotPasswordScreen(),
        '/speaker_profile': (context) => const SpeakerProfile()
      },
    );
  }
}
