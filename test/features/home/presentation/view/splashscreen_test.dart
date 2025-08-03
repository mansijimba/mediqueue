import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mediqueue/features/home/presentation/view/splashscreen.dart';


void main() {
testWidgets('SplashScreen shows logo, text and progress indicator', (tester) async {
  await tester.pumpWidget(
    MaterialApp(
      home: const SplashScreen(),
      routes: {
        '/login': (context) => const Scaffold(body: Text('Login Page')),
      },
    ),
  );
  
  // Verify logo image exists
  expect(find.byType(Image), findsNWidgets(2)); // splash.jpg + logo.png

  // Verify title and subtitle text
  expect(find.text('MediQueue'), findsOneWidget);
  expect(find.text('– Skip the Line, Save Time'), findsOneWidget);

  // Verify CircularProgressIndicator exists
  expect(find.byType(CircularProgressIndicator), findsOneWidget);

  // Pump 4 seconds to let timer complete and navigation happen
  await tester.pump(const Duration(seconds: 4));
  await tester.pumpAndSettle();

  // After navigation, SplashScreen is gone, Login Page is visible
  expect(find.text('Login Page'), findsOneWidget);
  expect(find.text('MediQueue'), findsNothing);
});


  testWidgets('SplashScreen navigates to /login after 4 seconds', (tester) async {
    final navigatorKey = GlobalKey<NavigatorState>();

    await tester.pumpWidget(
      MaterialApp(
        navigatorKey: navigatorKey,
        routes: {
          '/': (context) => const SplashScreen(),
          '/login': (context) => const Scaffold(body: Text('Login Page')),
        },
      ),
    );

    // Initial state, splash screen visible
    expect(find.text('MediQueue'), findsOneWidget);
    expect(find.text('Login Page'), findsNothing);

    // Wait 4 seconds + a bit more for Navigator.pushReplacementNamed to trigger
    await tester.pump(const Duration(seconds: 4));
    await tester.pumpAndSettle();

    // Now it should navigate to /login
    expect(find.text('Login Page'), findsOneWidget);
    expect(find.text('MediQueue'), findsNothing);
  });
}
