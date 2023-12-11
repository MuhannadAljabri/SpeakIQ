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


class SpeakerProfile extends StatefulWidget {
  const SpeakerProfile({super.key});

  @override
  State<SpeakerProfile> createState() => SpeakerProfileState();
}

class SpeakerProfileState extends State<SpeakerProfile> {
  final String speakerId = "JdWElFv1GQWlNrwxNC8Ba1jUTf33";

  String firstName = "";
  String lastName = "";
  String link = "";
  String pdfUrl = "";
  String pictureUrl = "";

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
            height: (254 / 812) *
                (MediaQuery.of(context).size.height -
                    MediaQuery.of(context).padding.top),
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.cover),
        Container(
          height: 40,
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
              Navigator.of(context).push(slidingFromRight(LoginScreen()));
            },
          ),
        ),
        Positioned(
          left: 16.0,
          bottom: -60.0,
          child: ClipRRect(
            borderRadius: new BorderRadius.circular(40.0),
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
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ))
      ]),
      const SizedBox(height: 80),
      Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Lorem ipsum dolor sit amet consectetur. Id tortor ut phasellus volutpat orci tellus elementum est mollis. Euismod aliquet leo euismod senectus in.',
              style: TextStyle(
                color: Color.fromRGBO(136, 136, 136, 1),
                fontSize: 16,
              ),
            ),
            SizedBox(height: 16.0), // Adjust the space between text and rows
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(40.0),
                  child: const Image(
                    image: AssetImage('assets/role_icon.png'),
                    height: 56,
                    width: 56,
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
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(height: 10.0),
                    Text(
                      'General Manager',
                      style: TextStyle(
                        color: Color.fromRGBO(136, 136, 136, 1),
                        fontSize: 16,
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
                  child: const Image(
                    image: AssetImage('assets/topic_icon.png'),
                    height: 56,
                    width: 56,
                  ),
                ),
                const SizedBox(width: 16.0),
                Column(crossAxisAlignment: CrossAxisAlignment.start,
                    children:[
                    const Text(
                      'Topics',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                      ),
                    ),
                      SizedBox(height: 10.0),
                    Row(
                      children: buildTopicWidgets(),
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
                  child: const Image(
                    image: AssetImage('assets/sheet_icon.png'),
                    height: 56,
                    width: 56,
                  ),
                ),
                const SizedBox(width: 16.0),
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
                      fontSize: 18,
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
                  child: const Image(
                    image: AssetImage('assets/link_icon.png'),
                    height: 56,
                    width: 56,
                  ),
                ),
                const SizedBox(width: 16.0),
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
                      fontSize: 18,
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
    Uri uri = Uri.parse(link);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch speaker video';
    }
  }

  Future<String> downloadFile() async {
    HttpClient httpClient = new HttpClient();
    File file;
    String filePath = '';
    String myUrl = '';

    try {
      myUrl = pdfUrl;
      var request = await httpClient.getUrl(Uri.parse(myUrl));
      var response = await request.close();
      if(response.statusCode == 200) {
        var bytes = await consolidateHttpClientResponseBytes(response);
        filePath = '/storage/emulated/0/Download/speakerSheet.pdf';
        file = File(filePath);
        await file.writeAsBytes(bytes);
      }
      else
        filePath = 'Error code: '+response.statusCode.toString();
    }
    catch(ex){
      filePath = 'Can not fetch url';
    }
    return filePath;
  }

  List<Widget> buildTopicWidgets() {
    int count = 1;
    List<Widget> textWidgets = [];

    for (int i = 0; i < count; i++) {
      textWidgets.add(
        Container(
          margin: EdgeInsets.symmetric(horizontal: 8), // Adjust margin as needed
          decoration: BoxDecoration(
            color: ColorsReference.lightBlue, // Adjust color as needed
            borderRadius: BorderRadius.circular(36), // Adjust border radius as needed
          ),
          child: const Padding(
            padding: EdgeInsets.all(6), // Adjust padding as needed
            child: Text(
              'Entrepreneurship',
              style: TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.w600), // Adjust text style as needed
            ),
          ),
        ),
      );
    }

    return textWidgets;
  }

}
