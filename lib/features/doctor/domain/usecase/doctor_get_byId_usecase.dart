import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:mediqueue/app/use_case/usecase.dart';
import 'package:mediqueue/core/error/failure.dart';
import 'package:mediqueue/features/doctor/domain/entity/doctor_entity.dart';
import 'package:mediqueue/features/doctor/domain/repository/doctor_repository.dart';

class DoctorGetByIdParams extends Equatable {
  final String doctorId;
  DoctorGetByIdParams(this.doctorId);

  @override
  List<Object?> get props => [doctorId];
}

class DoctorGetByIdUsecase implements UsecaseWithParams<DoctorEntity, DoctorGetByIdParams> {
  final IDoctorRepository _doctorRepository;

  DoctorGetByIdUsecase({required IDoctorRepository doctorRepository})
      : _doctorRepository = doctorRepository;

  @override
  Future<Either<Failure, DoctorEntity>> call(DoctorGetByIdParams params) {
    return _doctorRepository.getDoctorById(params.doctorId);
  }
}
