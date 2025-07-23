import 'package:mediqueue/features/doctor/domain/entity/doctor_entity.dart';

abstract interface class IDoctorDataSource {
  Future<List<DoctorEntity>> getAllDoctors();

  Future<DoctorEntity> getDoctorById(String doctorId);
}
