import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:measureapp/screens/home_screen.dart'; // Import HomeScreen

class BottomNavBar extends StatelessWidget {
  final int currentIndex;

  const BottomNavBar({this.currentIndex = 1, super.key});

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
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        backgroundColor: Colors.transparent,
        elevation: 0,
        selectedLabelStyle: const TextStyle(fontSize: 12, color: Colors.black),
        unselectedLabelStyle: const TextStyle(fontSize: 12, color: Colors.black),
        onTap: (index) {
          // Handle tap on navigation items
          if (index == 1) {
            // "Home" item tapped
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()),
            );
          }
          // Add navigation for other items if needed
          // Example:
          // if (index == 0) { /* Navigate to Growth Screen */ }
          // if (index == 2) { /* Navigate to Exercises Screen */ }
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