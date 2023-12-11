import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_svg/svg.dart';
import '../backend/firebase.dart';
import 'package:firebase_database/firebase_database.dart';
import '../style/colors.dart';
import 'package:cached_network_image/cached_network_image.dart';

class Speaker {
  final String userID;
  final String firstName;
  final String pictureUrl;

  Speaker(this.userID, this.firstName, this.pictureUrl);
}

class HomePage extends StatelessWidget {
  HomePage({super.key});

  Widget build(BuildContext context) {
    return MyHomePage();
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<String> names = ['John', 'Jane', 'Bob', 'Alice'];

  final DatabaseReference _speakersRef =
      FirebaseDatabase.instance.ref().child('speaker_requests');

  List<Speaker> _speakers = [];

  @override
  void initState() {
    super.initState();
    _loadSpeakers();
  }

  Future<void> _loadSpeakers() async {
    final snapshot = await _speakersRef.once();
    List<Speaker> speakers = [];

    Map<dynamic, dynamic> data =
        snapshot.snapshot.value as Map<dynamic, dynamic>;
    if (data != null) {
      data.forEach((key, value) {
        speakers.add(Speaker(
          key, // userID
          value['firstName'] ?? '',
          value['pictureUrl'] ?? '',
        ));
      });
    }

    setState(() {
      _speakers = speakers;
    });
  }

  bool isFilterVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: 'Good day,\n ',
                style: TextStyle(
                  color: Colors.black.withOpacity(0.5),
                  fontSize: 15,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w400,
                  height: 0,
                ),
              ),
              TextSpan(
                text: 'John',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 23,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w300,
                  height: 0,
                ),
              ),
            ],
          ),
        ),
        toolbarHeight: 100,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        actions: [
          // Filter button
          IconButton(
            iconSize: 30,
            padding: EdgeInsets.only(right: 16),
            icon: Icon(Icons.filter_list),
            onPressed: () {
              setState(() {
                isFilterVisible = !isFilterVisible;
              });
            },
            color: Colors.black,
          ),
        ],
      ),
      body: Column(children: [
        SizedBox(
          height: 15,
        ),
        Expanded(
            child: ListView.builder(
                itemCount: _speakers.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
                    child: GestureDetector(
                      onTap: () {
                         final speakerId = _speakers[index].userID;
                        Navigator.pushNamed(
                          context,
                          '/speaker_profile',
                          arguments: speakerId,
                        );
                        // Handle box click, you can navigate to another screen or perform an action
                        print('Name clicked: ${_speakers[index].firstName}');
                      },
                      child: Container(
                        height: 144,
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: ColorsReference.borderColorGray),
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Row(
                          children: [
                            // Circle at the far left
                            Container(
                              width: 70,
                              height: 70,
                              margin: EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: ColorsReference.borderColorGray),
                                color: Color.fromARGB(255, 255, 255, 255),
                                shape: BoxShape.circle,
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(30.0),
                                child: Container(
                                    height: 70,
                                    width: 70,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                    color: ColorsReference.borderColorGray),
                                color: Color.fromARGB(255, 255, 255, 255),
                                shape: BoxShape.circle,
                                    ),
                                    child: CachedNetworkImage(
                                imageUrl: _speakers[index].pictureUrl,
                                placeholder: (context, url) =>
                                    CircularProgressIndicator(),
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error),
                                fit: BoxFit.cover,
                              ),),
                              )
                            ),
                            // Name in the center
                            Expanded(
                              child: Center(
                                child: Text(
                                  _speakers[index].firstName,
                                  style: TextStyle(
                                    color: const Color.fromARGB(255, 0, 0, 0),
                                    fontSize: 18,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                })),
      ]),
      bottomNavigationBar: Container(
          height: 85,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12.0),
              topRight: Radius.circular(12.0),
            ),
            boxShadow: [
              BoxShadow(
                color: Color.fromARGB(255, 223, 223, 223),
                blurRadius: 5.0,
                spreadRadius: 0.5,
                offset: Offset(0, -4.0),
              ),
            ],
          ),
          child: BottomNavigationBar(
            backgroundColor: Colors.transparent,
            selectedItemColor: ColorsReference.darkBlue,
            elevation:
                0.0, // Set to 0.0 to remove the default BottomNavigationBar shadow

            items: [
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  'assets/home_icon.svg',
                  width: 24,
                  height: 24,
                ),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  'assets/profile_icon.svg',
                  width: 24,
                  height: 24,
                ),
                label: 'Profile',
              ),
            ],
            onTap: (index) {
              // Handle bottom navigation item clicks
              if (index == 0) {
                print('Home Screen');
              } else {
                print('Profile Picture');
              }
            },
          )),
    );
  }
}
