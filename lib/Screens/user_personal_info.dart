import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:speak_iq/Screens/change_password.dart';
import '../backend/firebase.dart';
import '../Style/route_animation.dart';
import '../Style/colors.dart';

class UserPersonalInfo extends StatefulWidget {
  const UserPersonalInfo({Key? key}) : super(key: key);

  @override
  State<UserPersonalInfo> createState() => UserPersonalInfoState();
}

class UserPersonalInfoState extends State<UserPersonalInfo> {

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  
  List<String> roles = [
      'Event Planner',
      'Speaker',
      'Other'
    ];
  String selectedRole = 'None'; // Original role
  String otherRoleText = ''; // Text entered for "Other" role
  bool hasChanges = false;

  // Validation status for each text field
  bool isFirstNameValid = true;
  bool isLastNameValid = true;
  bool isPhoneNumberValid = true;
  bool isOtherRoleValid = true;

  bool formSubmitted = false;

  FocusNode firstNameFocus = FocusNode();
  FocusNode lastNameFocus = FocusNode();
  FocusNode phoneNumberFocus = FocusNode();
  FocusNode otherRoleFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    loadData(); // Load data when the widget is initialized
  }

  Future<void> loadData() async {
    await getUser(); // Load user info
    setState(() {
      // Set the state to update the UI
    });
  }

  Future<void> getUser() async {
    GetUserInfo userInfoGetter = GetUserInfo();
    UserData user = await userInfoGetter.loadUser();
    setState(() {
      firstNameController.text = user.firstName;
      lastNameController.text = user.lastName;
      emailController.text = user.email;
      phoneNumberController.text = user.phoneNumber;
      // if (user.role.startsWith('Other: ')){

      // }
      selectedRole = user.role;
    });
  }

  Future<void> updateUser() async {

    setState(() {
      formSubmitted = true;
      isFirstNameValid = firstNameController.text.isNotEmpty;
      isLastNameValid = lastNameController.text.isNotEmpty;
      isPhoneNumberValid = phoneNumberController.text.isEmpty ||
        _isValidPhoneNumber(phoneNumberController.text);
      isOtherRoleValid = otherRoleText.isNotEmpty && otherRoleText != 'Other';
      
      // Maintain focus on the field with an empty value
      if (!isFirstNameValid) {
        FocusScope.of(context).requestFocus(firstNameFocus);
      } else if (!isLastNameValid) {
        FocusScope.of(context).requestFocus(lastNameFocus);
      } else if (!isPhoneNumberValid) {
        FocusScope.of(context).requestFocus(phoneNumberFocus);
      } else if (selectedRole == 'Other' && !isOtherRoleValid) {
        FocusScope.of(context).requestFocus(otherRoleFocus);
      }
      // Call a method to update user information in Firebase
      else {
        String adjustedRole = selectedRole == 'Other' ? '$selectedRole: $otherRoleText' : selectedRole;
        FirebaseDatabase.instance
          .ref()
          .child("users")
          .child(FirebaseAuth.instance.currentUser!.uid)
          .update({
            'firstName': firstNameController.text,
            'lastName': lastNameController.text,
            //'email': emailController.text,
            'phoneNumber': phoneNumberController.text,
            'role': adjustedRole
          });
        // Show a dialog if update is successful
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Update Successful'),
            content: const Text('Your information has been updated.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    });
  }

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
              onPressed: hasChanges ? updateUser : null,
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
                controller: firstNameController,
                focusNode: firstNameFocus,
                onChanged: (value) {
                  setState(() {
                    hasChanges = true;
                    isFirstNameValid = value.isNotEmpty;
                  });
                },
                //readOnly: true,
                decoration: InputDecoration(
                  labelText: 'First Name',
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  hintText: 'Enter your first name',
                  contentPadding: const EdgeInsets.all(16.0),
                  labelStyle: const TextStyle(
                    color: ColorsReference.textColorBlack, 
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        width: 2.0,
                        color: isFirstNameValid ? ColorsReference.borderColorGray : ColorsReference.errorColorRed),
                    borderRadius: BorderRadius.circular(50.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      width: 2.0,
                      color: isFirstNameValid
                          ? ColorsReference.borderColorGray
                          : ColorsReference.errorColorRed,
                    ),
                    borderRadius: BorderRadius.circular(50.0),
                  ),
                  errorText:
                    isFirstNameValid ? null : 'Please enter your first name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            ),
            // Last Name
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: TextField(
                controller: lastNameController,
                focusNode: lastNameFocus,
                onChanged: (value) {
                  setState(() {
                    hasChanges = true;
                    isLastNameValid = value.isNotEmpty; 
                  });
                },
                // readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Last Name',
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  hintText: 'Enter your last name',
                  contentPadding: const EdgeInsets.all(16.0),
                  labelStyle: const TextStyle(
                    color: ColorsReference.textColorBlack, 
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        width: 2.0,
                        color: isLastNameValid ? ColorsReference.borderColorGray : ColorsReference.errorColorRed),
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
                  errorText:
                    isLastNameValid ? null : 'Please enter your last name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            ),
            // Email address
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: TextField(
                style: const TextStyle(color: ColorsReference.textColorBlack),
                controller: emailController,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Email',
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  hintText: 'You are not alllowed to change your email address',
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
                controller: phoneNumberController,
                focusNode: phoneNumberFocus,
                onChanged: (value) {
                  setState(() {
                    hasChanges = true;
                    isPhoneNumberValid = value.isEmpty || _isValidPhoneNumber(value);
                  });
                },
                //readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Phone number',
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  hintText: 'Enter your phone number',
                  contentPadding: const EdgeInsets.all(16.0),
                  labelStyle: const TextStyle(
                    color: ColorsReference.textColorBlack,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        width: 2.0,
                        color: isPhoneNumberValid ? ColorsReference.borderColorGray : ColorsReference.errorColorRed),
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
                  errorText:
                    isPhoneNumberValid ? null : 'Please a valid phone number',
                  border: OutlineInputBorder(
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
                    iconEnabledColor: Colors.black,
                    items: roles.map((role) {
                      return DropdownMenuItem(
                        value: role,
                        child: Text(role),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedRole = value.toString();
                        hasChanges = true;
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
                            isOtherRoleValid = value.isNotEmpty;
                          });
                        },
                        focusNode: otherRoleFocus,
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
                                  ? Colors.grey
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

}
