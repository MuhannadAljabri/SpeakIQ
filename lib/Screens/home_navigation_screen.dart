import 'dart:io';
import 'package:flutter/material.dart';
import './Home.dart';
import './profile_page.dart';

import 'package:flutter_svg/svg.dart';
import '../style/colors.dart';

class HomeNavigationScreen extends StatefulWidget {
  const HomeNavigationScreen({super.key});

  @override
  State<HomeNavigationScreen> createState() => HomeNavigationScreenState();
}

class HomeNavigationScreenState extends State<HomeNavigationScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    HomePage(), 
    const ProfilePage(), 
  ];

  @override
  Widget build(BuildContext context) {
    double screenHeight = Platform.isIOS? 92.0 : 85.0;
    return Scaffold(
      body: _pages[_currentIndex],
      
      bottomNavigationBar: Container(
          height: screenHeight,
          decoration: const BoxDecoration(
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
            unselectedItemColor: Colors.grey,
            currentIndex: _currentIndex,
            elevation:0.0, 
            items: [
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  'assets/home_icon.svg',
                  width: 24,
                  height: 24,
                  color: _currentIndex == 0
                      ? ColorsReference.darkBlue
                      : Colors.grey,
                ),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  'assets/profile_icon.svg',
                  width: 24,
                  height: 24,
                  color: _currentIndex == 1
                      ? ColorsReference.darkBlue
                      : Colors.grey,
                ),
                label: 'Profile',
              ),
            ],
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
          )),
    
    );
  }
}
