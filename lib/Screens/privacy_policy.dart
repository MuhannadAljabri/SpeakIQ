import 'package:flutter/material.dart';
import '../Style/colors.dart';

class PrivacyPolicy extends StatefulWidget {
  const PrivacyPolicy({Key? key}) : super(key: key);

  @override
  State<PrivacyPolicy> createState() => PrivacyPolicyState();
}

class PrivacyPolicyState extends State<PrivacyPolicy> {
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
            'Privacy Policy',
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
                    'Privacy Policy',
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
                            'Speaksy Privacy Policy Info: \n'+
'Be Transparent about how data will be used\n' +

'(i) Privacy Policies:\n' +
'Identify what data, if any, the app/service collects, how it collects that data, and all uses of that data:\n'

"We collect the email address and Name that is entered by the user when they register an account or log in to the app. If they choose to register to the app using Facebook login method, the email and name will be stored on our database hosted on Firebase. No other user data is stored regarding user's account . This email address will be used to optionally send a copy of the user's worksheet answers. It will also be sent to the admin user if the user chooses to schedule a consultation. These emails will include the name that is stored.\n" +

"We collect answers to all questions that the user answers in each worksheet. These answers are included in an email to the users own email address which can be sent to them optionally. The answers will also be used if the user decides to come back later to view or modify their answers. If the user decides to schedule a consultation, these answers will be sent in an email to the admin user so that they can get an understanding about the user.\n" +

"If a user decides to schedule a consultation, we will collect data on which day they pick to schedule a consultation for and also that they have scheduled consultation.\n" +

"All of the collected data is shared with the user, through worksheet answers, emails, and consultations. If the user chooses to schedule a consultation, additional collected data will be shared with the admin user. A user's data will never be shared with another regular user of the app.\n" +

"If a user chooses to send an email to themself containing a copy of the answers to their worksheet questions, or if the user schedules a consultation an email containing these answers will be sent in an email to the admin user, these are sent as an unencrypted email over the public internet.\n\n" +



"Confirm that any third party with whom an app shares user data (in compliance with these Guidelines) — such as analytics tools, advertising networks and third party SDKs, as well as any parent, subsidiary or other related entities that will have access to user data — will provide the same or equal protection of user data as stated in the app’s privacy policy and required by these Guidelines.\n" +

"Data collected by our app is stored on Firebase, whose privacy policy can be found here: https://firebase.google.com/support/privacy/\n" + 

"Emails that include user data are sent using mailgun, whose privacy policy can be found here: https://www.mailgun.com/privacy-policy" +
"Any user data sent through email is sent using unencrypted email in plain text over the public internet. This means email sent using the service “may be intercepted by other users of the public internet, and may be stored and disclosed by third parties (such as the recipients email service provider).” This is taken from https://www.mailgun.com/terms section 4.2 Content Privacy.\n" +

"A user may login to the app using either their email or Facebook account. If they choose to login with a Facebook account, the app will access the email associated with their Facebook account. The app will not access any other data from the user's Facebook account. Facebook's Data Policy can be found here: https://www.facebook.com/policy.php \n" +

"Explain its data retention/deletion policies and describe how a user can revoke consent and/or request deletion of the user’s data.\n" +

"Upon launching the app, the user is provided with a summary of how data is collected for the app, and are required to opt-in to this data collection before accessing the app.\n" +
"A users data will not expire after any amount of time. However, a user can manually choose to opt out of consent and their user data will be deleted. Within the app, there is an option to delete your user data. This option can be found from the home screen in the Settings.\n" +

"In order to use the app, a user must sign in through email. The app cannot be used anonymously.\n" +

"We do not store credentials or tokens to social networks off of the device. We only use such credentials or tokens to directly connect to the social network from the app itself while the app is in use.\n" ,
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