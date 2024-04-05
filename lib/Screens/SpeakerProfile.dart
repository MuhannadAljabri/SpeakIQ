import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import '../backend/firebase.dart';
import 'package:flutter/material.dart';
import 'package:open_file_plus/open_file_plus.dart';
import 'package:speak_iq/style/colors.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:flutter_downloader/flutter_downloader.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

class SpeakerProfile extends StatefulWidget {
  const SpeakerProfile({super.key});

  @override
  State<SpeakerProfile> createState() => SpeakerProfileState();
}

class SpeakerProfileState extends State<SpeakerProfile> {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();

  TextEditingController userfirstNameController = TextEditingController();
  TextEditingController userlastNameController = TextEditingController();
  TextEditingController useremailController = TextEditingController();
  TextEditingController userphoneNumberController = TextEditingController();

  String speakerId = "";
  String firstName = "";
  String lastName = "";
  String link = "";
  String pdfUrl = "";
  String pictureUrl = "";
  String bio = "";
  late List<String> topics;
  late List<String> languages;

  Future<Map<dynamic, dynamic>?> getSpeaker() async {
    try {
      print(speakerId);
      final speakerSnapshot = await FirebaseDatabase.instance
          .ref('speaker_requests')
          .child(speakerId)
          .once();
      final userSnapshot =
          await FirebaseDatabase.instance.ref('users').child(speakerId).once();
      Map<dynamic, dynamic> combinedSnapshot = {
        'speaker': speakerSnapshot.snapshot.value,
        'user': userSnapshot.snapshot.value
      };
      return combinedSnapshot;
    } catch (error) {
      print('Error fetching user data: $error');
      return null;
    }
  }

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

//NEW
  Future<void> getUser() async {
    GetUserInfo userInfoGetter = GetUserInfo();
    UserData user = await userInfoGetter.loadUser();
    setState(() {
      userfirstNameController.text = user.firstName;
      userlastNameController.text = user.lastName;
      useremailController.text = user.email;
      userphoneNumberController.text = user.phoneNumber;

      // if (user.role.startsWith('Other: ')){

      // }
    });
  }

