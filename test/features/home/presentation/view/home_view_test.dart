// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:mediqueue/features/home/presentation/view/home_view.dart';
// import 'package:mediqueue/features/home/presentation/view_model/home_state.dart';
// import 'package:mediqueue/features/home/presentation/view_model/home_view_model.dart';
// import 'package:mocktail/mocktail.dart';

// // Fake classes for fallback registration
// class FakeHomeState extends Fake implements HomeState {}
// class FakeBuildContext extends Fake implements BuildContext {}

// // Mock HomeViewModel
// class MockHomeViewModel extends Mock implements HomeViewModel {}

// void main() {
//   late MockHomeViewModel mockHomeViewModel;

//   setUpAll(() {
//     // Register fallback values only once
//     registerFallbackValue(FakeHomeState());
//     registerFallbackValue(FakeBuildContext());
//   });

//   setUp(() {
//     mockHomeViewModel = MockHomeViewModel();
//   });

//   testWidgets('renders DashboardScreen with bottom navigation and initial view',
//       (WidgetTester tester) async {
//     when(() => mockHomeViewModel.state).thenReturn(HomeState.initial());

//     await tester.pumpWidget(
//       MaterialApp(
//         home: BlocProvider<HomeViewModel>.value(
//           value: mockHomeViewModel,
//           child: const DashboardScreen(patientId: 'patient123'),
//         ),
//       ),
//     );

//     expect(find.byType(BottomNavigationBar), findsOneWidget);
//     expect(find.text('Home'), findsOneWidget);
//     expect(find.text('Appointments'), findsOneWidget);
//     expect(find.text('Profile'), findsOneWidget);

//     final bottomNavBar = tester.widget<BottomNavigationBar>(find.byType(BottomNavigationBar));
//     expect(bottomNavBar.currentIndex, 0);
//   });

//   testWidgets('tapping bottom navigation item calls onTabTapped',
//       (WidgetTester tester) async {
//     when(() => mockHomeViewModel.state).thenReturn(HomeState.initial());
//     when(() => mockHomeViewModel.onTabTapped(any())).thenReturn(null);

//     await tester.pumpWidget(
//       MaterialApp(
//         home: BlocProvider<HomeViewModel>.value(
//           value: mockHomeViewModel,
//           child: const DashboardScreen(patientId: 'patient123'),
//         ),
//       ),
//     );

//     await tester.tap(find.text('Appointments'));
//     await tester.pumpAndSettle();

//     verify(() => mockHomeViewModel.onTabTapped(1)).called(1);
//   });
// }
