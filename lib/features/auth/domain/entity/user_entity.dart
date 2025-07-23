import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String? userId;
  final String fullName;
  final String phone;
  final String email;
  final String password;

  const UserEntity({
    this.userId,
    required this.fullName,
    required this.phone,
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [
        userId,
        fullName,
        phone,
        email,
        password,
      ];

  /// Factory method to create UserEntity from JSON
  factory UserEntity.fromJson(Map<String, dynamic> json) {
    return UserEntity(
      userId: json['userId'] as String?,
      fullName: json['fullName'] as String,
      phone: json['phone'] as String,
      email: json['email'] as String,
      password: json['password'] as String,
    );
  }

  /// Method to convert UserEntity to JSON
  Map<String, dynamic> toJson() {
    return {
      if (userId != null) 'userId': userId,
      'fullName': fullName,
      'phone': phone,
      'email': email,
      'password': password,
    };
  }
}