  @override
  Widget build(BuildContext context) {
    final data = ModalRoute.of(context)?.settings.arguments;
    speakerId = data.toString();
    getSpeaker();
    return SafeArea(
        child: Scaffold(
      body: SingleChildScrollView(
        child: FutureBuilder<Map<dynamic, dynamic>?>(
          future: getSpeaker(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (!snapshot.hasData || snapshot.data == null) {
              return const Text('Data not available');
            } else {
              Map<dynamic, dynamic> speakerInfo = snapshot.data?['speaker'];
              Map<dynamic, dynamic> userInfo = snapshot.data?['user'];
              pictureUrl = speakerInfo['pictureUrl'];
              firstName = userInfo['firstName'];
              lastName = userInfo['lastName'];
              link = speakerInfo['link'];
              pdfUrl = speakerInfo['pdfUrl'];
              bio = speakerInfo['bio'];
              topics = List.from(speakerInfo['topics']);
              languages = List.from(speakerInfo['languages']);
              return content();
            }
          },
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
        child: Container(
          height: 50,
          width: 500,
          decoration: BoxDecoration(
            color: ColorsReference.darkBlue,
            borderRadius: BorderRadius.circular(50.0),
          ),
          child: TextButton(
              onPressed: () {
                showAlertDialog(context);
                sendEmail();
                null;
              },
              child: const Text("Book Now",
                  style: TextStyle(
                    color: Colors.white,
                  ))),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    ));
  }

  Widget content() {
    return Column(children: [
      Stack(clipBehavior: Clip.none, children: [
        pictureUrl != 'Not provided'?
        Image.network(pictureUrl,
            height: (298 / 812) *
                (MediaQuery.of(context).size.height -
                    MediaQuery.of(context).padding.top),
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.cover) 
            : Image.asset('assets/42.png',
            height: (298 / 812) *
                (MediaQuery.of(context).size.height -
                    MediaQuery.of(context).padding.top),
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.cover), 

        Container(
          
          decoration: const BoxDecoration(
            color: Color.fromRGBO(0, 0, 0, 0),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(100),
              bottomRight: Radius.circular(100),
            ),
          ),
          child: IconButton(
            alignment: Alignment.topLeft,
            padding: const EdgeInsets.only(left: 30, top: 50),
            iconSize: 28,
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Color.fromRGBO(255, 255, 255, 1),
            ),
            onPressed: () {
              // Navigate back to the previous screen
              Navigator.pop(context);
            },
          ),
        ),
        // Positioned(
        //   left: 16.0,
        //   bottom: -60.0,
        //   child: ClipRRect(
        //     borderRadius: new BorderRadius.circular(50.0),
        //     child: Image.network(pictureUrl,
        //         height: 96, width: 96, fit: BoxFit.cover),
        //   ),
        // ),
        Positioned(
            bottom: -30,
            child: Container(
                width: MediaQuery.of(context).size.width,
                child: Text(
                  '$firstName $lastName',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                )))
      ]),
      const SizedBox(height: 50),
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: (Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              bio,
              style: const TextStyle(
                color: Color.fromRGBO(136, 136, 136, 1),
                fontSize: 14,
              ),
            ),
            SizedBox(height: 16.0), // Adjust the space between text and rows
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(40.0),
                  child: SvgPicture.asset(
                    'assets/role_icon.svg',
                  ),
                ),
                const SizedBox(width: 16.0),
                // Adjust the space between image and text
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Role',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(height: 10.0),
                    Text(
                      'General Manager',
                      style: TextStyle(
                        color: Color.fromRGBO(136, 136, 136, 1),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 16.0), // Adjust the space between rows
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(40.0),
                  child: SvgPicture.asset(
                    'assets/topic_icon.svg',
                  ),
                ),
                const SizedBox(width: 16.0),
                Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Text(
                    'Topics',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Wrap(
                    runSpacing: 8.0,
                    children: buildItemWidgets(topics),
                  )
                ])
                )
              ],
            ),
            SizedBox(height: 16.0), // Adjust the space between rows
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(40.0),
                  child: SvgPicture.asset(
                    'assets/language_icon.svg',
                  ),
                ),
                const SizedBox(width: 16.0),
                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Text(
                    'Languages',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Wrap(
                    runSpacing: 8.0,
                    children: buildItemWidgets(languages),
                  )
                ])
                )
              ],
            ),
            SizedBox(height: 16.0), // Adjust the space between rows
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(40.0),
                  child: SvgPicture.asset(
                    'assets/sheet_icon.svg',
                  ),
                ),
                const SizedBox(width: 10.0),
                // Adjust the space between image and text
                TextButton(
                  onPressed: () {
                    downloadFile();
                  },
                  child: const Text(
                    'Download a Speaker Sheet',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.0), // Adjust the space between rows
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(40.0),
                  child: SvgPicture.asset(
                    'assets/link_icon.svg',
                  ),
                ),
                const SizedBox(width: 10.0),
                // Adjust the space between image and text
                TextButton(
                  onPressed: () {
                    _launchYouTube();
                  },
                  child: const Text(
                    'Link to a Video',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      color: Colors.black,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 100, // or whatever height works for your design
            ),
          ],
        )),
      ),
    ]);
  }

  _launchYouTube() async {
    String url = link;
    try {
        if (!url.startsWith("http://") && !url.startsWith("https://")) {
      url = "https://" + url;
    }
      if (await launchUrl(Uri.parse(url),
          mode: LaunchMode.externalApplication)) {
      } else {
        throw '#1: Could not launch $url';
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text('Unable to open the video. The link is invalid'),
          action: SnackBarAction(
            label: 'Close',
            onPressed: () {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
            },
          ),
        ),
      );
      throw '#2: Could not launch $url';
    }
  }

  Future<String> downloadFile() async {
    String myUrl = pdfUrl;
    String filePath = '';
    String fileName = 'speaker_sheet_${firstName}_$lastName.pdf';

    if (Platform.isIOS) {
      Directory appDocDir = await getApplicationDocumentsDirectory();
      String appDocPath = appDocDir.path;
      filePath = '$appDocPath/';
    } else {
      filePath = '/storage/emulated/0/Download/';
    }

    try {
      final taskId = await FlutterDownloader.enqueue(
        url: pdfUrl,
        savedDir: filePath,
        fileName: fileName,
        showNotification: true, // Set to true to show a download notification
        openFileFromNotification: true,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          content: const Text('Download completed'),
          action: SnackBarAction(
            label: 'Open',
            onPressed: () async {
              // Open the downloaded file in the Files app
              await OpenFile.open("${filePath}${fileName}");
            },
          ),
        ),
      );
    } catch (ex) {
      filePath = 'Can not fetch url';
    }

    return filePath;
  }

  List<Widget> buildItemWidgets(List<String> items) {
    List<Widget> textWidgets = [];

    for (var item in items) {
      textWidgets.add(
        Container(
          margin: const EdgeInsets.symmetric(
              horizontal: 4), // Adjust margin as needed
          decoration: BoxDecoration(
            color: ColorsReference.lightBlue, // Adjust color as needed
            borderRadius:
                BorderRadius.circular(36), // Adjust border radius as needed
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
                12, 4, 12, 4), // Adjust padding as needed
            child: Text(
              item,
              style: TextStyle(
                  fontSize: 10,
                  color: Colors.white,
                  fontWeight: FontWeight.w600), // Adjust text style as needed
            ),
          ),
        ),
      );
    }

    return textWidgets;
  }

//call emailjs API to send email
  Future sendEmail() async {
    const serviceId = 'service_z3a99hz';
    const templateId = 'template_jy4hno1';
    const userId = 'KBalXQHMW6Y-vzaQk';

    final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');
    final response = await http.post(url,
        headers: {
          'origin': 'http:localhost',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          "service_id": serviceId,
          "template_id": templateId,
          "user_id": userId,
          "template_params": {
            "first_name": userfirstNameController.text,
            "last_name": userlastNameController.text,
            "speaker_name": firstName,
            "email_name": useremailController.text,
            "phone_num": userphoneNumberController.text
          }
        }));
    print(response.body);
  }

  //Alert popup for booking

  showAlertDialog(BuildContext context) {
    Widget okButton = TextButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context).pop(); // Close the dialog
        Navigator.of(context).pop(); 


      },
    );

    AlertDialog alert = AlertDialog(
      title: Text("Congratulations!", style: TextStyle(fontFamily: 'Poppins', color: Colors.white)),
      backgroundColor: ColorsReference.darkBlue,
      content: Text("Your booking request has been sent. Please allow the request to be processed and reviewed. One of our team members will contact you through your email or phone number (If applicable). Thank you for your business!", style: TextStyle(color: Colors.white),),
      actions: [okButton],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
