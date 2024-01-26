import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:speak_iq/Screens/SpeakerSignup.dart';
import 'package:speak_iq/Screens/UserSignup.dart';
import 'package:speak_iq/Screens/forgot_password.dart';
import 'package:speak_iq/Screens/login.dart';
import 'package:speak_iq/style/colors.dart';
import 'package:speak_iq/style/route_animation.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:speak_iq/style/style.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
//import 'package:flutter_local_notifications/flutter_local_notifications.dart';
//import 'package:flutter_downloader/flutter_downloader.dart';



class SpeakerProfile extends StatefulWidget {
  const SpeakerProfile({super.key});

  @override
  State<SpeakerProfile> createState() => SpeakerProfileState();
}

class SpeakerProfileState extends State<SpeakerProfile> {

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
      final snapshot = await FirebaseDatabase.instance
          .ref('speaker_requests')
          .child(speakerId)
          .once();
      return snapshot.snapshot.value as Map<dynamic, dynamic>;
    } catch (error) {
      print('Error fetching user data: $error');
      return null;
    }
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
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (!snapshot.hasData || snapshot.data == null) {
              return Text('Data not available');
            } else {
              Map<dynamic, dynamic> speakerInfo = snapshot.data!;
              pictureUrl = speakerInfo['pictureUrl'];
              firstName = speakerInfo['firstName'];
              lastName = speakerInfo['lastName'];
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
              onPressed: () {},
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
        Image(
            image: AssetImage('assets/background.png'),
            height: (298 / 812) *
                (MediaQuery.of(context).size.height -
                    MediaQuery.of(context).padding.top),
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.cover),
        Container(
          height: 200,
          decoration: const BoxDecoration(
            color: Color.fromRGBO(0,0,0,0),
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
              color: Color.fromRGBO(255,255,255,1),
            ),
            onPressed: () {
              // Navigate back to the previous screen
              Navigator.pop(context);
            },
          ),
        ),
        Positioned(
          left: 16.0,
          bottom: -60.0,
          child: ClipRRect(
            borderRadius: new BorderRadius.circular(50.0),
            child: Image.network(pictureUrl,
                height: 96, width: 96, fit: BoxFit.cover),
          ),
        ),
        Positioned(
            left: 128.0,
            bottom: -30.0,
            child: Text(
              '$firstName $lastName',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ))
      ]),
      const SizedBox(height: 80),
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
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
                    'assets/role_icon.svg',),
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
                    'assets/topic_icon.svg',),
                ),
                const SizedBox(width: 16.0),
                Column(crossAxisAlignment: CrossAxisAlignment.start,
                    children:[
                    const Text(
                      'Topics',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                      ),
                    ),
                      SizedBox(height: 10.0),
                    Row(
                      children: buildItemWidgets(topics),
                    )
                    ]
                )
              ],
            ),
            SizedBox(height: 16.0), // Adjust the space between rows
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(40.0),
                  child: SvgPicture.asset(
                    'assets/topic_icon.svg',),
                ),
                const SizedBox(width: 16.0),
                Column(crossAxisAlignment: CrossAxisAlignment.start,
                    children:[
                      const Text(
                        'Languages',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(height: 10.0),
                      Row(
                        children: buildItemWidgets(languages),
                      )
                    ]
                )
              ],
            ),
            SizedBox(height: 16.0), // Adjust the space between rows
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(40.0),
                  child: SvgPicture.asset(
                    'assets/sheet_icon.svg',),
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
                    'assets/link_icon.svg',),
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
        ),
      ),
    ]);
  }

  _launchYouTube() async {
    String url = link;
    try {
      if (await launchUrl(
          Uri.parse(url), mode: LaunchMode.externalApplication)) {
      } else {
        throw '#1: Could not launch $url';
      }
    } catch (e) {
      throw '#2: Could not launch $url';
    }
  }

  // Future<String> downloadFile() async {
  //   String myUrl = pdfUrl;
  //   String filePath = '';
  //   try {
  //     final taskId = await FlutterDownloader.enqueue(
  //       url: myUrl,
  //       savedDir: '/storage/emulated/0/Download/',
  //       fileName: 'speaker_sheet_${firstName}_$lastName.pdf',
  //       showNotification: true, // Set to true to show a download notification
  //       openFileFromNotification: true,
  //     );
  //     FlutterDownloader.registerCallback((id, status, progress) {
  //       if (status == DownloadTaskStatus.complete) {
  //         // Download completed, show a notification
  //         showDownloadNotification('Download complete');
  //       }
  //     });
  //     filePath = '/storage/emulated/0/Download/speaker_sheet_${firstName}_$lastName.pdf';
  //   } catch (ex) {
  //     filePath = 'Can not fetch url';
  //   }
  //
  //   return filePath;
  // }
  //   flutterLocalNotificationsPlugin.show(0, 'Download Notification', message, NotificationDetails());
  // }

  Future<String> downloadFile() async {
    HttpClient httpClient = HttpClient();
    File file;
    String filePath = '';
    String myUrl = '';

    try {
      myUrl = pdfUrl;
      var request = await httpClient.getUrl(Uri.parse(myUrl));
      var response = await request.close();
      if(response.statusCode == 200) {
        var bytes = await consolidateHttpClientResponseBytes(response);
        filePath = '/storage/emulated/0/Download/speaker_sheet_${firstName}_$lastName.pdf';
        file = File(filePath);
        await file.writeAsBytes(bytes);
      }
      else {
        filePath = 'Error code: '+response.statusCode.toString();
      }
    }
    catch(ex){
      filePath = 'Can not fetch url';
    }
    return filePath;
  }

  List<Widget> buildItemWidgets(List<String>items) {

    List<Widget> textWidgets = [];

    for (var item in items) {
      textWidgets.add(
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 4), // Adjust margin as needed
          decoration: BoxDecoration(
            color: ColorsReference.lightBlue, // Adjust color as needed
            borderRadius: BorderRadius.circular(36), // Adjust border radius as needed
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12,4,12,4), // Adjust padding as needed
            child: Text(
              item,
              style: TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.w600), // Adjust text style as needed
            ),
          ),
        ),
      );
    }

    return textWidgets;
  }

}
