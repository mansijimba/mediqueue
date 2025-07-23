import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sensors_plus/sensors_plus.dart';

import 'package:mediqueue/features/auth/presentation/view/login.dart';
import 'package:mediqueue/features/auth/presentation/view_model/login_view_model.dart/login_view_model.dart';
import 'package:mediqueue/features/home/presentation/view_model/home_state.dart';

class HomeViewModel extends Cubit<HomeState> {
  HomeViewModel({required this.loginViewModel}) : super(HomeState.initial()) {
    _startShakeDetection();
  }

  final LoginViewModel loginViewModel;

  StreamSubscription<AccelerometerEvent>? _accelerometerSubscription;

  void onTabTapped(int index) {
    emit(state.copyWith(selectedIndex: index));
  }

  void logout(BuildContext context) {
    Future.delayed(const Duration(seconds: 2), () async {
      if (context.mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder:
                (context) => BlocProvider.value(
                  value: loginViewModel,
                  child: const LoginPage(),
                ),
          ),
        );
      }
    });
  }

  void _startShakeDetection() {
    const double shakeThreshold = 15.0;
    _accelerometerSubscription = accelerometerEvents.listen((
      AccelerometerEvent event,
    ) {
      double acceleration = sqrt(
        pow(event.x, 2) + pow(event.y, 2) + pow(event.z, 2),
      );

      if (acceleration > shakeThreshold) {
        // Prevent multiple triggers
        _accelerometerSubscription?.cancel();
        emit(state.copyWith(isLoggingOut: true));

        // Logout via shake
        logout(currentContext!); // Assign your current context
      }
    });
  }

  BuildContext? currentContext;

  void setContext(BuildContext context) {
    currentContext = context;
  }

  @override
  Future<void> close() {
    _accelerometerSubscription?.cancel();
    return super.close();
  }
}
