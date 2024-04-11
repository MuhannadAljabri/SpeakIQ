import 'package:flutter/material.dart';
import '../Style/colors.dart';

class TermsAndConditions extends StatefulWidget {
  const TermsAndConditions({Key? key}) : super(key: key);

  @override
  State<TermsAndConditions> createState() => TermsAndConditionsState();
}

class TermsAndConditionsState extends State<TermsAndConditions> {
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
            'Terms & Conditions',
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
            ),
          ),
          centerTitle: true,
        ),
        body: 
          Padding(
            padding: const EdgeInsets.all(20),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(
                  color: ColorsReference.borderColorGray, // Set your desired border color here
                  width: 2.0, // Set your desired border width here
                ),
                borderRadius: BorderRadius.circular(30.0), // Set your desired border radius here
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Terms & Conditions',
                    style: TextStyle(
                      color: ColorsReference.lightBlue,
                      fontSize: 16,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                      height: 0,
                    ),
                  ),
                  SizedBox(height: 10),
                  Expanded(
                    child: 
                      SingleChildScrollView(
                        child:
                          Text(
                            '1. Introduction: Welcome to Speaksy! These Terms of Service govern your use of our mobile application and any related services provided by us. 2. Acceptance of Terms: By accessing or using our app, you agree to be bound by these Terms of Service. If you do not agree to these terms, please do not use our app. 3. Use of the App:You must be at least 7 years old to use our app. By using the app, you represent and warrant that you are at least 7 years old. 4. User Accounts: To use certain features of the app, you may be required to create a user account. You are responsible for maintaining the confidentiality of your account credentials and for all activities that occur under your account. 5. Privacy Policy: Our Privacy Policy governs the collection, use, and disclosure of your personal information. By using our app, you agree to our Privacy Policy. 6. Intellectual Property: The app and its original content, features, and functionality are owned by Speaksy and are protected by international copyright, trademark, patent, trade secret, and other intellectual property or proprietary rights laws. 7. Disclaimer: Our app is provided "as is," with all faults, and we make no express or implied representations or warranties, of any kind related to our app or the materials contained on our app. Additionally, nothing contained on this app shall be construed as providing consult or advice to you. 8. Limitation of Liability: In no event shall Speaksy, nor any of its officers, directors, and employees, be liable to you for anything arising out of or in any way connected with your use of this app, whether such liability is under contract, tort, or otherwise. 9. Governing Law: These Terms of Service shall be governed by and construed in accordance with the laws of USA, without regard to its conflict of law provisions. 10. Changes to Terms: We reserve the right to modify these Terms of Service at any time. Your continued use of the app after any such changes constitutes your acceptance of the new Terms of Service.11. Contact Us:If you have any questions about these Terms of Service, please contact us at susyfsolis@gmail.com',
                            style: TextStyle(
                              color: ColorsReference.textColorBlack,
                              fontSize: 14,
                            ),
                          )
                      )
                  )
                ],
              ),
            ),
          ),
      )
    );
  }
}