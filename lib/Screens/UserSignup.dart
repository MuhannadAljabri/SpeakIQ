import 'package:flutter/material.dart';

class UserSignup extends StatefulWidget {
  const UserSignup({Key? key}) : super(key: key);

  @override
  _UserSignupState createState() => _UserSignupState();
}

class _UserSignupState extends State<UserSignup> {

  List<String> roles = ['None', 'Event Planner', 'Speaker', 'Others']; // Add your role options here
  String selectedRole = 'None'; // Set a default role
  bool passwordVisible = true;

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
                children: [
                  Container(
                    height: 140,
                    decoration: BoxDecoration(
                      color: Color.fromARGB(124, 201, 201, 201),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(100),
                        bottomRight: Radius.circular(100),
                      ),
                    ),
                  ),
                  Container(
                    width: 28, // Adjust the width to fit the IconButton
                    height: 28, // Adjust the height to fit the IconButton
                    margin: EdgeInsets.only(left: 16, top: 16),
                    decoration: ShapeDecoration(
                      color: Colors.black.withOpacity(0.05),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      iconSize: 28,
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        // Navigate back to the previous screen
                        Navigator.pop(context);
                      },
                    ),
                  ),

                  Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.only(top: 100),
                    child: Text(
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
                  ),
                  Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(top: 20),
                    child: Container(
                      width: 65,
                      height: 65,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: Image(image: AssetImage('assets/MicDropLogoMain.png')),
                      ),
                    ),
                  ),
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
                      labelText: 'Full Name',
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
                      labelText: 'Last Name',
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
                      labelText: 'Email',
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
              // Roles drop down field
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
                child: 
                  Container(
                    height: 59,
                    child: 
                      DropdownButtonFormField(
                        value: selectedRole,
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
                        labelText: 'Role',
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
                    Navigator.pushReplacementNamed(context, '/home');
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
