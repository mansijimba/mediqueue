import 'package:hive_flutter/adapters.dart';
import 'package:mediqueue/app/constant/hive_table_constant.dart';
import 'package:mediqueue/features/auth/data/model/user_hive_model.dart';
import 'package:path_provider/path_provider.dart';

class HiveService {
  Future<void> init() async {
    // Initialize the database
    var directory = await getApplicationDocumentsDirectory();
    var path = '${directory.path}user_management.db';

    Hive.init(path);

    Hive.registerAdapter(UserHiveModelAdapter());
  }

  Future<void> register(UserHiveModel auth) async {
    var box = await Hive.openBox<UserHiveModel>(HiveTableConstant.userBox);
    await box.put(auth.userId, auth);
  }

  Future<void> deleteAuth(String id) async {
    var box = await Hive.openBox<UserHiveModel>(HiveTableConstant.userBox);
    await box.delete(id);
  }

  Future<List<UserHiveModel>> getAllAuth() async {
    var box = await Hive.openBox<UserHiveModel>(HiveTableConstant.userBox);
    return box.values.toList();
  }

  //Login using email and passowrd
  Future<UserHiveModel?> login(String email, String password) async {
    var box = await Hive.openBox<UserHiveModel>(HiveTableConstant.userBox);
    var user = box.values.firstWhere(
      (element) => element.email == email && element.password == password,
      orElse: () => throw Exception('Invalid username or password'),
    );
    box.close();
    return user;
  }

  //Clear all data and delete database
  Future<void> clearAll() async {
    await Hive.deleteFromDisk();
    await Hive.deleteBoxFromDisk(HiveTableConstant.userBox);
  }

  Future<void> close() async {
    await Hive.close();
  }
}
