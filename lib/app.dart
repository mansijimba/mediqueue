import 'package:flutter/material.dart';
import 'package:mediqueue/View/theme_data.dart';
import 'package:mediqueue/routes/app_route.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MediQueue',
      theme: getApplicationTheme(),
      initialRoute: AppRoute.splashScreenRoute,
      routes: AppRoute.getAppRoutes(),
    );
  }
}
