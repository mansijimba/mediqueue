import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mediqueue/core/error/failure.dart';
import 'package:mediqueue/features/auth/domain/use_case/user_login_usecase.dart';
import 'package:mediqueue/features/auth/presentation/view_model/login_view_model.dart/login_event.dart';
import 'package:mediqueue/features/auth/presentation/view_model/login_view_model.dart/login_state.dart';
import 'package:mediqueue/features/auth/presentation/view_model/login_view_model.dart/login_view_model.dart';
import 'package:mocktail/mocktail.dart';

class MockUserLoginUsecase extends Mock implements UserLoginUsecase {}

class MockBuildContext extends Mock implements BuildContext {}

void main() {
  late MockUserLoginUsecase mockLoginUsecase;

  setUpAll(() {
    registerFallbackValue(
      const LoginParams(email: 'fallback@email.com', password: 'fallback'),
    );
  });

  setUp(() {
    mockLoginUsecase = MockUserLoginUsecase();
  });

  const email = 'tenzina@gmail.com';
  const password = 'tenzina12';
  const token = 'dummy_token';
  final context = MockBuildContext();

  group('LoginViewModel', () {
    blocTest<LoginViewModel, LoginState>(
      'emits [loading, success] when login is successful',
      build: () {
        when(() => mockLoginUsecase(any())).thenAnswer(
          (_) async => const Right(token),
        );
        return LoginViewModel(mockLoginUsecase);
      },
      act: (bloc) => bloc.add(
        LoginWithEmailAndPasswordEvent(
          email: email,
          password: password,
          context: context,
        ),
      ),
      expect: () => [
        LoginState.initial().copyWith(isLoading: true),
        LoginState.initial().copyWith(isLoading: false, isSuccess: true),
      ],
      verify: (_) {
        verify(() =>
          mockLoginUsecase(LoginParams(email: email, password: password))
        ).called(1);
      },
    );

    blocTest<LoginViewModel, LoginState>(
      'emits [loading, failure] when login fails',
      build: () {
        when(() => mockLoginUsecase(any())).thenAnswer(
          (_) async =>
              const Left(RemoteDatabaseFailure(message: 'Invalid credentials')),
        );
        return LoginViewModel(mockLoginUsecase);
      },
      act: (bloc) => bloc.add(
        LoginWithEmailAndPasswordEvent(
          email: email,
          password: password,
          context: context,
        ),
      ),
      expect: () => [
        LoginState.initial().copyWith(isLoading: true),
        LoginState.initial().copyWith(isLoading: false, isSuccess: false),
      ],
      verify: (_) {
        verify(() =>
          mockLoginUsecase(LoginParams(email: email, password: password))
        ).called(1);
      },
    );
  });
}
