import 'dart:math';
import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:mediqueue/features/auth/presentation/view/login.dart';
import 'package:mediqueue/features/auth/presentation/view_model/login_view_model.dart/login_view_model.dart';

class LogoutUseCase {
  final LoginViewModel loginViewModel;

  LogoutUseCase(this.loginViewModel);

  Future<void> execute(BuildContext context) async {
    // Clear user session or token here before navigation
    await loginViewModel.logout(); // You must implement this method to clear session

    // Optional delay for UX reasons
    await Future.delayed(const Duration(seconds: 1));

    if (context.mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => BlocProvider.value(
            value: loginViewModel,
            child: const LoginPage(),
          ),
        ),
      );
    }
  }
}


class ShakeDetectionUseCase {
  static const double shakeThreshold = 15.0;

  bool isShakeDetected(AccelerometerEvent event) {
    final acceleration = sqrt(
      event.x * event.x + event.y * event.y + event.z * event.z,
    );
    return acceleration > shakeThreshold;
  }
}
