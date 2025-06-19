import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mediqueue/app/service_locator/service_locator.dart';
import 'package:mediqueue/features/auth/presentation/View/signup.dart';
import 'package:mediqueue/features/auth/presentation/View/theme_data.dart';
import 'package:mediqueue/features/auth/presentation/view_model/login_view_model.dart/login_view_model.dart';
import 'package:mediqueue/features/auth/presentation/view_model/register_view_model.dart/register_view_model.dart';


class MyApp extends StatelessWidget{
  const MyApp({super.key});
  @override
   Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<RegisterViewModel>.value(
          value: serviceLocator<RegisterViewModel>(),
        ),
        BlocProvider<LoginViewModel>.value(
          value: serviceLocator<LoginViewModel>(),
        ),
      ],
      child: MaterialApp(
        // title: 'Student Management',
        debugShowCheckedModeBanner: false,
        theme: getApplicationTheme(),
        home: SignUpPage(), // or your LoginPage
      ),
    );
  }
}