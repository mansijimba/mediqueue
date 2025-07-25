import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mediqueue/features/appointment/domain/use_case/book_appointment_usecase.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mediqueue/features/appointment/domain/entity/appointment_entity.dart';
import 'package:mediqueue/features/appointment/domain/repository/appointment_repository.dart';
import 'package:mediqueue/core/error/failure.dart';


class MockAppointmentRepository extends Mock implements IAppointmentRepository {}

void main() {
  late AppointmentBookUseCase usecase;
  late MockAppointmentRepository mockRepository;

  setUp(() {
    mockRepository = MockAppointmentRepository();
    usecase = AppointmentBookUseCase(appointmentRepository: mockRepository);
  });

  final tParams = AppointmentBookParams(
    doctorId: 'doc123',
    patientId: 'pat456',
    specialty: 'Cardiology',
    date: '2025-07-30',
    time: '10:00',
    type: 'Consultation',
  );

  final tAppointmentEntity = AppointmentEntity(
    id: 'app789',
    doctorId: 'doc123',
    patientId: 'pat456',
    specialty: 'Cardiology',
    date: '2025-07-30',
    time: '10:00',
    type: 'Consultation',
    status: 'Booked', doctorName: 'test1',
  );

  test('should book an appointment using the repository and return AppointmentEntity on success', () async {
    // Arrange
    when(() => mockRepository.bookAppointment(
          doctorId: any(named: 'doctorId'),
          patientId: any(named: 'patientId'),
          specialty: any(named: 'specialty'),
          date: any(named: 'date'),
          time: any(named: 'time'),
          type: any(named: 'type'),
        )).thenAnswer((_) async => Right(tAppointmentEntity));

    // Act
    final result = await usecase(tParams);

    // Assert
    expect(result, Right(tAppointmentEntity));
    verify(() => mockRepository.bookAppointment(
          doctorId: tParams.doctorId,
          patientId: tParams.patientId,
          specialty: tParams.specialty,
          date: tParams.date,
          time: tParams.time,
          type: tParams.type,
        )).called(1);
    verifyNoMoreInteractions(mockRepository);
  });

  test('should return Failure when repository returns Failure', () async {
    // Arrange
    final failure = RemoteDatabaseFailure(message: 'Booking failed');

    when(() => mockRepository.bookAppointment(
          doctorId: any(named: 'doctorId'),
          patientId: any(named: 'patientId'),
          specialty: any(named: 'specialty'),
          date: any(named: 'date'),
          time: any(named: 'time'),
          type: any(named: 'type'),
        )).thenAnswer((_) async => Left(failure));

    // Act
    final result = await usecase(tParams);

    // Assert
    expect(result, Left(failure));
    verify(() => mockRepository.bookAppointment(
          doctorId: tParams.doctorId,
          patientId: tParams.patientId,
          specialty: tParams.specialty,
          date: tParams.date,
          time: tParams.time,
          type: tParams.type,
        )).called(1);
    verifyNoMoreInteractions(mockRepository);
  });

  test('should forward the exact parameters to repository without modification', () async {
  // Arrange
  when(() => mockRepository.bookAppointment(
        doctorId: any(named: 'doctorId'),
        patientId: any(named: 'patientId'),
        specialty: any(named: 'specialty'),
        date: any(named: 'date'),
        time: any(named: 'time'),
        type: any(named: 'type'),
      )).thenAnswer((_) async => Right(tAppointmentEntity));

  // Act
  await usecase(tParams);

  // Assert
  final captured = verify(() => mockRepository.bookAppointment(
        doctorId: captureAny(named: 'doctorId'),
        patientId: captureAny(named: 'patientId'),
        specialty: captureAny(named: 'specialty'),
        date: captureAny(named: 'date'),
        time: captureAny(named: 'time'),
        type: captureAny(named: 'type'),
      )).captured;

  expect(captured[0], tParams.doctorId);
  expect(captured[1], tParams.patientId);
  expect(captured[2], tParams.specialty);
  expect(captured[3], tParams.date);
  expect(captured[4], tParams.time);
  expect(captured[5], tParams.type);
});

}
