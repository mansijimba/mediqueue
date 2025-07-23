import 'package:equatable/equatable.dart';
import 'package:mediqueue/features/doctor/domain/entity/doctor_entity.dart';

class DoctorListState extends Equatable {
  final bool isLoading;
  final bool isSuccess;
  final List<DoctorEntity> doctors;
  final String? errorMessage;

  const DoctorListState({
    required this.isLoading,
    required this.isSuccess,
    required this.doctors,
    this.errorMessage,
  });

  const DoctorListState.initial()
      : isLoading = false,
        isSuccess = false,
        doctors = const [],
        errorMessage = null;

  DoctorListState copyWith({
    bool? isLoading,
    bool? isSuccess,
    List<DoctorEntity>? doctors,
    String? errorMessage,
  }) {
    return DoctorListState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      doctors: doctors ?? this.doctors,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [isLoading, isSuccess, doctors, errorMessage];
}
