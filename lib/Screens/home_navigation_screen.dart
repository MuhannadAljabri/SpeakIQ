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
    return Scaffold(
      body: _pages[_currentIndex],
      
      bottomNavigationBar: Container(
          height: 85,
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
            selectedIconTheme: const IconThemeData(color: ColorsReference.darkBlue),
            elevation:0.0, 
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
              setState(() {
                _currentIndex = index;
              });
            },
          )),
    
    );
  }
}
