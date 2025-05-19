import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:measureapp/screens/home_screen.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final bool isChildModeEnabled;

  const BottomNavBar({
    this.currentIndex = 1,
    this.isChildModeEnabled = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 0,
            blurRadius: 8,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        backgroundColor: Colors.transparent,
        elevation: 0,
        selectedLabelStyle: TextStyle(fontSize: 12, color: Colors.black),
        unselectedLabelStyle: TextStyle(fontSize: 12, color: Colors.black),
        onTap: (index) {
          if (index == 1) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()),
            );
          }
        },
        items: [
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/icons/loop.svg',
              width: 32,
              height: 32,
            ),
            label: 'Jouw groei',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/images/home.png',
              width: 32,
              height: 32,
            ),
            label: 'Home',
          ),
          if (isChildModeEnabled)
            BottomNavigationBarItem(
              icon: Image.asset(
                'assets/images/yoga.png',
                width: 32,
                height: 32,
              ),
              label: 'Oefeningen',
            ),
        ],
      ),
    );
  }
}