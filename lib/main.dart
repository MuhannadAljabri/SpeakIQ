import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:speak_iq/Screens/SpeakerSignup.dart';
import 'package:speak_iq/Screens/forgot_password.dart';
import '../Screens/splash.dart';
import '../Screens/UserSignup.dart';
import '../Screens/login.dart';
import '../Screens/SpeakerProfile.dart';
import '../Screens/Onboarding.dart';
import '../Screens/home_navigation_screen.dart';
import '../Screens/LoadingScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterDownloader.initialize(
    debug: true,
    ignoreSsl: true,
  );
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Check if the user is logged in using shared preferences
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

  // Determine which screen to show based on the user's login status
  Widget initialScreen = isLoggedIn ? const HomeNavigationScreen() : const SplashScreen();

  runApp(MaterialApp(
    initialRoute: '/',
    routes: {
      '/': (context) => initialScreen,
      '/splash': (context) => const SplashScreen(),
      '/user_signup': (context) => const UserSignup(),
      '/home': (context) => const HomeNavigationScreen(),
      '/onboarding': (context) => OnboardingScreen(),
      '/login': (context) => const LoginScreen(),
      '/speaker_signup': (context) => const SpeakerSignUp(),
      '/forgot_password': (context) => const ForgotPasswordScreen(),
      '/speaker_profile': (context) => const SpeakerProfile(),
      '/loading_screen': (context) => LoadingScreen(),
    },
  ));
}
