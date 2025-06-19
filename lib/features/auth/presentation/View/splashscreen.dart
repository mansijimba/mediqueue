import 'package:flutter/material.dart';
import 'dart:async';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 2), () {
      Navigator.pushReplacementNamed(context, '/home');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 243, 249, 237),
      body: Stack(
        children: [
          // Full-screen image, centered and scaled properly
          Center(
            child: Image.asset(
              'assets/images/splash.jpg', // Your full image
              fit: BoxFit.contain, // Shows full image with aspect ratio
              height: double.infinity,
              width: double.infinity,
              alignment: Alignment.center,
            ),
          ),

          // Centered overlay (logo, text, loader)
          Positioned(
            top: 90,
            left: 0,
            right: 0,
            child: Center(
              child: SizedBox(
                height: 100,
                width: 100,
                child: Image.asset('assets/images/logo.png'),
              ),
            ),
          ),

          // Title, subtitle, and progress bar at the bottom
          Positioned(
            bottom: 60,
            left: 0,
            right: 0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Text(
                  'MediQueue',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF00796B),
                  ),
                  textAlign: TextAlign.center,
                ),
                Text(
                  '– Skip the Line, Save Time',
                  style: TextStyle(fontSize: 20, color: Color(0xFF00796B)),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
