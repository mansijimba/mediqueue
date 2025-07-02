import 'package:mediqueue/features/auth/domain/entity/user_entity.dart';

abstract interface class IUserDataSource {
  Future<void> registerUser(UserEntity userData);

  Future<String> loginUser(String email, String password);

  Future<UserEntity> getCurrentUser();
}
