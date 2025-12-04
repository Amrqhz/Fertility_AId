// Updated main.dart with custom bottom navigation bar:

import 'package:flutter/material.dart';
import 'package:fertility_aid/screens/home_screen.dart';
import 'package:fertility_aid/screens/log_data_screen.dart';
import 'package:fertility_aid/screens/calender_screen.dart';
import 'package:fertility_aid/screens/education_screen.dart';
import 'package:fertility_aid/screens/history_screen.dart';
import 'package:fertility_aid/screens/info_screen.dart'; // Your UserInfoDisplayPage
import 'package:fertility_aid/screens/splash_screen2.dart';
import 'package:fertility_aid/models/info.dart'; // Your UserInfoModel and Service
import 'package:fertility_aid/theme/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Fertility_AId',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: const AppInitializer(), // Changed to handle first-time setup
      routes: {
        '/home': (context) => const MainScreen(),
        '/log-data': (context) => const LogDataScreen(),
        '/calendar': (context) => const CalendarScreen(),
        '/history': (context) => const HistoryScreen(),
        '/education': (context) => const EducationScreen(),
        '/splash': (context) => const SplashScreen2(),
        '/info': (context) => const UserInfoDisplayPage(),
        '/setup': (context) => const UserInfoDashboard(isFirstTime: true),
      },
    );
  }
}

// New widget to handle app initialization and first-time setup
class AppInitializer extends StatefulWidget {
  const AppInitializer({Key? key}) : super(key: key);

  @override
  State<AppInitializer> createState() => _AppInitializerState();
}

class _AppInitializerState extends State<AppInitializer> {
  @override
  void initState() {
    super.initState();
    _checkFirstTime();
  }

  Future<void> _checkFirstTime() async {
    // Add a small delay to show splash screen
    await Future.delayed(const Duration(seconds: 2));
    
    final isFirstTime = await UserInfoService.isFirstTime();
    
    if (mounted) {
      if (isFirstTime) {
        // First time user - go to setup
        Navigator.pushReplacementNamed(context, '/setup');
      } else {
        // Existing user - go to main screen
        Navigator.pushReplacementNamed(context, '/home');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return const SplashScreen2(); // Show splash while checking
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 2; // Start with Home (index 1) as active
  
  // Updated to only 3 screens matching the custom navigation
  static const List<Widget> _screens = <Widget>[
    UserInfoDisplayPage(), // Profile - index 0
    CalendarScreen(),
    HomeScreen(),          // Home - index 1
    EducationScreen(),     // Learning - index 2
    HistoryScreen(),

  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // Helper method for custom navigation items
  Widget _buildNavItem(String label, IconData icon, int index, bool isSelected) {
    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected 
            ? Colors.white.withOpacity(0.8) 
            : Colors.transparent,
          borderRadius: BorderRadius.circular(50),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.black87 : Colors.black54,
              size: 18,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.black87 : Colors.black54,
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/log-data');
        },
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: const Icon(Icons.add),
        tooltip: 'Log Today\'s Data',
      ),
      // Custom Bottom Navigation Bar
      bottomNavigationBar: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(0xFFE8C4D6), // Pink color matching your image
          borderRadius: BorderRadius.circular(30),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: Container(
            height: 60,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildNavItem(
                  'Info',
                  Icons.person,
                  0,
                  _selectedIndex == 0,
                ),
                _buildNavItem(
                  'Calendar',
                  Icons.calendar_today,
                  1,
                  _selectedIndex == 1,
                ),
                _buildNavItem(
                  'Home',
                  Icons.home,
                  2,
                  _selectedIndex == 2,
                ),
                _buildNavItem(
                  'Learn',
                  Icons.book,
                  3,
                  _selectedIndex == 3,
                ),
                _buildNavItem(
                  'History',
                  Icons.history,
                  4,
                  _selectedIndex == 4,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}