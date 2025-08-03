import 'package:equatable/equatable.dart';
import 'package:mediqueue/features/appointment/domain/entity/appointment_entity.dart';

class AppointmentState extends Equatable {
  final bool isLoading;
  final bool isSuccess;
  final List<AppointmentEntity> appointments;
  final AppointmentEntity? lastBookedAppointment;
  final String? errorMessage;

  const AppointmentState({
    required this.isLoading,
    required this.isSuccess,
    required this.appointments,
    this.lastBookedAppointment,
    this.errorMessage,
  });

  const AppointmentState.initial()
    : isLoading = false,
      isSuccess = false,
      appointments = const [],
      lastBookedAppointment = null,
      errorMessage = null;

  AppointmentState copyWith({
    bool? isLoading,
    bool? isSuccess,
    List<AppointmentEntity>? appointments,
    AppointmentEntity? lastBookedAppointment,
    String? errorMessage,
  }) {
    return AppointmentState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      appointments: appointments ?? this.appointments,
      lastBookedAppointment:
          lastBookedAppointment ?? this.lastBookedAppointment,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    isLoading,
    isSuccess,
    appointments,
    lastBookedAppointment,
    errorMessage,
  ];
}