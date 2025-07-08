import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:student_management/features/auth/presentation/view/register_view.dart';
import 'package:student_management/features/auth/presentation/view_model/register_view_model/register_event.dart';
import 'package:student_management/features/auth/presentation/view_model/register_view_model/register_state.dart';
import 'package:student_management/features/auth/presentation/view_model/register_view_model/register_view_model.dart';
import 'package:student_management/features/batch/domain/entity/batch_entity.dart';
import 'package:student_management/features/batch/presentation/view_model/batch_event.dart';
import 'package:student_management/features/batch/presentation/view_model/batch_state.dart';
import 'package:student_management/features/batch/presentation/view_model/batch_view_model.dart';
import 'package:student_management/features/course/presentation/view_model/course_event.dart';
import 'package:student_management/features/course/presentation/view_model/course_state.dart';
import 'package:student_management/features/course/presentation/view_model/course_view_model.dart';

import 'test_data/batch_test_data.dart';
import 'test_data/course_test_data.dart';

class MockBatchBloc extends MockBloc<BatchEvent, BatchState>
    implements BatchViewModel {}

class MockCourseBloc extends MockBloc<CourseEvent, CourseState>
    implements CourseViewModel {}

class MockRegisterBloc extends MockBloc<RegisterEvent, RegisterState>
    implements RegisterViewModel {}

void main() {
  late MockBatchBloc batchBloc;
  late MockCourseBloc courseBloc;
  late MockRegisterBloc registerBloc;

  setUp(() {
    batchBloc = MockBatchBloc();
    courseBloc = MockCourseBloc();
    registerBloc = MockRegisterBloc();
  });

  Widget loadRegisterView(Widget body) {
    when(() => batchBloc.state).thenReturn(
      BatchState(
        batches: BatchTestData.getBatchTestData(),
        isLoading: false,
        errorMessage: '',
      ),
    );

    when(() => courseBloc.state).thenReturn(
      CourseState(
        courses: CourseTestData.getCourseTestData(),
        isLoading: false,
        errorMessage: '',
      ),
    );

    return MaterialApp(
      home: MultiBlocProvider(
        providers: [
          BlocProvider<BatchViewModel>.value(value: batchBloc),
          BlocProvider<CourseViewModel>.value(value: courseBloc),
          BlocProvider<RegisterViewModel>.value(value: registerBloc),
        ],
        child: RegisterView(),
      ),
    );
  }

  testWidgets('check for title text Register Student', (WidgetTester tester) async {
    await tester.pumpWidget(loadRegisterView(RegisterView()));

    await tester.pumpAndSettle();

    final result = find.text('Register Student');

    expect(result, findsOneWidget);
  });

  testWidgets('Load dropdown value and select second index data', (WidgetTester tester) async {
    await tester.pumpWidget(loadRegisterView(RegisterView()));

    await tester.pumpAndSettle();

    final dropdownFinder = find.byType(DropdownButtonFormField<BatchEntity>);
    await tester.ensureVisible(dropdownFinder);
    
    await tester.tap(dropdownFinder);

    await tester.pumpAndSettle();

    await tester.tap(find.byType(DropdownMenuItem<BatchEntity>).at(1));

    await tester.pumpAndSettle();

    final result = find.text('Batch 2');

    expect(result, findsOneWidget);
  });
}
