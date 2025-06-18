import 'package:mediqueue/core/network/hive_service.dart';
import 'package:mediqueue/features/auth/data/data_source/user_data_source.dart';
import 'package:mediqueue/features/auth/data/model/user_hive_model.dart';
import 'package:mediqueue/features/auth/domain/entity/user_entity.dart';

class UserLocalDatasource implements IUserDataSource {
  final HiveService _hiveService;

  UserLocalDatasource({required HiveService hiveService})
    : _hiveService = hiveService;

  @override
  Future<void> registerUser(UserEntity userData) async {
    try {
      final userHiveModel = UserHiveModel.fromEntity(userData);
      await _hiveService.register(userHiveModel);
    } catch (e) {
      throw Exception("Registration failed: $e");
    }
  }
}
