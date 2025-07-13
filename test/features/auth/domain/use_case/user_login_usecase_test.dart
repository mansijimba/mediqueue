import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mediqueue/core/error/failure.dart';
import 'package:mediqueue/features/auth/domain/use_case/user_login_usecase.dart';
import 'package:mocktail/mocktail.dart';

import 'auth_repo.mock.dart';
import 'token.mock.dart';

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

  test(
    'should call the [AuthRepo.loginUser] with correct email and password (pompom@gmail.com, pompom)',
    () async {
      when(() => repository.loginUser(any(), any())).thenAnswer((
        invocation,
      ) async {
        final email = invocation.positionalArguments[0] as String;
        final password = invocation.positionalArguments[1] as String;
        if (email == 'pompom@gmail.com' && password == 'pompom') {
          return Future.value(const Right('token'));
        } else {
          return Future.value(
            const Left(
              RemoteDatabaseFailure(message: 'Invalid username or password'),
            ),
          );
        }
      });

      when(
        () => tokenSharedPrefs.saveToken(any()),
      ).thenAnswer((_) async => Right(null));

      final result = await usecase(
        LoginParams(email: 'pompom@gmail.com', password: 'pompom'),
      );

      expect(result, const Right('token'));

      verify(() => repository.loginUser(any(), any())).called(1);
      verify(() => tokenSharedPrefs.saveToken(any())).called(1);

      verifyNoMoreInteractions(repository);
      verifyNoMoreInteractions(tokenSharedPrefs);
    },
  );
  tearDown(() {
    reset(repository);
    reset(tokenSharedPrefs);
  });
}
