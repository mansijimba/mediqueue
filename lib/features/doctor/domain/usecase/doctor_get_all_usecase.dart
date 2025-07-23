import 'package:dartz/dartz.dart';
import 'package:mediqueue/app/use_case/usecase.dart';
import 'package:mediqueue/core/error/failure.dart';
import 'package:mediqueue/features/doctor/domain/entity/doctor_entity.dart';
import 'package:mediqueue/features/doctor/domain/repository/doctor_repository.dart';

class DoctorGetAllUsecase implements UsecaseWithoutParams<List<DoctorEntity>> {
  final IDoctorRepository _doctorRepository;

  DoctorGetAllUsecase({required IDoctorRepository doctorRepository})
      : _doctorRepository = doctorRepository;

  @override
  Future<Either<Failure, List<DoctorEntity>>> call() {
    return _doctorRepository.getAllDoctors();
  }
}
