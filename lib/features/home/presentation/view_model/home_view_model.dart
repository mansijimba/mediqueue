import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mediqueue/app/utils/shake_detector.dart';
import 'package:mediqueue/features/auth/presentation/view_model/login_view_model.dart/login_view_model.dart';
import 'package:mediqueue/features/home/domain/usecase/home_usecase.dart';
import 'package:mediqueue/features/home/presentation/view_model/home_state.dart';

class HomeViewModel extends Cubit<HomeState> {
  HomeViewModel({required this.logoutUseCase, required this.loginViewModel})
    : super(HomeState.initial()) {
    _initShakeDetector();
  }

  final LogoutUseCase logoutUseCase;
  final LoginViewModel loginViewModel;

  late final ShakeDetector _shakeDetector;
  BuildContext? currentContext;

  void setContext(BuildContext context) {
    currentContext = context;
  }

  void onTabTapped(int index) {
    emit(state.copyWith(selectedIndex: index));
  }

  void logout(BuildContext context) {
    emit(state.copyWith(isLoggingOut: true));
    logoutUseCase.execute(context);
  }

  void _initShakeDetector() {
    print("ShakeDetector initializing...");
    _shakeDetector = ShakeDetector(
      onShake: () {
        print("Shake detected!");
        if (currentContext != null) {
          logout(currentContext!);
        }
      },
    );
    _shakeDetector.startListening();
  }

  @override
  Future<void> close() {
    _shakeDetector.stopListening();
    return super.close();
  }
}
