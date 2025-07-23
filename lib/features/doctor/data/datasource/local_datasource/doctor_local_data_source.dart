import 'package:mediqueue/core/network/hive_service.dart';
import 'package:mediqueue/features/doctor/data/datasource/doctor_data_source.dart';
import 'package:mediqueue/features/doctor/domain/entity/doctor_entity.dart';

class DoctorLocalDataSource implements IDoctorDataSource {
  final HiveService _hiveService;

   DoctorLocalDataSource({required HiveService hiveService})
    : _hiveService = hiveService;

  @override
  Future<List<DoctorEntity>> getAllDoctors() {
    throw UnimplementedError();
  }

  @override
  Future<DoctorEntity> getDoctorById(String doctorId) {
    throw UnimplementedError();
  }
}
