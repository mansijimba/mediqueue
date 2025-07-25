import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mediqueue/features/appointment/domain/entity/appointment_entity.dart';
import 'package:mediqueue/features/appointment/domain/use_case/appointment_cancel.usecase.dart';
import 'package:mediqueue/features/appointment/domain/use_case/appointment_get_by_patient_id_usecase.dart';
import 'package:mediqueue/features/appointment/domain/use_case/book_appointment_usecase.dart';
import 'package:mediqueue/features/appointment/presentation/view_model/appointment_event.dart';
import 'package:mediqueue/features/appointment/presentation/view_model/appointment_state.dart';
import 'package:mediqueue/features/appointment/presentation/view_model/appointment_view_model.dart';
import 'package:mediqueue/core/error/failure.dart';

// Mocks for UseCases
class MockGetUserAppointmentsUseCase extends Mock
    implements GetUserAppointmentsUseCase {}

class MockAppointmentBookUseCase extends Mock
    implements AppointmentBookUseCase {}

class MockCancelAppointmentUseCase extends Mock
    implements CancelAppointmentUseCase {}

// Mock classes for parameters — used as fallback values for any() matcher
class MockAppointmentBookParams extends Mock implements AppointmentBookParams {}

class MockGetUserAppointmentsParams extends Mock
    implements GetUserAppointmentsParams {}

class MockCancelAppointmentParams extends Mock
    implements CancelAppointmentParams {}

void main() {
  // Register fallback mocks for parameter types
  setUpAll(() {
    registerFallbackValue(MockAppointmentBookParams());
    registerFallbackValue(MockGetUserAppointmentsParams());
    registerFallbackValue(MockCancelAppointmentParams());
  });

  late MockGetUserAppointmentsUseCase mockGetAppointmentsUseCase;
  late MockAppointmentBookUseCase mockBookAppointmentUseCase;
  late MockCancelAppointmentUseCase mockCancelAppointmentUseCase;
  late AppointmentViewModel bloc;

  final tPatientId = 'pat123';
  final tAppointment = AppointmentEntity(
    id: 'app1',
    doctorId: 'doc1',
    patientId: tPatientId,
    specialty: 'Cardiology',
    date: '2025-07-30',
    time: '10:00',
    type: 'Consultation',
    status: 'Booked',
    doctorName: 'Dr. A',
  );

  setUp(() {
    mockGetAppointmentsUseCase = MockGetUserAppointmentsUseCase();
    mockBookAppointmentUseCase = MockAppointmentBookUseCase();
    mockCancelAppointmentUseCase = MockCancelAppointmentUseCase();

    bloc = AppointmentViewModel(
      getAppointmentsUseCase: mockGetAppointmentsUseCase,
      bookAppointmentUseCase: mockBookAppointmentUseCase,
      cancelAppointmentUseCase: mockCancelAppointmentUseCase,
    );
  });

  group('FetchAppointmentsByPatientId', () {
    blocTest<AppointmentViewModel, AppointmentState>(
      'emits [loading, success] when fetch is successful',
      build: () {
        when(
          () =>
              mockGetAppointmentsUseCase(GetUserAppointmentsParams(tPatientId)),
        ).thenAnswer((_) async => Right([tAppointment]));
        return bloc;
      },
      act: (bloc) => bloc.add(FetchAppointmentsByPatientId(tPatientId)),
      expect:
          () => [
            const AppointmentState.initial().copyWith(isLoading: true),
            AppointmentState.initial().copyWith(
              isLoading: false,
              appointments: [tAppointment],
              isSuccess: true,
            ),
          ],
      verify: (_) {
        verify(
          () =>
              mockGetAppointmentsUseCase(GetUserAppointmentsParams(tPatientId)),
        ).called(1);
      },
    );

    blocTest<AppointmentViewModel, AppointmentState>(
      'emits [loading, error] when fetch fails',
      build: () {
        when(
          () =>
              mockGetAppointmentsUseCase(GetUserAppointmentsParams(tPatientId)),
        ).thenAnswer(
          (_) async => Left(RemoteDatabaseFailure(message: 'Error')),
        );
        return bloc;
      },
      act: (bloc) => bloc.add(FetchAppointmentsByPatientId(tPatientId)),
      expect:
          () => [
            const AppointmentState.initial().copyWith(isLoading: true),
            const AppointmentState.initial().copyWith(
              isLoading: false,
              errorMessage: 'Error',
            ),
          ],
    );
  });

  group('BookAppointmentEvent', () {
    final tBookEvent = BookAppointmentEvent(
      doctorId: 'doc1',
      patientId: tPatientId,
      specialty: 'Cardiology',
      date: '2025-07-30',
      time: '10:00',
      type: 'Consultation',
    );

    blocTest<AppointmentViewModel, AppointmentState>(
      'emits [loading, error] when booking fails',
      build: () {
        when(() => mockBookAppointmentUseCase(any())).thenAnswer(
          (_) async => Left(RemoteDatabaseFailure(message: 'Booking failed')),
        );
        return bloc;
      },
      act: (bloc) => bloc.add(tBookEvent),
      expect:
          () => [
            const AppointmentState.initial().copyWith(isLoading: true),
            const AppointmentState.initial().copyWith(
              isLoading: false,
              errorMessage: 'Booking failed',
            ),
          ],
    );
  });

  group('CancelAppointmentEvent', () {
    final tCancelEvent = CancelAppointmentEvent(
      appointmentId: 'app1',
      patientId: tPatientId,
    );

    blocTest<AppointmentViewModel, AppointmentState>(
      'emits [loading, success] and fetches appointments after cancel success',
      build: () {
        // Mock cancel use case
        when(
          () => mockCancelAppointmentUseCase(any()),
        ).thenAnswer((_) async => const Right(true));

        // Mock fetch appointments use case
        when(
          () =>
              mockGetAppointmentsUseCase(GetUserAppointmentsParams(tPatientId)),
        ).thenAnswer((_) async => Right([tAppointment]));

        return bloc;
      },
      act: (bloc) => bloc.add(tCancelEvent),
      expect:
          () => [
            // Cancel loading
            const AppointmentState.initial().copyWith(isLoading: true),

            // Cancel success
            const AppointmentState.initial().copyWith(
              isLoading: false,
              isSuccess: true,
            ),

            // Fetch loading (note: success is retained)
            const AppointmentState.initial().copyWith(
              isLoading: true,
              isSuccess: true,
            ),

            // Fetch success
            AppointmentState.initial().copyWith(
              isLoading: false,
              appointments: [tAppointment],
              isSuccess: true,
            ),
          ],
      verify: (_) {
        verify(() => mockCancelAppointmentUseCase(any())).called(1);
        verify(
          () =>
              mockGetAppointmentsUseCase(GetUserAppointmentsParams(tPatientId)),
        ).called(1);
      },
    );

    blocTest<AppointmentViewModel, AppointmentState>(
      'emits [loading, error] when cancel fails',
      build: () {
        when(() => mockCancelAppointmentUseCase(any())).thenAnswer(
          (_) async => Left(RemoteDatabaseFailure(message: 'Cancel failed')),
        );
        return bloc;
      },
      act: (bloc) => bloc.add(tCancelEvent),
      expect:
          () => [
            const AppointmentState.initial().copyWith(isLoading: true),
            const AppointmentState.initial().copyWith(
              isLoading: false,
              errorMessage: 'Cancel failed',
            ),
          ],
    );
  });
}
