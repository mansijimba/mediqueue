import 'package:equatable/equatable.dart';

class DoctorEntity extends Equatable{
  final String id;
  final String name;
  final String specialty;
  final String availability;
  final int appointments;
  final String? filepath;

  const DoctorEntity({
    required this.id,
    required this.name,
    required this.specialty,
    required this.availability,
    required this.appointments,
    this.filepath,
  });
  
  @override
  List<Object?> get props => [id,name,specialty,availability,appointments,filepath];
}
