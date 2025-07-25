import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mediqueue/features/doctor/presentation/view_model/doctor_view_model.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mediqueue/features/doctor/domain/entity/doctor_entity.dart';
import 'package:mediqueue/features/doctor/domain/usecase/doctor_get_all_usecase.dart';
import 'package:mediqueue/features/doctor/presentation/view_model/doctor_event.dart';
import 'package:mediqueue/features/doctor/presentation/view_model/doctor_state.dart';
import 'package:mediqueue/core/error/failure.dart';

class MockDoctorGetAllUsecase extends Mock implements DoctorGetAllUsecase {}

void main() {
  late DoctorListViewModel viewModel;
  late MockDoctorGetAllUsecase mockUsecase;

  setUp(() {
    mockUsecase = MockDoctorGetAllUsecase();
    viewModel = DoctorListViewModel(mockUsecase);
  });

  const tDoctors = [
    DoctorEntity(
      id: '1',
      name: 'Dr. John',
      specialty: 'Cardiology',
      availability: 'MWF',
      appointments: 3,
      filepath: 'path/to/file.jpg',
    ),
    DoctorEntity(
      id: '2',
      name: 'Dr. Jane',
      specialty: 'Neurology',
      availability: 'TTh',
      appointments: 5,
      filepath: null,
    ),
  ];

  group('DoctorListViewModel Tests', () {
    blocTest<DoctorListViewModel, DoctorListState>(
      'emits [loading, success] when FetchDoctors is successful',
      build: () {
        when(() => mockUsecase()).thenAnswer((_) async => const Right(tDoctors));
        return viewModel;
      },
      act: (bloc) => bloc.add(FetchDoctors()),
      expect: () => [
        const DoctorListState(
          isLoading: true,
          isSuccess: false,
          errorMessage: null,
          doctors: [],
        ),
        const DoctorListState(
          isLoading: false,
          isSuccess: true,
          errorMessage: null,
          doctors: tDoctors,
        ),
      ],
      verify: (_) {
        verify(() => mockUsecase()).called(1);
      },
    );

    blocTest<DoctorListViewModel, DoctorListState>(
      'emits [loading, failure] when FetchDoctors fails',
      build: () {
        when(() => mockUsecase()).thenAnswer(
          (_) async => const Left(LocalDatabaseFailure(message: 'Database error')),
        );
        return viewModel;
      },
      act: (bloc) => bloc.add(FetchDoctors()),
      expect: () => [
        const DoctorListState(
          isLoading: true,
          isSuccess: false,
          errorMessage: null,
          doctors: [],
        ),
        const DoctorListState(
          isLoading: false,
          isSuccess: false,
          errorMessage: 'Database error',
          doctors: [],
        ),
      ],
      verify: (_) {
        verify(() => mockUsecase()).called(1);
      },
    );
  });
}
