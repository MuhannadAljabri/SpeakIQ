import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_svg/svg.dart';
import '../backend/firebase.dart';
import 'package:firebase_database/firebase_database.dart';
import '../style/colors.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<String> names = ['John', 'Jane', 'Bob', 'Alice'];

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
      body: Column(children: [SizedBox(height: 15,),Expanded(child: ListView.builder(
          itemCount: names.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: GestureDetector(
                onTap: () {
                  // Handle box click, you can navigate to another screen or perform an action
                  print('Name clicked: ${names[index]}');
                },
                child: Container(
                  height: 144,
                  decoration: BoxDecoration(
                    border:Border.all(color: ColorsReference.borderColorGray),
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
                              border: Border.all(color: ColorsReference.borderColorGray) ,
                              color: Color.fromARGB(255, 255, 255, 255),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                'Picture',
                                style: TextStyle(
                                  color: Color.fromARGB(255, 0, 0, 0),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                          // Name in the center
                          Expanded(
                            child: Center(
                              child: Text(
                                names[index],
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
            ),);
          })),]),
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
