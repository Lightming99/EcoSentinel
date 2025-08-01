// // lib/main_navigation.dart
// import 'package:flutter/material.dart';
// import 'package:EcoSentinel/features/environmental_data/screens/data_dashboard.dart';
// import 'package:EcoSentinel/features/home/report_incident/screens/report_form_screen.dart';
// import 'package:EcoSentinel/features/home/screens/chat_screen.dart';
// import 'package:EcoSentinel/features/profiles/screens/profile_screen.dart';
// import 'shared/widgets/bottom_navigation.dart';
// import 'features/home/screens/home_screen.dart';

// class MainNavigationScreen extends StatefulWidget {
//   const MainNavigationScreen({super.key});

//   @override
//   State<MainNavigationScreen> createState() => _MainNavigationScreenState();
// }

// class _MainNavigationScreenState extends State<MainNavigationScreen> {
//   int _currentIndex = 0;

//   final List<Widget> _screens = [
//     // const HomeScreen(),
//     const ChatScreen(),
//     // const DataDashboard(),
//     // const ReportFormScreen(),
//     // const ProfileScreen(),
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: IndexedStack(
//         index: _currentIndex,
//         children: _screens,
//       ),
//       bottomNavigationBar: CustomBottomNavigation(
//         currentIndex: _currentIndex,
//         onTap: (index) {
//           setState(() {
//             _currentIndex = index;
//           });
//         },
//       ),
//     );
//   }
// }
