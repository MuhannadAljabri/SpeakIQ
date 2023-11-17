import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:speak_iq/Screens/login.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';

class UserSignup extends StatefulWidget {
  const UserSignup({Key? key}) : super(key: key);

  @override
  _UserSignupState createState() => _UserSignupState();
}

class _UserSignupState extends State<UserSignup> {

  List<String> roles = ['Event Planner', 'Speaker', 'Other']; // Add your role options here
  String selectedRole = 'None'; // Set a default role
  bool passwordVisible = true;
  Color primaryColor = const Color.fromRGBO(206, 206, 206, 0.5);

  // Declare controllers for each text field
  TextEditingController fullNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: 
        Scaffold(
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header (Logo, Text, Back Button, background)
              Stack(
          //alignment: Alignment.center,
          children: [
            Container(
              height: 200,
              decoration: const BoxDecoration(
                color: Color.fromRGBO(0, 0, 0, 0),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(100),
                  bottomRight: Radius.circular(100),
                ),
              ),
              child: 
            IconButton(
              alignment: Alignment.topLeft,
                      padding: EdgeInsets.only(left: 20, top: 40),
                      iconSize: 28,
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        // Navigate back to the previous screen
                    Navigator.pushReplacementNamed(context, '/login');
                      },
                    ),
                  ),
            Container(
              height: 200,
              decoration: const BoxDecoration(
                color: Color.fromARGB(124, 245, 245, 245),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(100),
                  bottomRight: Radius.circular(100),
                ),
              ),
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
                'Register new account',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF212121),
                  fontSize: 16,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w700,
                  height: 0,
                ),),
              
          ]),),
            
          ],
        ),
              // Name Text Field
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
                child: Container(
                  height: 59,
                  child: TextField(
                    controller: fullNameController,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 2.0, color: Color.fromRGBO(206, 206, 206, 0.5)),
                      borderRadius: BorderRadius.circular(50.0),
                    ),
                     focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 2.0, color: Color.fromRGBO(206, 206, 206, 0.5)),
                      borderRadius: BorderRadius.circular(50.0),
                     ),
                      labelText: 'Full Name*',
                      hintText: 'Enter your full name',
                      //prefixText: prefixText,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                ),
              ),
              // Last name text field
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
                child: Container(
                  height: 59,
                  child: TextField(
                    controller: lastNameController,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 2.0, color: Color.fromRGBO(206, 206, 206, 0.5)),
                      borderRadius: BorderRadius.circular(50.0),
                    ),
                     focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 2.0, color: Color.fromRGBO(206, 206, 206, 0.5)),
                      borderRadius: BorderRadius.circular(50.0),
                     ),
                      labelText: 'Last Name*',
                      hintText: 'Enter your last name',
                      //prefixText: prefixText,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                ),
              ),
              // Email text field
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
                child: Container(
                  height: 59,
                  child: TextField(
                    controller: emailController,
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
                      //prefixText: prefixText,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                ),
              ),
              // Phone number text field
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
                child: Container(
                  height: 59,
                  child: TextField(
                    controller: phoneNumberController,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 2.0, color: Color.fromRGBO(206, 206, 206, 0.5)),
                      borderRadius: BorderRadius.circular(50.0),
                    ),
                     focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 2.0, color: Color.fromRGBO(206, 206, 206, 0.5)),
                      borderRadius: BorderRadius.circular(50.0),
                     ),
                      labelText: 'Phone Number',
                      hintText: 'Enter your phone number',
                      //prefixText: prefixText,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                ),
              ),
              // Password text field
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
                child: Row(
                    children: [
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
                              border: OutlineInputBorder(
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
                    ]
                ),
              ),
              // Roles drop down field
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
                child: 
                  Container(
                    height: 59,
                    child: 
                      DropdownButtonFormField(
                        items: roles.map((role) {
                          return DropdownMenuItem(
                            value: role,
                            child: Text(role),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedRole = value.toString();
                          });
                        },
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 2.0, color: Color.fromRGBO(206, 206, 206, 0.5)),
                      borderRadius: BorderRadius.circular(50.0),
                    ),
                     focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 2.0, color: Color.fromRGBO(206, 206, 206, 0.5)),
                      borderRadius: BorderRadius.circular(50.0),
                     ),
                        labelText: 'Role*',
                        hintText: 'Select your role',
                        //prefixText: prefixText,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                  ),
              ),
              // Register button
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
                child: Container(
                  height: 48,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Color(0xFF2CA6A4)),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                  onPressed: () {
                    FirebaseAuth.instance.createUserWithEmailAndPassword(email: emailController.text, password: passwordController.text).then((value) => 
                    Navigator.pushReplacementNamed(context, '/home'));
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Congratulations!'),
                          content: const Text('You have successfully created an account!'),
                          actions: <Widget>[
                            TextButton(
                              child: Text('OK'),
                              onPressed: () {
                                Navigator.of(context).pop(); // Close the dialog
                              },
                            ),
                          ],
                        );
                      },
                    );
                    print("Full Name: ${fullNameController.text}");
                    print("Last Name: ${lastNameController.text}");
                    print("Email: ${emailController.text}");
                    print("Phone Number: ${phoneNumberController.text}");
                    print("Password: ${passwordController.text}");
                    //print("Role: ${roleController.text}");
                },
                child: Text('Register'),
                ),
                )
              ),
              // Navigate to login page
              Padding(
                padding: const EdgeInsets.only(top: 30, bottom: 30),
                child: GestureDetector(
                  onTap: () {
                    // Navigate to the login page
                    Navigator.pushReplacementNamed(
                      context,
                      '/login',
                    );
                  },
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: 'Already have an account? ',
                          style: TextStyle(
                            color: Colors.black.withOpacity(0.5),
                            fontSize: 14,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w400,
                            height: 0,
                          ),
                        ),
                        TextSpan(
                          text: 'Login',
                          style: TextStyle(
                            color: Color(0xFF2CA6A4),
                            fontSize: 14,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w600,
                            height: 0,
                          ),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ),
      )
    );
  }
}
