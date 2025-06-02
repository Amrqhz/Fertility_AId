import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../main.dart';


class SplashScreen2 extends StatefulWidget {
  const SplashScreen2({super.key});

  @override
  State<SplashScreen2> createState() => _SplashScreen2State();
}

class _SplashScreen2State extends State<SplashScreen2> {

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  // Navigate to MainScreen after 3 seconds
  void _initializeApp() async {
    // Wait for 3 seconds to show splash screen
    await Future.delayed(const Duration(seconds: 3));
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainScreen()),
    );
    

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // WRAP your existing content in a Column
            Column(
              children: [
                // WRAP your existing content in Expanded
                Expanded(
                  child: Stack(
                    children: [
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(height: 80),
                            Image.asset("./assets/splash.png", width: 180, height: 180),
                            const SizedBox(height: 80),
                            const Text(
                              "Created by:",
                              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 15),
                            Text(
                              "amrqhz",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.anticDidone(
                                fontSize: 28, 
                                fontWeight: FontWeight.bold
                              ),
                            ),
                            const SizedBox(height: 40),
                            // const Text(
                            //   "Copyright all reserved 2025",
                            //   style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                            // ),
                            const SizedBox(height: 80),
                          ],
                        ),
                      ),
                      const SizedBox(height: 100),
                      Positioned(
                        bottom: 40,
                        left: 0,
                        right: 0,
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: const BoxDecoration(
                                    color: Colors.black,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 15),
                            const Text(
                              "APP Version : Beta",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}