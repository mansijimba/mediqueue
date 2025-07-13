import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mediqueue/core/error/failure.dart';
import 'package:mediqueue/features/auth/domain/entity/user_entity.dart';
import 'package:mediqueue/features/auth/domain/repository/user_repository.dart';
import 'package:mediqueue/features/auth/domain/use_case/user_register_usecase.dart';

class UserRepoMock extends Mock implements IUserRepository {}

void main() {
  late UserRepoMock mockRepository;
  late UserRegisterUsecase usecase;

  setUp(() {
    mockRepository = UserRepoMock();
    usecase = UserRegisterUsecase(userRepository: mockRepository);
  });

  const registerParams = RegisterUserParams(
    fullName: 'Pom Pom',
    phone: '1234567890',
    email: 'pompom@gmail.com',
    password: 'pompom123',
  );

  final expectedUserEntity = UserEntity(
    fullName: 'Pom Pom',
    phone: '1234567890',
    email: 'pompom@gmail.com',
    password: 'pompom123',
  );

  test('should call registerUser on repository with correct user entity', () async {
    // Arrange
    when(() => mockRepository.registerUser(expectedUserEntity))
        .thenAnswer((_) async => const Right(null));

    // Act
    final result = await usecase(registerParams);

    // Assert
    expect(result, const Right(null));
    verify(() => mockRepository.registerUser(expectedUserEntity)).called(1);
    verifyNoMoreInteractions(mockRepository);
  });

  test('should return Failure when registration fails', () async {
    // Arrange
    const failure = RemoteDatabaseFailure(message: 'Email already exists');
    when(() => mockRepository.registerUser(expectedUserEntity))
        .thenAnswer((_) async => const Left(failure));

    // Act
    final result = await usecase(registerParams);

    // Assert
    expect(result, const Left(failure));
    verify(() => mockRepository.registerUser(expectedUserEntity)).called(1);
    verifyNoMoreInteractions(mockRepository);
  });
}
