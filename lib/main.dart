// 2. Updated main.dart with proper navigation flow:

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
  int _selectedIndex = 0;
  
  static const List<Widget> _screens = <Widget>[
    HomeScreen(),
    CalendarScreen(),
    HistoryScreen(),
    EducationScreen(),
    UserInfoDisplayPage()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
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
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Calendar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'History',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Learn',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "info")
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}