import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mediqueue/app/service_locator/service_locator.dart';
import 'package:mediqueue/app/shared_pref/token_shared_prefs.dart';
import 'package:mediqueue/core/common/snackbar/my_snackbar.dart';
import 'package:mediqueue/features/auth/domain/use_case/user_get_current_usecase.dart';
import 'package:mediqueue/features/auth/domain/use_case/user_login_usecase.dart';
import 'package:mediqueue/features/auth/presentation/View/signup.dart';
import 'package:mediqueue/features/auth/presentation/view_model/login_view_model.dart/login_event.dart';
import 'package:mediqueue/features/auth/presentation/view_model/login_view_model.dart/login_state.dart';
import 'package:mediqueue/features/auth/presentation/view_model/register_view_model.dart/register_view_model.dart';
import 'package:mediqueue/features/home/presentation/view/main_dashboard_entry_view.dart';

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

    await result.fold(
      (failure) async {
        emit(state.copyWith(isLoading: false, isSuccess: false));
        showMySnackBar(
          context: event.context,
          message: failure.message ?? 'Invalid credentials',
          color: Colors.red,
        );
      },
      (token) async {
        await serviceLocator<TokenSharedPrefs>().saveToken(token);

        final userResult = await serviceLocator<UserGetCurrentUsecase>().call();

        await userResult.fold(
          (failure) async {
            emit(state.copyWith(isLoading: false, isSuccess: false));
            showMySnackBar(
              context: event.context,
              message: 'Failed to get user: ${failure.message}',
              color: Colors.red,
            );
          },
          (user) async {
            emit(state.copyWith(isLoading: false, isSuccess: true));
            showMySnackBar(
              context: event.context,
              message: 'Login Successful',
              color: Colors.green,
            );

            Navigator.pushReplacement(
              event.context,
              MaterialPageRoute(
                builder: (_) => MainDashboardEntry(
                  patientId: user.userId!,
                ),
              ),
            );
          },
        );
      },
    );
  }

  // New logout method
  Future<void> logout() async {
    // Clear saved token
    await serviceLocator<TokenSharedPrefs>().clearToken();

    // Reset the login state (optional, you can create a separate loggedOut state if needed)
    emit(LoginState.initial());
  }
}
