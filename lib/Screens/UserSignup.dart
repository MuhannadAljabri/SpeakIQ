import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:speak_iq/Screens/login.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:speak_iq/style/route_animation.dart';

class UserSignup extends StatefulWidget {
  const UserSignup({Key? key}) : super(key: key);

  @override
  _UserSignupState createState() => _UserSignupState();
}

class _UserSignupState extends State<UserSignup> {

  Color primaryColor =const Color.fromRGBO(206, 206, 206, 0.5); // Main textfield border color
  Color errorColor = const Color.fromRGBO(244, 67, 54, 1);// Error textfield border color

  // Declare controllers for each text field
  TextEditingController fullNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  List<String> roles = [
    'None',
    'Event Planner',
    'Speaker',
    'Other'
  ]; // Add your role options here
  String selectedRole = 'None'; // Set a default role
  bool passwordVisible = true;
  
  // Validation status for each text field
  bool isFullNameValid = true;
  bool isLastNameValid = true;
  bool isEmailValid = true;
  bool isPhoneNumberValid = true;
  bool isPasswordValid = true;

  bool formSubmitted = false;

  FocusNode fullNameFocus = FocusNode();
  FocusNode lastNameFocus = FocusNode();
  FocusNode emailFocus = FocusNode();
  FocusNode phoneNumberFocus = FocusNode();
  FocusNode passwordFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header (Logo, Text, Back Button, background)
            Stack(
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
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          alignment: Alignment.center,
                          margin: EdgeInsets.only(top: 20),
                          child: Container(
                            width: 65,
                            height: 65,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: const Image(
                                  image:
                                      AssetImage('assets/MicDropLogoMain.png')),
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
                          ),
                        ),
                      ]),
                ),
                Container(
                  height: 200,
                  decoration: const BoxDecoration(
                    color: Color.fromRGBO(0, 0, 0, 0),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(100),
                      bottomRight: Radius.circular(100),
                    ),
                  ),
                  child: IconButton(
                    alignment: Alignment.topLeft,
                    padding: EdgeInsets.only(left: 30, top: 50),
                    iconSize: 28,
                    icon: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      // Navigate back to the previous screen
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),
            // Name Text Field
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
              child: Container(
                child: TextField(
                  controller: fullNameController,
                  focusNode: fullNameFocus,
                  onChanged: (value) {
                    setState(() {
                        isFullNameValid = formSubmitted
                            ? value.isNotEmpty
                            : true; // Only validate if the form is submitted
                      });
                  },
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          width: 2.0,
                          color: isFullNameValid
                              ? primaryColor
                              : const Color.fromRGBO(244, 67, 54, 1)),
                      borderRadius: BorderRadius.circular(50.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 2.0,
                        color: isFullNameValid
                            ? primaryColor
                            : errorColor,
                      ),
                      borderRadius: BorderRadius.circular(50.0),
                    ),
                    labelText: 'First Name*',
                    hintText: 'Enter your first name',
                    errorText: isFullNameValid
                        ? null
                        : 'Please enter your first name',
                    contentPadding: const EdgeInsets.all(20.0),
                    //prefixText: prefixText,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onSubmitted: (_) {
                      _validateAndSubmitForm();
                    },
                ),
              ),
            ),
            // Last name text field
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
              child: Container(
                child: TextField(
                  controller: lastNameController,
                  focusNode: lastNameFocus,
                  onChanged: (value) {
                    setState(() {
                        isLastNameValid = formSubmitted
                            ? value.isNotEmpty
                            : true; // Only validate if the form is submitted
                      });
                  },
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          width: 2.0,
                          color: primaryColor),
                      borderRadius: BorderRadius.circular(50.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 2.0,
                        color: isLastNameValid
                            ? primaryColor
                            : errorColor,
                      ),
                      borderRadius: BorderRadius.circular(50.0),
                    ),
                    labelText: 'Last Name*',
                    hintText: 'Enter your last name',
                    errorText: isLastNameValid
                        ? null
                        : 'Please enter your last name',
                    contentPadding: const EdgeInsets.all(20.0),
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
                child: TextField(
                  controller: emailController,
                  focusNode: emailFocus,
                  onChanged: (value) {
                    setState(() {
                        isEmailValid = formSubmitted
                            ? value.isNotEmpty
                            : true; // Only validate if the form is submitted
                      });
                  },
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          width: 2.0,
                          color: primaryColor),
                      borderRadius: BorderRadius.circular(50.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 2.0,
                        color: isEmailValid
                            ? primaryColor
                            : errorColor,
                      ),
                      borderRadius: BorderRadius.circular(50.0),
                    ),
                    labelText: 'Email*',
                    hintText: 'Enter your email',
                    errorText: isEmailValid
                        ? null
                        : 'Please enter a valid email',
                    contentPadding: const EdgeInsets.all(20.0),
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
                child: TextField(
                  controller: phoneNumberController,
                  focusNode: phoneNumberFocus,
                  onChanged: (value) {
                    setState(() {
                        isPhoneNumberValid = formSubmitted
                            ? value.isNotEmpty
                            : true; // Only validate if the form is submitted
                      });
                  },
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          width: 2.0,
                          color: primaryColor),
                      borderRadius: BorderRadius.circular(50.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 2.0,
                        color: isPhoneNumberValid
                            ? primaryColor
                            : errorColor,
                      ),
                      borderRadius: BorderRadius.circular(50.0),
                    ),
                    labelText: 'Phone Number',
                    hintText: 'Enter your phone number',
                    errorText: isPhoneNumberValid
                        ? null
                        : 'Please enter a valid phone number (+1XXXXXXXXXX)',
                    contentPadding: const EdgeInsets.all(20.0),
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
              child: Row(children: [
                const SizedBox(height: 20),
                Expanded(
                  child: Container(
                    child: TextField(
                      controller: passwordController,
                      focusNode: passwordFocus,
                      obscureText: passwordVisible,
                      onChanged: (value) {
                        setState(() {
                            isPasswordValid = formSubmitted
                                ? value.isNotEmpty
                                : true; // Only validate if the form is submitted
                          });
                      },
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              width: 2.0,
                              color: primaryColor),
                          borderRadius: BorderRadius.circular(50.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 2.0,
                            color: isPasswordValid
                                ? primaryColor
                                : errorColor,
                          ),
                          borderRadius: BorderRadius.circular(50.0),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50.0),
                        ),
                        labelText: 'Password*',
                        hintText: 'Enter your password',
                        errorText: isPasswordValid
                        ? null
                        : 'Your password should have at least 6 characters',
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
            // Roles drop down field
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
              child: Container(
                child: DropdownButtonFormField(
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
                      borderSide: BorderSide(
                          width: 2.0,
                          color: primaryColor),
                      borderRadius: BorderRadius.circular(50.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          width: 2.0,
                          color: primaryColor),
                      borderRadius: BorderRadius.circular(50.0),
                    ),
                    labelText: 'Role',
                    hintText: 'Select your role',
                    contentPadding: const EdgeInsets.all(20.0),
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
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Color(0xFF2CA6A4)),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                    onPressed: () {
                      _validateAndSubmitForm();
                    },
                    child: Text('Register'),
                  ),
                )),
            // Navigate to login page
            Padding(
              padding: const EdgeInsets.only(top: 30, bottom: 30),
              child: GestureDetector(
                onTap: () {
                  // Navigate to the login page
                  Navigator.pop(context);
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
    ));
  }

  void _validateAndSubmitForm() {
    // Set the formSubmitted flag to true
    setState(() {
      formSubmitted = true;
    });
    // Validate each field
    setState(() {
      isFullNameValid = fullNameController.text.isNotEmpty;
      isLastNameValid = lastNameController.text.isNotEmpty;
      isEmailValid = emailController.text.isNotEmpty && _isValidEmail(emailController.text);
      isPhoneNumberValid = phoneNumberController.text.isEmpty || _isValidPhoneNumber(phoneNumberController.text);
      isPasswordValid = passwordController.text.isNotEmpty && _isPasswordValid(passwordController.text);

      // Move focus to the first field with an invalid value
      if (!isFullNameValid) 
        FocusScope.of(context).requestFocus(fullNameFocus);
      if (!isLastNameValid) 
        FocusScope.of(context).requestFocus(lastNameFocus);
      if (!isEmailValid) 
        FocusScope.of(context).requestFocus(emailFocus);
      if (!isPhoneNumberValid) 
        FocusScope.of(context).requestFocus(phoneNumberFocus);
      if (!isPasswordValid) 
        FocusScope.of(context).requestFocus(passwordFocus);
      // Submit the form if all fields are valid
      else {
        FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: emailController.text,
                password: passwordController.text)
            .then((value) {
          FirebaseDatabase.instance
              .ref()
              .child("users")
              .child(FirebaseAuth.instance.currentUser!.uid)
              .set({
            'first name': fullNameController.text,
            'email': emailController.text,
            'role': selectedRole.toString()
          });
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
                      Navigator.pop(context); // Close the dialog
                      Navigator.pushReplacementNamed(context, '/home');
                    },
                  ),
                ],
              );
            },
          );
        });
      }
    });
  }

  bool _isValidEmail(String email) {
    // Use a regular expression to check the email format
    // You can modify this regex to suit your requirements
    RegExp emailRegex = RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');
    return emailRegex.hasMatch(email);
  }

  bool _isValidPhoneNumber(String phoneNumber) {
    // Use a regular expression to check the phone number format
    // ^ asserts the start of the string.
    // \+? allows an optional plus sign for the country code.
    // \d{0,3} allows for up to 3 digits for the country code.
    // \d{10} requires exactly 10 digits for the main part of the phone number.
    // $ asserts the end of the string.
    RegExp phoneRegex = RegExp(r'^\+?\d{0,3}?\d{8,15}$');
    return phoneRegex.hasMatch(phoneNumber);
  }

  bool _isPasswordValid(String password) {
    return password.length >= 6;
  }
}
