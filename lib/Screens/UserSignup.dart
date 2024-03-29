import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:speak_iq/Screens/Home.dart';
import 'package:speak_iq/Style/route_animation.dart';
import 'package:speak_iq/Style/colors.dart';
import 'package:speak_iq/Screens/login.dart';

class UserSignup extends StatefulWidget {
  const UserSignup({Key? key}) : super(key: key);

  @override
  _UserSignupState createState() => _UserSignupState();
}

class _UserSignupState extends State<UserSignup> {
  // Declare controllers for each text field
  TextEditingController fullNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  List<String> roles = [
    'Event Planner',
    'Speaker',
    'Other'
  ]; // Add your role options here
  String selectedRole = 'None'; // Set a default role
  String otherRoleText = ''; // Text entered for "Other" role
  bool passwordVisible = true;
  bool confirmPasswordVisible = true;

  // Validation status for each text field
  bool isFullNameValid = true;
  bool isLastNameValid = true;
  bool isEmailValid = true;
  bool isPhoneNumberValid = true;
  bool isPasswordValid = true;
  bool isConfirmPasswordValid = true;
  bool isOtherRoleValid = true;

  bool formSubmitted = false;

  FocusNode fullNameFocus = FocusNode();
  FocusNode lastNameFocus = FocusNode();
  FocusNode emailFocus = FocusNode();
  FocusNode phoneNumberFocus = FocusNode();
  FocusNode passwordFocus = FocusNode();
  FocusNode confirmPasswordFocus = FocusNode();
  FocusNode otherRoleFocus = FocusNode();

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
                  child: Container(
                    alignment: Alignment.center,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            'assets/speaksy_blue_logo.svg',
                            height: 100,
                            width: 200,
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
                              ? ColorsReference.borderColorGray
                              : const Color.fromRGBO(244, 67, 54, 1)),
                      borderRadius: BorderRadius.circular(50.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 2.0,
                        color: isFullNameValid
                            ? ColorsReference.borderColorGray
                            : ColorsReference.errorColorRed,
                      ),
                      borderRadius: BorderRadius.circular(50.0),
                    ),
                    labelText: 'First Name*',
                    hintText: 'Enter your first name',
                    errorText:
                        isFullNameValid ? null : 'Please enter your first name',
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
                          width: 2.0, color: ColorsReference.borderColorGray),
                      borderRadius: BorderRadius.circular(50.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 2.0,
                        color: isLastNameValid
                            ? ColorsReference.borderColorGray
                            : ColorsReference.errorColorRed,
                      ),
                      borderRadius: BorderRadius.circular(50.0),
                    ),
                    labelText: 'Last Name*',
                    hintText: 'Enter your last name',
                    errorText:
                        isLastNameValid ? null : 'Please enter your last name',
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
                          width: 2.0, color: ColorsReference.borderColorGray),
                      borderRadius: BorderRadius.circular(50.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 2.0,
                        color: isEmailValid
                            ? ColorsReference.borderColorGray
                            : ColorsReference.errorColorRed,
                      ),
                      borderRadius: BorderRadius.circular(50.0),
                    ),
                    labelText: 'Email*',
                    hintText: 'Enter your email',
                    errorText:
                        isEmailValid ? null : 'Please enter a valid email',
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
                          width: 2.0, color: ColorsReference.borderColorGray),
                      borderRadius: BorderRadius.circular(50.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 2.0,
                        color: isPhoneNumberValid
                            ? ColorsReference.borderColorGray
                            : ColorsReference.errorColorRed,
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
                              color: ColorsReference.borderColorGray),
                          borderRadius: BorderRadius.circular(50.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 2.0,
                            color: isPasswordValid
                                ? ColorsReference.borderColorGray
                                : ColorsReference.errorColorRed,
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
            // Confirmation Password text field
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
              child: Row(
                children: [
                  const SizedBox(height: 20),
                  Expanded(
                    child: Container(
                      child: TextField(
                        controller: confirmPasswordController,
                        focusNode: confirmPasswordFocus,
                        obscureText: confirmPasswordVisible,
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 2.0,
                              color: ColorsReference.borderColorGray,
                            ),
                            borderRadius: BorderRadius.circular(50.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 2.0,
                              color: ColorsReference.borderColorGray,
                            ),
                            borderRadius: BorderRadius.circular(50.0),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(50.0),
                          ),
                          labelText: 'Confirm Password*',
                          hintText: 'Confirm your password',
                          errorText: confirmPasswordController.text ==
                                  passwordController.text
                              ? null
                              : 'Passwords do not match',
                          contentPadding: const EdgeInsets.all(20.0),
                          suffixIcon: IconButton(
                            icon: Icon(confirmPasswordVisible
                                ? Icons.visibility_off
                                : Icons.visibility),
                            onPressed: () {
                              setState(
                                () {
                                  confirmPasswordVisible =
                                      !confirmPasswordVisible;
                                },
                              );
                            },
                          ),
                        ),
                        onSubmitted: (_) {
                          _validateAndSubmitForm();
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Roles drop down field
            Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
                child: Column(
                  children: [
                    Container(
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
                                color: ColorsReference.borderColorGray),
                            borderRadius: BorderRadius.circular(50.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                width: 2.0,
                                color: ColorsReference.borderColorGray),
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
                    // Additional text field for "Other" role
                    if (selectedRole == 'Other')
                      Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: Container(
                          child: TextField(
                            onChanged: (value) {
                              setState(() {
                                otherRoleText = value;
                              });
                            },
                            focusNode: otherRoleFocus,
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  width: 2.0,
                                  color: ColorsReference.borderColorGray,
                                ),
                                borderRadius: BorderRadius.circular(50.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  width: 2.0,
                                  color: isOtherRoleValid
                                      ? ColorsReference.borderColorGray
                                      : ColorsReference.errorColorRed,
                                ),
                                borderRadius: BorderRadius.circular(50.0),
                              ),
                              labelText: 'Other Role*',
                              hintText: 'Enter your role',
                              errorText: isOtherRoleValid
                                  ? null
                                  : 'Please enter your role',
                              contentPadding: const EdgeInsets.all(20.0),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                )),
            // Register button
            Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
                child: Container(
                  height: 48,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          ColorsReference.darkBlue),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                    onPressed: () {
                      _validateAndSubmitForm();
                    },
                    child: Text('Register', style: TextStyle(color: Colors.white),),
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
                          color: ColorsReference.lightBlue,
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
      isEmailValid = emailController.text.isNotEmpty &&
          _isValidEmail(emailController.text);
      isPhoneNumberValid = phoneNumberController.text.isEmpty ||
          _isValidPhoneNumber(phoneNumberController.text);
      isPasswordValid = passwordController.text.isNotEmpty &&
          _isPasswordValid(passwordController.text);
      isConfirmPasswordValid = confirmPasswordController.text.isNotEmpty &&
          confirmPasswordController.text == passwordController.text;
      isOtherRoleValid = otherRoleText.isNotEmpty && otherRoleText != 'Other';

      // Move focus to the first field with an invalid value
      if (!isFullNameValid) FocusScope.of(context).requestFocus(fullNameFocus);
      if (!isLastNameValid) FocusScope.of(context).requestFocus(lastNameFocus);
      if (!isEmailValid) FocusScope.of(context).requestFocus(emailFocus);
      if (!isPhoneNumberValid)
        FocusScope.of(context).requestFocus(phoneNumberFocus);
      if (!isPasswordValid) FocusScope.of(context).requestFocus(passwordFocus);
      if (!isConfirmPasswordValid)
        FocusScope.of(context).requestFocus(confirmPasswordFocus);
      String adjustedRole = selectedRole == 'Other'
          ? '$selectedRole: $otherRoleText'
          : selectedRole;
      if (selectedRole.toString() == 'Other' && !isOtherRoleValid)
        FocusScope.of(context).requestFocus(otherRoleFocus);
      // Submit the form if all fields are valid
      else {
        FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: emailController.text, password: passwordController.text)
            .then((value) {
          FirebaseDatabase.instance
              .ref()
              .child("users")
              .child(FirebaseAuth.instance.currentUser!.uid)
              .set({
            'firstName': fullNameController.text,
            'lastName': lastNameController.text,
            'email': emailController.text,
            'phoneNumber': phoneNumberController.text,
            'role': adjustedRole
          }).then((_) {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Congratulations!'),
                  content:
                      const Text('You have successfully created an account!'),
                  actions: <Widget>[
                    TextButton(
                      child: Text('OK'),
                      onPressed: () {
                        Navigator.pop(context); // Close the dialog
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          '/home', // This will clear the navigation stack
                          (Route<dynamic> route) => false,
                        );
                      },
                    ),
                  ],
                );
              },
            );
          }).catchError((error) {
            // Handle database write error
            print('Error writing to the database: $error');
            // You can show an error message to the user if needed
          });
        }).catchError((error) {
          // Handle authentication error
          print('Error creating user: $error');
          // Check if the error is due to the email already being in use
          if (error.code == 'email-already-in-use') {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Account Exists'),
                  content: const Text(
                      'An account with this email already exists. Please login or use a different email.'),
                  actions: <Widget>[
                    TextButton(
                      child: Text('OK'),
                      onPressed: () {
                        Navigator.pop(context); // Close the dialog
                      },
                    ),
                  ],
                );
              },
            );
          } else {
            // You can show a generic error message for other authentication errors
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Error'),
                  content: const Text('An error occurred. Please try again.'),
                  actions: <Widget>[
                    TextButton(
                      child: Text('OK'),
                      onPressed: () {
                        Navigator.pop(context); // Close the dialog
                      },
                    ),
                  ],
                );
              },
            );
          }
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
