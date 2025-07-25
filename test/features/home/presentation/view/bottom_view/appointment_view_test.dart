import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:mediqueue/features/home/presentation/view/bottom_view/appointment_view.dart';
import 'package:mediqueue/features/appointment/presentation/view_model/appointment_state.dart';
import 'package:mediqueue/features/appointment/presentation/view_model/appointment_view_model.dart';
import 'package:mediqueue/features/appointment/domain/entity/appointment_entity.dart';
import 'package:mediqueue/features/queue/presentation/view/queue_view.dart';

// Mock classes
class MockAppointmentViewModel extends Mock implements AppointmentViewModel {}

class FakeAppointmentState extends Fake implements AppointmentState {}

void main() {
  late MockAppointmentViewModel mockAppointmentViewModel;

  setUpAll(() {
    registerFallbackValue(FakeAppointmentState());
  });

  setUp(() {
    mockAppointmentViewModel = MockAppointmentViewModel();
  });

  const testPatientId = 'patient123';

  testWidgets('shows loading indicator when loading',
      (WidgetTester tester) async {
    // Arrange
    final loadingState = AppointmentState(
      isLoading: true,
      appointments: const [],
      errorMessage: null,
      isSuccess: true,
    );

    when(() => mockAppointmentViewModel.state).thenReturn(loadingState);
    whenListen(mockAppointmentViewModel, Stream.value(loadingState));

    // Act
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<AppointmentViewModel>.value(
          value: mockAppointmentViewModel,
          child: const AppointmentListView(patientId: testPatientId),
        ),
      ),
    );

    // Assert
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('shows error message when error occurs',
      (WidgetTester tester) async {
    // Arrange
    final errorState = AppointmentState(
      isLoading: false,
      appointments: const [],
      errorMessage: 'Failed to fetch appointments',
      isSuccess: false,
    );

    when(() => mockAppointmentViewModel.state).thenReturn(errorState);
    whenListen(mockAppointmentViewModel, Stream.value(errorState));

    // Act
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<AppointmentViewModel>.value(
          value: mockAppointmentViewModel,
          child: const AppointmentListView(patientId: testPatientId),
        ),
      ),
    );

    // Assert
    expect(find.text('Error: Failed to fetch appointments'), findsOneWidget);
  });

  testWidgets('shows no appointments text when list is empty',
      (WidgetTester tester) async {
    // Arrange
    final emptyState = AppointmentState(
      isLoading: false,
      appointments: const [],
      errorMessage: null,
      isSuccess: false,
    );

    when(() => mockAppointmentViewModel.state).thenReturn(emptyState);
    whenListen(mockAppointmentViewModel, Stream.value(emptyState));

    // Act
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<AppointmentViewModel>.value(
          value: mockAppointmentViewModel,
          child: const AppointmentListView(patientId: testPatientId),
        ),
      ),
    );

    // Assert
    expect(find.text('No Appointments Found.'), findsOneWidget);
  });

  testWidgets('renders list of appointments', (WidgetTester tester) async {
    // Arrange
    final appointments = [
      AppointmentEntity(
        id: 'a1',
        doctorName: 'John Doe',
        date: '2025-07-30',
        time: '10:00 AM',
        type: 'Checkup',
        status: 'Confirmed',
        doctorId: '',
        patientId: '',
        specialty: '',
      ),
      AppointmentEntity(
        id: 'a2',
        doctorName: 'Jane Smith',
        date: '2025-08-01',
        time: '02:00 PM',
        type: 'Consultation',
        status: 'Pending',
        doctorId: '',
        patientId: '',
        specialty: '',
      ),
    ];

    final loadedState = AppointmentState(
      isLoading: false,
      appointments: appointments,
      errorMessage: null,
      isSuccess: true,
    );

    when(() => mockAppointmentViewModel.state).thenReturn(loadedState);
    whenListen(mockAppointmentViewModel, Stream.value(loadedState));

    // Act
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<AppointmentViewModel>.value(
          value: mockAppointmentViewModel,
          child: const AppointmentListView(patientId: testPatientId),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Assert appointment details are shown
    expect(find.text('Dr. John Doe'), findsOneWidget);
    expect(find.text('2025-07-30 at 10:00 AM'), findsOneWidget);
    expect(find.text('Type: Checkup'), findsOneWidget);
    expect(find.text('Status: Confirmed'), findsOneWidget);

    expect(find.text('Dr. Jane Smith'), findsOneWidget);
    expect(find.text('2025-08-01 at 02:00 PM'), findsOneWidget);
    expect(find.text('Type: Consultation'), findsOneWidget);
    expect(find.text('Status: Pending'), findsOneWidget);

    // Check for the "View Queue Status" buttons
    expect(find.text('View Queue Status'), findsNWidgets(2));
  });
}
