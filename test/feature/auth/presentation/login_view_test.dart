import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:student_management/features/auth/presentation/view/login_view.dart';
import 'package:student_management/features/auth/presentation/view_model/login_view_model/login_event.dart';
import 'package:student_management/features/auth/presentation/view_model/login_view_model/login_state.dart';
import 'package:student_management/features/auth/presentation/view_model/login_view_model/login_view_model.dart';

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
      child: MaterialApp(home: LoginView()),
    );
  }

  testWidgets('should display the text Login', (WidgetTester tester) async {
    await tester.pumpWidget(loadLoginView());

    await tester.pumpAndSettle();

    final result = find.widgetWithText(ElevatedButton, 'Login');

    expect(result, findsOneWidget);
  });

  testWidgets('Check for the username and password', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(loadLoginView());

    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField).at(0), 'kiran');
    await tester.enterText(find.byType(TextField).at(1), 'kiran123');

    await tester.tap(find.byType(ElevatedButton).first);

    await tester.pumpAndSettle();

    expect(find.text('kiran'), findsOneWidget);
    expect(find.text('kiran123'), findsOneWidget);
  });

  testWidgets('Check for validation error', (WidgetTester tester) async {
    await tester.pumpWidget(loadLoginView());

    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField).at(0), '');
    await tester.enterText(find.byType(TextField).at(1), '');

    await tester.tap(find.byType(ElevatedButton).first);

    await tester.pumpAndSettle();

    expect(find.text('Please enter username'), findsOneWidget);
    expect(find.text('Please enter password'), findsOneWidget);
  });

  testWidgets('Login success', (WidgetTester tester) async {
    when(
      () => loginBloc.state,
    ).thenReturn(LoginState(isLoading: true, isSuccess: true));

    await tester.pumpWidget(loadLoginView());

    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField).at(0), 'kiran');
    await tester.enterText(find.byType(TextField).at(1), 'kiran123');

    await tester.tap(find.byType(ElevatedButton).first);

    await tester.pumpAndSettle();

    expect(loginBloc.state.isSuccess, true);
  });

  testWidgets('Login failure', (WidgetTester tester) async {
    when(
      () => loginBloc.state,
    ).thenReturn(LoginState(isLoading: true, isSuccess: false));

    await tester.pumpWidget(loadLoginView());

    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField).at(0), 'kiran');
    await tester.enterText(find.byType(TextField).at(1), 'kiran123');

    await tester.tap(find.byType(ElevatedButton).first);

    await tester.pumpAndSettle();

    expect(loginBloc.state.isSuccess, false);
  });
}
