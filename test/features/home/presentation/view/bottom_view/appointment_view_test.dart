import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:mediqueue/features/home/presentation/view/bottom_view/appointment_view.dart';
import 'package:mediqueue/features/appointment/presentation/view_model/appointment_state.dart';
import 'package:mediqueue/features/appointment/presentation/view_model/appointment_view_model.dart';
import 'package:mediqueue/features/appointment/domain/entity/appointment_entity.dart';

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
    final loadingState = AppointmentState(
      isLoading: true,
      appointments: const [],
      errorMessage: null,
      isSuccess: true,
    );

    when(() => mockAppointmentViewModel.state).thenReturn(loadingState);
    whenListen(mockAppointmentViewModel, Stream.value(loadingState));

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: BlocProvider<AppointmentViewModel>.value(
            value: mockAppointmentViewModel,
            child: const AppointmentListView(patientId: testPatientId),
          ),
        ),
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('shows error message when error occurs',
      (WidgetTester tester) async {
    final errorState = AppointmentState(
      isLoading: false,
      appointments: const [],
      errorMessage: 'Failed to fetch appointments',
      isSuccess: false,
    );

    when(() => mockAppointmentViewModel.state).thenReturn(errorState);
    whenListen(mockAppointmentViewModel, Stream.value(errorState));

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: BlocProvider<AppointmentViewModel>.value(
            value: mockAppointmentViewModel,
            child: const AppointmentListView(patientId: testPatientId),
          ),
        ),
      ),
    );

    expect(find.text('Error: Failed to fetch appointments'), findsOneWidget);
  });

  testWidgets('shows no appointments text when list is empty',
      (WidgetTester tester) async {
    final emptyState = AppointmentState(
      isLoading: false,
      appointments: const [],
      errorMessage: null,
      isSuccess: false,
    );

    when(() => mockAppointmentViewModel.state).thenReturn(emptyState);
    whenListen(mockAppointmentViewModel, Stream.value(emptyState));

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: BlocProvider<AppointmentViewModel>.value(
            value: mockAppointmentViewModel,
            child: const AppointmentListView(patientId: testPatientId),
          ),
        ),
      ),
    );

    expect(find.text('No Appointments Found.'), findsOneWidget);
  });

  testWidgets('renders list of appointments', (WidgetTester tester) async {
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

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: BlocProvider<AppointmentViewModel>.value(
            value: mockAppointmentViewModel,
            child: const AppointmentListView(patientId: testPatientId),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Dr. John Doe'), findsOneWidget);
    expect(find.text('2025-07-30 at 10:00 AM'), findsOneWidget);
    expect(find.text('Type: Checkup'), findsOneWidget);
    expect(find.text('Status: Confirmed'), findsOneWidget);

    expect(find.text('Dr. Jane Smith'), findsOneWidget);
    expect(find.text('2025-08-01 at 02:00 PM'), findsOneWidget);
    expect(find.text('Type: Consultation'), findsOneWidget);
    expect(find.text('Status: Pending'), findsOneWidget);

    expect(find.textContaining('View Queue Status'), findsNWidgets(2));

  });
}
