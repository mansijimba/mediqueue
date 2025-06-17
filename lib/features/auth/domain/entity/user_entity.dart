import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String? userId;
  final String fullName;
  final String userName;
  final String phone;
  final String email;
  final String password;

  const UserEntity({
    this.userId,
    required this.fullName,
    required this.userName,
    required this.phone,
    required this.email,
    required this.password,
  });
  
  @override
  // TODO: implement props
  List<Object?> get props => [
    userId,
    fullName,
    userName,
    phone,
    email,
    password
  ];
  
}
