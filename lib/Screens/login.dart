import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
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
    return SafeArea(
        child: Scaffold(
      body: SingleChildScrollView(child: content()),
    )
    );
  }
  Widget content(){
    return Column(
      children: [
        Stack(
          //alignment: Alignment.center,
          children: [
            Container(
              height: 200,
              decoration: const BoxDecoration(
                color: Color.fromARGB(124, 245, 245, 245),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(100),
                  bottomRight: Radius.circular(100),
                ),
              ),
              child: Container(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children:[
                  Container(
                alignment: Alignment.center,
              margin: EdgeInsets.only(top: 20),
              child: Container(
                width: 65,
                height: 65,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: const Image(image: AssetImage('assets/MicDropLogoMain.png')),
                ),
              ),
            ),
            const SizedBox(height: 16),
              const Text(
                'Login to your account',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF212121),
                  fontSize: 16,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w700,
                  height: 0,
                ),),
              
          ]),),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
          child: Row(children: [
            const SizedBox(height: 20),
            Expanded(
              child: Container(
                child: TextField(
                  controller: usernameController,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 2.0, color: Color.fromRGBO(206, 206, 206, 0.5)),
                      borderRadius: BorderRadius.circular(50.0),
                    ),
                     focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 2.0, color: Color.fromRGBO(206, 206, 206, 0.5)),
                      borderRadius: BorderRadius.circular(50.0),
                     ),
                    labelText: 'Email*',
                    hintText: 'Enter your email',
                    contentPadding: const EdgeInsets.all(20.0),
                  ),
                ),
              ),
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
                child: TextField(
                  controller: passwordController,
                  obscureText: passwordVisible,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 2.0, color: Color.fromRGBO(206, 206, 206, 0.5)),
                      borderRadius: BorderRadius.circular(50.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 2.0, color: Color.fromRGBO(206, 206, 206, 0.5)),
                      borderRadius: BorderRadius.circular(50.0),
                     ),
                    
                    labelText: 'Password*',
                    hintText: 'Enter your password',
                    contentPadding: const EdgeInsets.all(20.0),
                    suffixIcon: IconButton(
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
                      if (kDebugMode) {
                        print("Error ${error.toString()}");
                      }
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
                    Navigator.pushReplacementNamed(context, '/user_signup');
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
