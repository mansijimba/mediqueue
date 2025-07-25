import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mediqueue/features/appointment/domain/use_case/appointment_get_by_patient_id_usecase.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mediqueue/features/appointment/domain/entity/appointment_entity.dart';
import 'package:mediqueue/features/appointment/domain/repository/appointment_repository.dart';
import 'package:mediqueue/core/error/failure.dart';

class MockAppointmentRepository extends Mock implements IAppointmentRepository {}

void main() {
  late GetUserAppointmentsUseCase usecase;
  late MockAppointmentRepository mockRepository;

  setUp(() {
    mockRepository = MockAppointmentRepository();
    usecase = GetUserAppointmentsUseCase(appointmentRepository: mockRepository);
  });

  const tPatientId = 'pat456';

  final tParams = GetUserAppointmentsParams(tPatientId);

  final tAppointments = [
    AppointmentEntity(
      id: 'app1',
      doctorId: 'doc1',
      patientId: tPatientId,
      specialty: 'Cardiology',
      date: '2025-07-30',
      time: '10:00',
      type: 'Consultation',
      status: 'Booked',
      doctorName: 'Dr. A',
    ),
    AppointmentEntity(
      id: 'app2',
      doctorId: 'doc2',
      patientId: tPatientId,
      specialty: 'Dermatology',
      date: '2025-08-05',
      time: '14:00',
      type: 'Follow-up',
      status: 'Completed',
      doctorName: 'Dr. B',
    ),
  ];

  test('should get list of appointments for patient from repository on success', () async {
    // Arrange
    when(() => mockRepository.getAppointmentsByPatientId(any()))
        .thenAnswer((_) async => Right(tAppointments));

    // Act
    final result = await usecase(tParams);

    // Assert
    expect(result, Right(tAppointments));
    verify(() => mockRepository.getAppointmentsByPatientId(tPatientId)).called(1);
    verifyNoMoreInteractions(mockRepository);
  });

  test('should return Failure when repository returns Failure', () async {
    // Arrange
    final failure = RemoteDatabaseFailure(message: 'Failed to get appointments');

    when(() => mockRepository.getAppointmentsByPatientId(any()))
        .thenAnswer((_) async => Left(failure));

    // Act
    final result = await usecase(tParams);

    // Assert
    expect(result, Left(failure));
    verify(() => mockRepository.getAppointmentsByPatientId(tPatientId)).called(1);
    verifyNoMoreInteractions(mockRepository);
  });
}
