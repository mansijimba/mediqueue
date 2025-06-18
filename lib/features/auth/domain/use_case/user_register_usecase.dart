import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:mediqueue/app/use_case/usecase.dart';
import 'package:mediqueue/core/error/failure.dart';
import 'package:mediqueue/features/auth/domain/entity/user_entity.dart';
import 'package:mediqueue/features/auth/domain/repository/user_repository.dart';

class RegisterUserParams extends Equatable {
  final String fullName;
  final String userName;
  final String phone;
  final String email;
  final String password;

  const RegisterUserParams({
    required this.fullName,
    required this.userName,
    required this.phone,
    required this.email,
    required this.password,
  });

  //initial constructor
  const RegisterUserParams.initial({
    required this.fullName,
    required this.userName,
    required this.phone,
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [fullName, userName, phone, email, password];
}

class UserRegisterUsecase
    implements UsecaseWithParams<void, RegisterUserParams> {
  final IUserRepository _userRepository;

  UserRegisterUsecase({required IUserRepository userRepository})
    : _userRepository = userRepository;

  @override
  Future<Either<Failure, void>> call(RegisterUserParams params) {
    final userEntity = UserEntity(
      fullName: params.fullName,
      userName: params.userName,
      phone: params.phone,
      email: params.email,
      password: params.password,
    );
    return _userRepository.registerUser(userEntity);
  }
}
