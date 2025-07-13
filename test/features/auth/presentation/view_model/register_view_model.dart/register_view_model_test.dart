import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mediqueue/core/error/failure.dart';
import 'package:mediqueue/features/auth/domain/use_case/user_register_usecase.dart';
import 'package:mediqueue/features/auth/presentation/view_model/register_view_model.dart/register_event.dart';
import 'package:mediqueue/features/auth/presentation/view_model/register_view_model.dart/register_state.dart';
import 'package:mediqueue/features/auth/presentation/view_model/register_view_model.dart/register_view_model.dart';
import 'package:mocktail/mocktail.dart';

class MockRegisterUsecase extends Mock implements UserRegisterUsecase {}

class MockBuildContext extends Mock implements BuildContext {}

void main() {
  late MockRegisterUsecase mockRegisterUsecase;
  late MockBuildContext mockContext;

  setUpAll(() {
    registerFallbackValue(
      const RegisterUserParams(
        fullName: 'fallback',
        phone: '0000000000',
        email: 'fallback@email.com',
        password: 'fallback',
      ),
    );
  });

  setUp(() {
    mockRegisterUsecase = MockRegisterUsecase();
    mockContext = MockBuildContext();
  });

  group('RegisterViewModel', () {
    final event = RegisterUserEvent(
      fullName: 'Test User',
      phone: '1234567890',
      email: 'test@example.com',
      password: 'password123',
      context: MockBuildContext(), 
    );

    blocTest<RegisterViewModel, RegisterState>(
      'emits [loading, success] when registration succeeds',
      build: () {
        when(() => mockRegisterUsecase(any()))
            .thenAnswer((_) async => const Right(null));
        return RegisterViewModel(registerUsecase: mockRegisterUsecase);
      },
      act: (bloc) => bloc.add(event),
      expect: () => [
        RegisterState.initial().copyWith(isLoading: true),
        RegisterState.initial().copyWith(isLoading: false, isSuccess: true),
      ],
      verify: (_) {
        verify(() => mockRegisterUsecase(
              const RegisterUserParams(
                fullName: 'Test User',
                phone: '1234567890',
                email: 'test@example.com',
                password: 'password123',
              ),
            )).called(1);
      },
    );

    blocTest<RegisterViewModel, RegisterState>(
      'emits [loading, failure] when registration fails',
      build: () {
        when(() => mockRegisterUsecase(any())).thenAnswer(
          (_) async =>
              const Left(RemoteDatabaseFailure(message: 'Email already exists')),
        );
        return RegisterViewModel(registerUsecase: mockRegisterUsecase);
      },
      act: (bloc) => bloc.add(event),
      expect: () => [
        RegisterState.initial().copyWith(isLoading: true),
        RegisterState.initial().copyWith(isLoading: false, isSuccess: false),
      ],
      verify: (_) {
        verify(() => mockRegisterUsecase(any())).called(1);
      },
    );
  });
}
