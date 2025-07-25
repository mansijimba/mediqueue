import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';

import 'package:mediqueue/features/doctor/domain/usecase/doctor_get_all_usecase.dart';
import 'package:mediqueue/features/doctor/domain/repository/doctor_repository.dart';
import 'package:mediqueue/features/doctor/domain/entity/doctor_entity.dart';
import 'package:mediqueue/core/error/failure.dart';

class MockDoctorRepository extends Mock implements IDoctorRepository {}

void main() {
  late DoctorGetAllUsecase usecase;
  late MockDoctorRepository mockDoctorRepository;

  setUp(() {
    mockDoctorRepository = MockDoctorRepository();
    usecase = DoctorGetAllUsecase(doctorRepository: mockDoctorRepository);
  });

  const tDoctorList = [
    DoctorEntity(
      id: '1',
      name: 'Dr. Smith',
      specialty: 'Cardiology',
      availability: 'MWF 10-2',
      appointments: 5,
      filepath: 'path/to/image.jpg',
    ),
    DoctorEntity(
      id: '2',
      name: 'Dr. Adams',
      specialty: 'Neurology',
      availability: 'TTh 12-4',
      appointments: 3,
      filepath: null,
    ),
  ];

  test('should return list of doctors from repository when successful', () async {
    // arrange
    when(() => mockDoctorRepository.getAllDoctors())
        .thenAnswer((_) async => const Right(tDoctorList));

    // act
    final result = await usecase();

    // assert
    expect(result, const Right(tDoctorList));
    verify(() => mockDoctorRepository.getAllDoctors()).called(1);
    verifyNoMoreInteractions(mockDoctorRepository);
  });

  test('should return Failure when repository call fails', () async {
    // arrange
    const failure = LocalDatabaseFailure(message: 'Failed to fetch doctors');
    when(() => mockDoctorRepository.getAllDoctors())
        .thenAnswer((_) async => const Left(failure));

    // act
    final result = await usecase();

    // assert
    expect(result, const Left(failure));
    verify(() => mockDoctorRepository.getAllDoctors()).called(1);
    verifyNoMoreInteractions(mockDoctorRepository);
  });
}
