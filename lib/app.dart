import 'package:flutter/material.dart';
import 'package:mediqueue/View/login.dart';
import 'package:mediqueue/View/splashscreen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MediQueue',
      theme: ThemeData(primarySwatch: Colors.teal),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/home': (context) => LoginPage(),
      },
    );
  }
}
