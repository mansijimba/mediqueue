import 'package:equatable/equatable.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:mediqueue/app/constant/hive_table_constant.dart';
import 'package:mediqueue/features/auth/domain/entity/user_entity.dart';
import 'package:uuid/uuid.dart';

part 'user_api_model.g.dart';

@JsonSerializable()
class UserApiModel extends Equatable {
  @JsonKey(name: '_id')
  final String? userId;
  final String fullName;
  final String phone;
  final String email;
  final String password;

  const UserApiModel({
    this.userId,
    required this.fullName,
    required this.phone,
    required this.email,
    required this.password,
  });

  factory UserApiModel.fromJson(Map<String, dynamic> json) =>
      _$UserApiModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserApiModelToJson(this);

  //From Entity
  factory UserApiModel.fromEntity(UserEntity entity) {
    return UserApiModel(
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
  List<Object?> get props => [userId, fullName, phone, email, password];
}
