import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mediqueue/features/appointment/domain/use_case/appointment_cancel.usecase.dart';
import 'package:mediqueue/features/appointment/domain/use_case/appointment_get_by_patient_id_usecase.dart';
import 'package:mediqueue/features/appointment/domain/use_case/book_appointment_usecase.dart';
import 'package:mediqueue/features/appointment/presentation/view_model/appointment_event.dart';
import 'package:mediqueue/features/appointment/presentation/view_model/appointment_state.dart';

class AppointmentViewModel extends Bloc<AppointmentEvent, AppointmentState> {
  final GetUserAppointmentsUseCase getAppointmentsUseCase;
  final AppointmentBookUseCase bookAppointmentUseCase;
  final CancelAppointmentUseCase cancelAppointmentUseCase;

  AppointmentViewModel({
    required this.getAppointmentsUseCase,
    required this.bookAppointmentUseCase,
    required this.cancelAppointmentUseCase,
  }) : super(const AppointmentState.initial()) {
    on<FetchAppointmentsByPatientId>(_onFetchAppointments);
    on<BookAppointmentEvent>(_onBookAppointment);
    on<CancelAppointmentEvent>(_onCancelAppointment);
  }

  Future<void> _onFetchAppointments(
    FetchAppointmentsByPatientId event,
    Emitter<AppointmentState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    final result = await getAppointmentsUseCase(GetUserAppointmentsParams(event.patientId));
    result.fold(
      (failure) => emit(state.copyWith(isLoading: false, errorMessage: failure.message)),
      (appointments) => emit(state.copyWith(
        isLoading: false,
        appointments: appointments,
        isSuccess: true,
      )),
    );
  }

  Future<void> _onBookAppointment(
    BookAppointmentEvent event,
    Emitter<AppointmentState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    final result = await bookAppointmentUseCase(AppointmentBookParams(
      doctorId: event.doctorId,
      patientId: event.patientId,
      specialty: event.specialty,
      date: event.date,
      time: event.time,
      type: event.type,
    ));
    result.fold(
      (failure) => emit(state.copyWith(isLoading: false, errorMessage: failure.message)),
      (appointment) {
        emit(state.copyWith(
          isLoading: false,
          lastBookedAppointment: appointment,
          isSuccess: true,
        ));
        add(FetchAppointmentsByPatientId(event.patientId)); // Refresh list after booking
      },
    );
  }

  Future<void> _onCancelAppointment(
    CancelAppointmentEvent event,
    Emitter<AppointmentState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    final result = await cancelAppointmentUseCase(CancelAppointmentParams(event.appointmentId));
    result.fold(
      (failure) => emit(state.copyWith(isLoading: false, errorMessage: failure.message)),
      (_) {
        emit(state.copyWith(isLoading: false, isSuccess: true));
        add(FetchAppointmentsByPatientId(event.patientId));
       },
    );
  }
} 