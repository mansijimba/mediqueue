import 'package:dartz/dartz.dart';
import 'package:mediqueue/core/error/failure.dart';
import 'package:mediqueue/features/auth/domain/entity/user_entity.dart';

abstract interface class IUserRepository {
  Future<Either<Failure, void>> registerUser(UserEntity user);

  Future<Either<Failure, String>> loginUser(String email, String password);

  Future<Either<Failure, UserEntity>> getCurrentUser();
}
