import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mediqueue/app/service_locator/service_locator.dart';
import 'package:mediqueue/core/common/snackbar/my_snackbar.dart';
import 'package:mediqueue/features/auth/domain/use_case/user_login_usecase.dart';
import 'package:mediqueue/features/auth/presentation/View/dashboard.dart';
import 'package:mediqueue/features/auth/presentation/View/signup.dart';
import 'package:mediqueue/features/auth/presentation/view_model/login_view_model.dart/login_event.dart';
import 'package:mediqueue/features/auth/presentation/view_model/login_view_model.dart/login_state.dart';
import 'package:mediqueue/features/auth/presentation/view_model/register_view_model.dart/register_view_model.dart';

class LoginViewModel extends Bloc<LoginEvent, LoginState> {
  final UserLoginUsecase _userLoginUsecase;

  LoginViewModel(this._userLoginUsecase) : super(LoginState.initial()) {
    on<NavigateToRegisterViewEvent>(_onNavigateToRegisterView);
    on<LoginWithEmailAndPasswordEvent>(_onLoginWithEmailAndPassword);
  }

  void _onNavigateToRegisterView(
    NavigateToRegisterViewEvent event,
    Emitter<LoginState> emit,
  ) {
    if (event.context.mounted) {
      Navigator.push(
        event.context,
        MaterialPageRoute(
          builder: (context) => MultiBlocProvider(
            providers: [
              BlocProvider.value(
                value: serviceLocator<RegisterViewModel>(),
              ),
            ],
            child: const SignUpPage(),
          ),
        ),
      );
    }
  }

  void _onLoginWithEmailAndPassword(
    LoginWithEmailAndPasswordEvent event,
    Emitter<LoginState> emit,
  ) async {
    print(
      'Attempting login with email: ${event.email}, password: ${event.password}',
    );

    emit(state.copyWith(isLoading: true));

    final result = await _userLoginUsecase(
      LoginParams(email: event.email.trim(), password: event.password.trim()),
    );

    result.fold(
      (failure) {
        print('Login failed: ${failure.message}');
        emit(state.copyWith(isLoading: false, isSuccess: false));
        try {
          showMySnackBar(
            context: event.context,
            message: failure.message ?? 'Invalid credentials. Please try again.',
            color: Colors.red,
          );
        } catch (_) {
          // Swallow error during test
        }
      },
      (token) {
        print('Login successful: Token = $token');
        emit(state.copyWith(isLoading: false, isSuccess: true));
        try {
          showMySnackBar(
            context: event.context,
            message: "Login Successful",
            color: Colors.green,
          );
          Navigator.pushReplacement(
            event.context,
            MaterialPageRoute(builder: (_) => DashboardScreen()),
          );
        } catch (_) {
          
        }
      },
    );
  }
}
