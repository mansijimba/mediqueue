import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mediqueue/app/service_locator/service_locator.dart';
import 'package:mediqueue/core/common/snackbar/my_snackbar.dart';
import 'package:mediqueue/features/auth/domain/use_case/user_login_usecase.dart';
import 'package:mediqueue/features/auth/presentation/View/signup.dart';
import 'package:mediqueue/features/auth/presentation/view_model/login_view_model.dart/login_event.dart';
import 'package:mediqueue/features/auth/presentation/view_model/login_view_model.dart/login_state.dart';
import 'package:mediqueue/features/auth/presentation/view_model/register_view_model.dart/register_view_model.dart';

class LoginViewModel extends Bloc<LoginEvent, LoginState> {
  final UserLoginUsecase _userLoginUsecase;

  LoginViewModel(this._userLoginUsecase) : super(LoginState.initial()) {
    on<NavigateToRegisterViewEvent>(_onNavigateToRegisterView);
    on<LoginWithEmailAndPasswordEvent>(_onLoginWithEmailAndPassword);
    on<NavigateToHomeViewEvent>(_onNavigateToHomeView);
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
    emit(state.copyWith(isLoading: true));

    final result = await _userLoginUsecase(
      LoginParams(email: event.email, password: event.password),
    );

    result.fold(
      (failure) {
        // Handle failure case
        emit(state.copyWith(isLoading: false, isSuccess: false));

        showMySnackBar(
          context: event.context,
          message: 'Invalid credentials. Please try again.',
          color: Colors.red,
        );
      },
      (token) {
        // ✅ Success snackbar
        showMySnackBar(
          context: event.context,
          message: 'Login successful!',
          color: Colors.green,
        );

        // Handle success case
        emit(state.copyWith(isLoading: false, isSuccess: true));

        // Navigate to home/dashboard
        add(NavigateToHomeViewEvent(context: event.context));
      },
    );
  }

  void _onNavigateToHomeView(
    NavigateToHomeViewEvent event,
    Emitter<LoginState> emit,
  ) {
    if (event.context.mounted) {
      Navigator.pushReplacementNamed(event.context, '/dashboard');
    }
  }
}
