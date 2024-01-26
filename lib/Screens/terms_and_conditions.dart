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
                            'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed euismod, diam sit amet aliquet ultricies, nisl nunc aliquam nunc, vitae aliquam nunc nisl vitae nisl. Sed euismod, diam sit amet aliquet ultricies, nisl nunc aliquam nunc, vitae aliquam nunc nisl vitae nisl.',
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