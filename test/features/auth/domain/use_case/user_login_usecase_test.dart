import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mediqueue/core/error/failure.dart';
import 'package:mediqueue/features/auth/domain/use_case/user_login_usecase.dart';
import 'package:mediqueue/features/auth/domain/repository/user_repository.dart';
import 'package:mediqueue/app/shared_pref/token_shared_prefs.dart';

// Mock classes
class UserRepoMock extends Mock implements IUserRepository {}
class MockTokenSharedPrefs extends Mock implements TokenSharedPrefs {}

void main() {
  late UserRepoMock repository;
  late MockTokenSharedPrefs tokenSharedPrefs;
  late UserLoginUsecase usecase;

  setUp(() {
    repository = UserRepoMock();
    tokenSharedPrefs = MockTokenSharedPrefs();
    usecase = UserLoginUsecase(
      userRepository: repository,
      tokenSharedPrefs: tokenSharedPrefs,
    );
  });

  test('calls loginUser and saves token on success', () async {
    // Arrange
    when(() => repository.loginUser(any(), any())).thenAnswer((invocation) async {
      final email = invocation.positionalArguments[0] as String;
      final password = invocation.positionalArguments[1] as String;
      if (email == 'aarya@gmail.com' && password == 'aarya12') {
        return const Right('token');
      } else {
        return const Left(RemoteDatabaseFailure(message: 'Invalid username or password'));
      }
    });

    when(() => tokenSharedPrefs.saveToken(any()))
      .thenAnswer((_) async => const Right(null));

    // Act
    final result = await usecase(const LoginParams(email: 'aarya@gmail.com', password: 'aarya12'));

    // Assert
    expect(result, const Right('token'));
    verify(() => repository.loginUser('aarya@gmail.com', 'aarya12')).called(1);
    verify(() => tokenSharedPrefs.saveToken('token')).called(1);
    verifyNoMoreInteractions(repository);
    verifyNoMoreInteractions(tokenSharedPrefs);
  });

  test('returns failure and does not save token on login failure', () async {
    // Arrange
    when(() => repository.loginUser(any(), any())).thenAnswer((_) async =>
      const Left(RemoteDatabaseFailure(message: 'Invalid username or password')));

    // Act
    final result = await usecase(const LoginParams(email: 'wrong@gmail.com', password: 'wrongpass'));

    // Assert
    expect(result.isLeft(), true);
    verify(() => repository.loginUser('wrong@gmail.com', 'wrongpass')).called(1);
    verifyNever(() => tokenSharedPrefs.saveToken(any()));
    verifyNoMoreInteractions(repository);
    verifyNoMoreInteractions(tokenSharedPrefs);
  });
}
