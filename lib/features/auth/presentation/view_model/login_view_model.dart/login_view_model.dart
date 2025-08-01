import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_auth/local_auth.dart';
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
    on<LoginWithFingerprintEvent>(_onLoginWithFingerprint); // 🔹 Add this line
  }

  void _onNavigateToRegisterView(
    NavigateToRegisterViewEvent event,
    Emitter<LoginState> emit,
  ) {
    if (event.context.mounted) {
      Navigator.push(
        event.context,
        MaterialPageRoute(
          builder:
              (context) => MultiBlocProvider(
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
                builder: (_) => MainDashboardEntry(patientId: user.userId!),
              ),
            );
          },
        );
      },
    );
  }

  // 🔐 Fingerprint Authentication Handler
  void _onLoginWithFingerprint(
    LoginWithFingerprintEvent event,
    Emitter<LoginState> emit,
  ) async {
    final LocalAuthentication auth = LocalAuthentication();
    emit(state.copyWith(isLoading: true));

    try {
      final bool canCheck = await auth.canCheckBiometrics;
      if (!canCheck) {
        emit(state.copyWith(isLoading: false));
        showMySnackBar(
          context: event.context,
          message: 'Biometric authentication not available',
          color: Colors.orange,
        );
        return;
      }

      final bool authenticated = await auth.authenticate(
        localizedReason: 'Scan your fingerprint to login',
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
        ),
      );

      if (!authenticated) {
        emit(state.copyWith(isLoading: false));
        showMySnackBar(
          context: event.context,
          message: 'Fingerprint authentication failed',
          color: Colors.red,
        );
        return;
      }

      // Check for saved token
      final token = await serviceLocator<TokenSharedPrefs>().getToken();
      if (token == null) {
        emit(state.copyWith(isLoading: false));
        showMySnackBar(
          context: event.context,
          message: 'No session found. Please login with email/password first.',
          color: Colors.orange,
        );
        return;
      }

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
            message: 'Login Successful via Fingerprint',
            color: Colors.green,
          );
          Navigator.pushReplacement(
            event.context,
            MaterialPageRoute(
              builder: (_) => MainDashboardEntry(patientId: user.userId!),
            ),
          );
        },
      );
    } catch (e) {
      emit(state.copyWith(isLoading: false));
      showMySnackBar(
        context: event.context,
        message: "Fingerprint auth failed: ${e.toString()}",
        color: Colors.red,
      );
    }
  }

  // 🔓 Logout
  Future<void> logout() async {
    await serviceLocator<TokenSharedPrefs>().clearToken();
    emit(LoginState.initial());
  }
}
