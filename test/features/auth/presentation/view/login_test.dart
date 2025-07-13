import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mediqueue/features/auth/presentation/View/login.dart';
import 'package:mediqueue/features/auth/presentation/view_model/login_view_model.dart/login_event.dart';
import 'package:mediqueue/features/auth/presentation/view_model/login_view_model.dart/login_state.dart';
import 'package:mediqueue/features/auth/presentation/view_model/login_view_model.dart/login_view_model.dart';
import 'package:mocktail/mocktail.dart';


class MockLoginBloc extends MockBloc<LoginEvent, LoginState>
    implements LoginViewModel {}

void main() {
  late MockLoginBloc loginBloc;

  setUp(() {
    loginBloc = MockLoginBloc();
  });

  Widget loadLoginView() {
    return BlocProvider<LoginViewModel>(
      create: (context) => loginBloc,
      child: MaterialApp(home: LoginPage()),
    );
  }

  testWidgets('check for the text in login ui', (tester) async {
    await tester.pumpWidget(loadLoginView());

    await tester.pumpAndSettle();

    // find button by text
    final result = find.widgetWithText(ElevatedButton, 'Sign In');

    expect(result, findsOneWidget);
  });

  // Check for the validator error
  testWidgets('Check for the email and password', (tester) async {
    await tester.pumpWidget(loadLoginView());

    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField).at(0), 'pompom@gmail.com');
    await tester.enterText(find.byType(TextField).at(1), 'pompom');

    await tester.tap(find.byType(ElevatedButton).first);

    await tester.pumpAndSettle();

    expect(find.text('pompom@gmail.com'), findsOneWidget);
    expect(find.text('pompom'), findsOneWidget);
  });

  // testWidgets('Check for the validator error', (tester) async {
  //   await tester.pumpWidget(loadLoginView());

  //   await tester.pumpAndSettle();

  //   // await tester.enterText(find.byType(TextField).at(0), '');
  //   // await tester.enterText(find.byType(TextField).at(1), '');

  //   await tester.tap(find.byType(ElevatedButton).first);

  //   await tester.pumpAndSettle();

  //   expect(find.text('Please enter username'), findsOneWidget);
  //   expect(find.text('Please enter password'), findsOneWidget);
  // });

  // Should show progress indicator when loading
  testWidgets('Login success', (tester) async {
    when(
      () => loginBloc.state,
    ).thenReturn(LoginState(isLoading: true, isSuccess: true));

    await tester.pumpWidget(loadLoginView());

    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).at(0), 'pompom@gmail.com');
    await tester.enterText(find.byType(TextField).at(1), 'pompom');

    await tester.tap(find.byType(ElevatedButton).first);

    await tester.pumpAndSettle();

    expect(loginBloc.state.isSuccess, true);
  });
}

class LoginView {
}