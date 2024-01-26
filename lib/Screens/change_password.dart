import 'package:flutter/material.dart';
import '../Style/colors.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({Key? key}) : super(key: key);

  @override
  State<ChangePassword> createState() => ChangePasswordState();
}
class ChangePasswordState extends State<ChangePassword> {

  TextEditingController currentPasswordController = TextEditingController(text: 'Current Password');
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  bool currentPasswordVisible = true;
  bool newPasswordVisible = true;
  bool confirmPasswordVisible = true;

  bool isCurrentPasswordValid = false;
  bool isNewPasswordValid = true;
  bool isConfirmPasswordValid = true;

  bool formSubmitted = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          leading: TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text(
              'Cancel',
              style: TextStyle(
                color: ColorsReference.textColorBlack,
                fontSize: 14,
              ),
            ),
          ),
          title: const Text(
            'Password',
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
            // Current password
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: Row(
                children: [
                  const SizedBox(height: 20),
                  Expanded(
                    child: TextField(
                      controller: currentPasswordController,
                      //focusNode: currentPasswordFocus,
                      obscureText: currentPasswordVisible,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            width: 2.0,
                            color: ColorsReference.borderColorGray,
                          ),
                          borderRadius: BorderRadius.circular(50.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            width: 2.0,
                            color: ColorsReference.borderColorGray,
                          ),
                          borderRadius: BorderRadius.circular(50.0),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50.0),
                        ),
                        labelText: 'Current Password',
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        hintText: 'Enter your current password',
                        errorText: currentPasswordController.text == 'Current Password'
                            ? null
                            : 'Password is not correct',
                        contentPadding: const EdgeInsets.all(20.0),
                        suffixIcon: IconButton(
                          icon: Icon(currentPasswordVisible
                              ? Icons.visibility_off
                              : Icons.visibility),
                          onPressed: () {
                            setState(
                              () {
                                currentPasswordVisible = !currentPasswordVisible;
                              },
                            );
                          },
                        ),
                      ),
                      onSubmitted: (_) {
                        //_validateAndSubmitForm();
                      },
                    ),
                  ),
                ],
              ),
            ),
            // New password text field
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: Row(children: [
                const SizedBox(height: 20),
                Expanded(
                  child: TextField(
                    controller: newPasswordController,
                    //focusNode: passwordFocus,
                    obscureText: newPasswordVisible,
                    onChanged: (value) {
                      setState(() {
                          isNewPasswordValid = formSubmitted
                              ? value.isNotEmpty
                              : true; // Only validate if the form is submitted
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
                        borderSide: BorderSide(
                          width: 2.0,
                          color: isNewPasswordValid
                              ? ColorsReference.borderColorGray
                              : ColorsReference.errorColorRed,
                        ),
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                      labelText: 'New Password',
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      hintText: 'Enter your new password',
                      errorText: isNewPasswordValid
                        ? null
                        : 'Your password should have at least 6 characters',
                      contentPadding: const EdgeInsets.all(20.0),
                      suffixIcon: IconButton(
                        icon: Icon(newPasswordVisible
                            ? Icons.visibility_off
                            : Icons.visibility),
                        onPressed: () {
                          setState(
                            () {
                              newPasswordVisible = !newPasswordVisible;
                            },
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ]),
            ),
            // Confirmation Password text field
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: Row(
                children: [
                  const SizedBox(height: 20),
                  Expanded(
                    child: TextField(
                      controller: confirmPasswordController,
                      //focusNode: confirmPasswordFocus,
                      obscureText: confirmPasswordVisible,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            width: 2.0,
                            color: ColorsReference.borderColorGray,
                          ),
                          borderRadius: BorderRadius.circular(50.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            width: 2.0,
                            color: ColorsReference.borderColorGray,
                          ),
                          borderRadius: BorderRadius.circular(50.0),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50.0),
                        ),
                        labelText: 'Confirm Password',
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        hintText: 'Confirm your new password',
                        errorText: confirmPasswordController.text == newPasswordController.text
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
                                confirmPasswordVisible = !confirmPasswordVisible;
                              },
                            );
                          },
                        ),
                      ),
                      onSubmitted: (_) {
                        //_validateAndSubmitForm();
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
