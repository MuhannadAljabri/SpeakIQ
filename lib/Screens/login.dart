import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {


  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => LoginState();

}

class LoginState extends State<LoginScreen>{


  TextEditingController passwordController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  bool passwordVisible = true;

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body:SingleChildScrollView(child: content()),

    );
  }
  Widget content(){
    return Column(
      children: [
        Container(
            height: 250,
            width: double.infinity,
            decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.elliptical(100, 100),
                    bottomRight: Radius.elliptical(100, 100)
                )
            ),
            child: Padding(
              padding: const EdgeInsets.only(top:70.0),
              child: Column(
                children: [
                  Image.asset(
                      'lib/assets/MicDropLogoMain.png',
                      scale: 5
                  ),
                  const SizedBox(height: 20),
                  const Text(
                      'Login to your account',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14
                      )
                  )
                ],
              ),
            )
        ),
        const SizedBox(
            height: 10
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
          child: Row(
              children: [
                const SizedBox(height: 20),
                Expanded(
                  child: Container(
                    child: TextField(
                      controller: usernameController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50.0),
                        ),
                        labelText: 'Username',
                        hintText: 'Enter your email',
                        contentPadding: const EdgeInsets.all(20.0),
                      ),
                    ),
                  ),
                ),
              ]
          ),
        ),
        const SizedBox(
            height: 10
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
          child: Row(
              children: [
                const SizedBox(height: 20),
                Expanded(
                  child: Container(
                    child: TextField(
                      controller: passwordController,
                      obscureText: passwordVisible,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50.0),
                        ),
                        labelText: 'Password',
                        hintText: 'Enter your password',
                        contentPadding: const EdgeInsets.all(20.0),
                        suffixIcon: IconButton(
                          icon: Icon(passwordVisible
                              ? Icons.visibility
                              : Icons.visibility_off),
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
              ]
          ),
        ),
        const SizedBox(
            height: 0
        ),
        Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: (){},
                child: const Text(
                    "Forgot password?",
                    style: TextStyle(
                      color: Color(0xFF2CA6A4),
                    )
                ),
              ),
            )
        ),
        const SizedBox(
            height: 0
        ),
        Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
            child: Container(
              height: 50,
              width: 500,
              decoration: BoxDecoration(
                color: const Color(0xFF2CA6A4),
                borderRadius: BorderRadius.circular(50.0),
              ),
              child: TextButton(
                  onPressed: (){
                    FirebaseAuth.instance.signInWithEmailAndPassword(
                        email: usernameController.text,
                        password: passwordController.text)
                        .then((value) {
                      Navigator.pushReplacementNamed(context, '/home');
                    }).onError((error, stackTrace){
                      print("Error ${error.toString()}");
                    });

                  },
                  child: const Text(
                      "Login",
                      style: TextStyle(
                        color: Colors.white,
                      )
                  )
              ),
            )
        ),
        Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                  "Don't have an account?",
                  style: TextStyle(
                      color: Colors.black.withOpacity(0.5),
                      fontSize: 14
                  )
              ),
              TextButton(
                  onPressed: (){
                    Navigator.pushReplacementNamed(context, '/signup');
                  },
                  child: const Text(
                    "Register",
                    style: TextStyle(
                      color: Color(0xFF2CA6A4),

                    ),
                  )
              )
            ]
        )

      ],
    );
  }
}
