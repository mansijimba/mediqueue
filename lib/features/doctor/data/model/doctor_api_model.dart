import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:mediqueue/features/doctor/domain/entity/doctor_entity.dart';

part 'doctor_api_model.g.dart';

@JsonSerializable()
class DoctorApiModel extends Equatable {
  @JsonKey(name: '_id')
  final String? id;
  final String name;
  final String specialty;
  final String availability;
  final int appointments;
  final String? filepath;

  const DoctorApiModel({
    this.id,
    required this.name,
    required this.specialty,
    required this.availability,
    required this.appointments,
    this.filepath,
  });

  factory DoctorApiModel.fromJson(Map<String, dynamic> json) =>
      _$DoctorApiModelFromJson(json);

  Map<String, dynamic> toJson() {
    final json = _$DoctorApiModelToJson(this);
    if (json['_id'] == null) {
      json.remove('_id');
    }
    return json;
  }

  // From Entity
  factory DoctorApiModel.fromEntity(DoctorEntity entity) {
    return DoctorApiModel(
      id: entity.id,
      name: entity.name,
      specialty: entity.specialty,
      availability: entity.availability,
      appointments: entity.appointments,
      filepath: entity.filepath,
    );
  }

  // To Entity
DoctorEntity toEntity() {
  const String baseUrl = 'http://10.0.2.2:5050'; // Your backend base URL

  String? fullFilepath;
  if (filepath == null || filepath!.isEmpty) {
    fullFilepath = null;
  } else if (filepath!.startsWith('http')) {
    // Already a full URL, use as is
    fullFilepath = filepath;
  } else {
    // Normalize slashes: replace backslash with forward slash
    String normalizedPath = filepath!.replaceAll(r'\', '/');

    // Ensure there is exactly one slash between baseUrl and normalizedPath
    if (!normalizedPath.startsWith('/')) {
      normalizedPath = '/$normalizedPath';
    }

    fullFilepath = baseUrl + normalizedPath;
  }

  return DoctorEntity(
    id: id ?? '',
    name: name,
    specialty: specialty,
    availability: availability,
    appointments: appointments,
    filepath: fullFilepath,
  );
}


  @override
  List<Object?> get props => [id, name, specialty, availability, appointments, filepath];
}
