import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:student_management/app/shared_pref/token_shared_prefs.dart';
import 'package:student_management/app/use_case/usecase.dart';
import 'package:student_management/core/error/failure.dart';
import 'package:student_management/features/batch/domain/repository/batch_repository.dart';
import 'package:student_management/features/batch/domain/use_case/delete_batch_usecase.dart';

import 'repository_mock.dart';
import 'token_mock.dart';

class DeleteBatchUsecase implements UsecaseWithParams<void, DeleteBatchParams> {
  final IBatchRepository batchRepository;
  final TokenSharedPrefs tokenSharedPrefs;

  DeleteBatchUsecase({
    required this.batchRepository,
    required this.tokenSharedPrefs,
  });

  @override
  Future<Either<Failure, void>> call(DeleteBatchParams params) async {
    final token = await tokenSharedPrefs.getToken();
    return token.fold(
      (l) {
        return Left(l);
      },
      (r) async {
        return await batchRepository.deleteBatch(params.batchId, r);
      },
    );
  }
}

void main() {
  late DeleteBatchUsecase usecase;
  late MockBatchRepository repository;
  late MockTokenSharedPrefs tokenSharedPrefs;

  setUp(() {
    repository = MockBatchRepository();
    tokenSharedPrefs = MockTokenSharedPrefs();
    usecase = DeleteBatchUsecase(
      batchRepository: repository,
      tokenSharedPrefs: tokenSharedPrefs,
    );
  });

  final tBatchId = '1';
  final token = 'token';
  final deleteBatchParams = DeleteBatchParams(batchId: tBatchId);

  test('delete batch using id', () async {
    // arrange
    when(
      () => tokenSharedPrefs.getToken(),
    ).thenAnswer((_) async => Right(token));

    when(
      () => repository.deleteBatch(any(), any()),
    ).thenAnswer((_) async => Right(null));

    // Act
    final result = await usecase(deleteBatchParams);

    expect(result, Right(null));

    // Verify
    verify(() => tokenSharedPrefs.getToken()).called(1);
    verify(() => repository.deleteBatch(tBatchId, token)).called(1);

    verifyNoMoreInteractions(repository);

    verifyNoMoreInteractions(tokenSharedPrefs);
  });

  test('delete batch using id and check whether the id is batch1', () async {
    // Arrange
    when(
      () => tokenSharedPrefs.getToken(),
    ).thenAnswer((_) async => Right(token));

    when(() => repository.deleteBatch(any(), any())).thenAnswer((
      invocation,
    ) async {
      final batchId = invocation.positionalArguments[0] as String;

      if (batchId == 'batch1') {
        return Right(null);
      } else {
        return Left(ApiFailure(message: 'Batch not found'));
      }
    });

    final result = await usecase(DeleteBatchParams(batchId: 'batch1'));

    // Assert
    expect(result, Right(null));

    // Verify
    verify(() => tokenSharedPrefs.getToken()).called(1);
    verify(() => repository.deleteBatch('batch1', token)).called(1);

    verifyNoMoreInteractions(repository);
    verifyNoMoreInteractions(tokenSharedPrefs);
  });
}
