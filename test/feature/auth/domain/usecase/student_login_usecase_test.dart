import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:student_management/core/error/failure.dart';
import 'package:student_management/features/auth/domain/use_case/student_login_usecase.dart';
import '../../../batch/domain/usecase/token_mock.dart';
import 'auth_repo.mock.dart';

void main() {
  late AuthRepoMock repository;
  late MockTokenSharedPrefs tokenSharedPrefs;
  late StudentLoginUsecase usecase;

  setUp(() {
    repository = AuthRepoMock();
    tokenSharedPrefs = MockTokenSharedPrefs();
    usecase = StudentLoginUsecase(
      studentRepository: repository,
      tokenSharedPrefs: tokenSharedPrefs,
    );
  });

  test(
    'should call the [AuthRepo.loginStudent] with correct parameters',
    () async {
      when(() => repository.loginStudent(any(), any())).thenAnswer((
        invocation,
      ) async {
        final username = invocation.positionalArguments[0] as String;
        final password = invocation.positionalArguments[1] as String;
        if (username == 'kiran' && password == 'kiran123') {
          return Future.value(const Right('token'));
        }
        return Future.value(
          const Left(ApiFailure(message: 'Invalid credentials')),
        );
      });

      when(
        () => tokenSharedPrefs.saveToken(any()),
      ).thenAnswer((_) async => const Right(null));

      // act
      final result = await usecase(
        LoginParams(username: 'kiran', password: 'kiran123'),
      );

      // assert
      expect(result, const Right('token'));

      verify(() => repository.loginStudent('kiran', 'kiran123')).called(1);
      verify(() => tokenSharedPrefs.saveToken('token')).called(1);
      verifyNoMoreInteractions(repository);
      verifyNoMoreInteractions(tokenSharedPrefs);
    },
  );

  tearDown(() {
    reset(repository);
    reset(tokenSharedPrefs);
  });
}
