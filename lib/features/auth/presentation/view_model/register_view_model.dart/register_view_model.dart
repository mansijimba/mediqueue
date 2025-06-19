import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mediqueue/core/common/snackbar/my_snackbar.dart';
import 'package:mediqueue/features/auth/domain/use_case/user_register_usecase.dart';
import 'package:mediqueue/features/auth/presentation/view_model/register_view_model.dart/register_event.dart';
import 'package:mediqueue/features/auth/presentation/view_model/register_view_model.dart/register_state.dart';

class RegisterViewModel extends Bloc<RegisterEvent, RegisterState> {
  final UserRegisterUsecase _registerUsecase;

  RegisterViewModel({required UserRegisterUsecase registerUsecase,})
    : _registerUsecase = registerUsecase,
    super(RegisterState.initial()) {
    on<RegisterUserEvent>(_onRegisterUser);
  }
  Future<void> _onRegisterUser(
    RegisterUserEvent event,
    Emitter<RegisterState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));

    final result = await _registerUsecase(
      RegisterUserParams(
        fullName: event.fullName,
        phone: event.phone,
        email: event.email,
        password: event.password,
      ),
    );

    result.fold(
      (l) {
        emit(state.copyWith(isLoading: false, isSuccess: false));
        showMySnackBar(
          context: event.context,
          message: l.message,
          color: Colors.red,
        );
      },
      (r) {
        emit(state.copyWith(isLoading: false, isSuccess: true));
        showMySnackBar(
          context: event.context,
          message: "Registration Successful",
        );
      },
    );
  }
}
