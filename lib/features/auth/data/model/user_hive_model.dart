import 'package:equatable/equatable.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:mediqueue/app/constant/hive_table_constant.dart';
import 'package:mediqueue/features/auth/domain/entity/user_entity.dart';
import 'package:uuid/uuid.dart';

part 'user_hive_model.g.dart';

@HiveType(typeId: HiveTableConstant.userTableId)
class UserHiveModel extends Equatable {
  @HiveField(0)
  final String? userId;
  @HiveField(1)
  final String fullName;
  @HiveField(2)
  final String phone;
  @HiveField(3)
  final String email;
  @HiveField(4)
  final String password;

  UserHiveModel({
    String? userId,
    required this.fullName,
    required this.phone,
    required this.email,
    required this.password,
  }) : userId = userId ?? const Uuid().v4();

  //Initial Constructor
  const UserHiveModel.initial()
    : userId = '',
      fullName = '',
      phone = '',
      email = '',
      password = '';

  //From Entity
  factory UserHiveModel.fromEntity(UserEntity entity) {
    return UserHiveModel(
      userId: entity.userId,
      fullName: entity.fullName,
      phone: entity.phone,
      email: entity.email,
      password: entity.password,
    );
  }

  //To entity
  UserEntity toEntity() {
    return UserEntity(
      userId: userId,
      fullName: fullName,
      phone: phone,
      email: email,
      password: password,
    );
  }

  @override
  List<Object?> get props => [
    userId,
    fullName,
    phone,
    email,
    password,
  ];
}
