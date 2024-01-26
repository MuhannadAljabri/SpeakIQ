import 'package:flutter/material.dart';
import 'package:speak_iq/Screens/change_password.dart';
import '../Style/route_animation.dart';
import '../Style/colors.dart';

class UserPersonalInfo extends StatefulWidget {
  const UserPersonalInfo({Key? key}) : super(key: key);

  @override
  State<UserPersonalInfo> createState() => UserPersonalInfoState();
}

class UserPersonalInfoState extends State<UserPersonalInfo> {
  
  List<String> roles = [
      'Event Planner',
      'Speaker',
      'Other'
    ];
  String selectedRole = 'None'; // Original role
  String otherRoleText = ''; // Text entered for "Other" role

  bool isOtherRoleValid = true;

  bool formSubmitted = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.black,
            ),
            onPressed: () {
              // Navigate back to the previous screen
              Navigator.pop(context);
            },
          ),
          title: const Text(
            'Personal Information',
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
            ),
          ),
          centerTitle: true,
          actions: [
            TextButton(
              onPressed: () {
                // Handle save button click
              },
              child: const Text(
                'Save',
                style: TextStyle(
                  color: ColorsReference.lightBlue,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
        body: ListView(
          children: [
            const SizedBox(height: 16),
            // First Name
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: TextField(
                //controller: firstNameController,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'First Name',
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  hintText: 'Dan',
                  contentPadding: const EdgeInsets.all(16.0),
                  labelStyle: const TextStyle(
                    color: ColorsReference.textColorBlack, 
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: ColorsReference.borderColorGray,
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.circular(30),                    
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: ColorsReference.borderColorGray,
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            ),
            // Last Name
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: TextField(
                //controller: lastNameController,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Last Name',
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  hintText: 'John',
                  contentPadding: const EdgeInsets.all(16.0),
                  labelStyle: const TextStyle(
                    color: ColorsReference.textColorBlack, 
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: ColorsReference.borderColorGray,
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.circular(30),                    
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: ColorsReference.borderColorGray,
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            ),
            // Email address
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: TextField(
                //controller: emailController,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Email',
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  hintText: 'john@mail.com',
                  contentPadding: const EdgeInsets.all(16.0),
                  labelStyle: const TextStyle(
                    color: ColorsReference.textColorBlack,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: ColorsReference.borderColorGray,
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.circular(30),                    
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: ColorsReference.borderColorGray,
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            ),
            // Phone number
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: TextField(
                //controller: phoneNumberController,
                //readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Phone number',
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  hintText: '+1 1234567890',
                  contentPadding: const EdgeInsets.all(16.0),
                  labelStyle: const TextStyle(
                    color: ColorsReference.textColorBlack,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: ColorsReference.borderColorGray,
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.circular(30),                    
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: ColorsReference.borderColorGray,
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            ),
            // Roles drop down field
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: Column(
                children: [
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
                        borderSide: const BorderSide(
                            width: 2.0,
                            color: ColorsReference.borderColorGray),
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                            width: 2.0,
                            color: ColorsReference.borderColorGray),
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                      labelText: 'Role',
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      labelStyle: const TextStyle(
                        color: ColorsReference.textColorBlack,
                      ),
                      hintText: selectedRole,
                      contentPadding: const EdgeInsets.all(16.0),
                      //prefixText: prefixText,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                  // Additional text field for "Other" role
                  if (selectedRole == 'Other')
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: TextField(
                        onChanged: (value) {
                          setState(() {
                            otherRoleText = value;
                          });
                        },
                        //focusNode: otherRoleFocus,
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
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
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          labelStyle: const TextStyle(
                            color: ColorsReference.textColorBlack,
                          ),
                          hintText: 'Enter your role',
                          errorText: isOtherRoleValid
                            ? null
                            : 'Please enter your role',
                          contentPadding: const EdgeInsets.all(16.0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ),
                    ),
                ],
              )
            ),
            // Change password
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(slidingFromLeft(const ChangePassword()));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  padding: const EdgeInsets.all(16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    side: const BorderSide(
                      width: 2.0,
                      color: ColorsReference.borderColorGray,
                    ),
                  ),
                  elevation: 0, // Set elevation to 0 to remove the shadow
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.lock_outline_rounded,
                          color: ColorsReference.textColorBlack,
                          size: 24,
                        ),
                        SizedBox(width: 10),
                        Text(
                          'Change Password',
                          style: TextStyle(
                            color: ColorsReference.textColorBlack,
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ],
                    ),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: ColorsReference.textColorBlack,
                      size: 20,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
