import 'package:EcoSentinel/features/environmental_data/screens/data_dashboard.dart';
import 'package:EcoSentinel/features/home/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:EcoSentinel/features/chat/screens/chat_screen.dart';
import 'package:EcoSentinel/features/home/report_incident/screens/report_form_screen.dart';
import 'package:EcoSentinel/features/home/screens/chat_screen.dart';
import 'package:EcoSentinel/features/home/screens/home_screen.dart';
import 'package:EcoSentinel/features/environmental_data/screens/data_dashboard.dart';
import 'package:EcoSentinel/features/profiles/screens/profile_screen.dart';
import 'core/theme/colors.dart';
import 'shared/widgets/bottom_navigation.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Environmental Assistant',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: MaterialColor(
          UNColors.unBlue.value,
          <int, Color>{
            50: UNColors.unBlue.withOpacity(0.1),
            100: UNColors.unBlue.withOpacity(0.2),
            200: UNColors.unBlue.withOpacity(0.3),
            300: UNColors.unBlue.withOpacity(0.4),
            400: UNColors.unBlue.withOpacity(0.5),
            500: UNColors.unBlue,
            600: UNColors.unBlue.withOpacity(0.7),
            700: UNColors.unBlue.withOpacity(0.8),
            800: UNColors.unBlue.withOpacity(0.9),
            900: UNColors.unBlue,
          },
        ),
        fontFamily: 'Roboto',
        appBarTheme: const AppBarTheme(
          backgroundColor: UNColors.unBlue,
          foregroundColor: UNColors.unWhite,
          elevation: 2,
        ),
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    // const HomeScreen(),
    const ChatScreen(),
    // const DataDashboard(),
    // const ReportFormScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: CustomBottomNavigation(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
