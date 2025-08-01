// lib/shared/widgets/bottom_navigation.dart
import 'package:flutter/material.dart';
import '../../core/theme/colors.dart';

class CustomBottomNavigation extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavigation({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: UNColors.unWhite,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: onTap,
        type: BottomNavigationBarType.fixed,
        backgroundColor: UNColors.unWhite,
        selectedItemColor: UNColors.unBlue,
        unselectedItemColor: UNColors.unGray,
        selectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
        unselectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 12,
        ),
        elevation: 0,
        items: const [
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.home_outlined),
          //   activeIcon: Icon(Icons.home),
          //   label: 'Home',
          // ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline),
            activeIcon: Icon(Icons.chat_bubble),
            label: 'Chat',
          ),
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.analytics_outlined),
          //   activeIcon: Icon(Icons.analytics),
          //   label: 'Data',
          // ),
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.report_outlined),
          //   activeIcon: Icon(Icons.report),
          //   label: 'Report',
          // ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
