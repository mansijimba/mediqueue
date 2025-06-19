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
    password
  ];
  
}
