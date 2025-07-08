import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:student_management/core/error/failure.dart';
import 'package:student_management/features/batch/domain/entity/batch_entity.dart';
import 'package:student_management/features/batch/domain/use_case/create_batch_usecase.dart';

import 'repository_mock.dart';

void main() {
  late MockBatchRepository repository;
  late CreateBatchUsecase usecase;
  
  const tBatchName = 'Test Batch';
  final tBatchEntity = BatchEntity(batchName: tBatchName);
  final tParams = CreateBatchParams(batchName: tBatchName);

  setUp(() {
    repository = MockBatchRepository();
    usecase = CreateBatchUsecase(batchRepository: repository);
    registerFallbackValue(tBatchEntity);
  });

  test('should call the [BatchRepository.addBatch] with correct parameters', () async {
    // arrange
    when(() => repository.addBatch(any())).thenAnswer(
      (_) async => const Right(null),
    );

    // act
    final result = await usecase(tParams);

    // assert
    expect(result, const Right(null));
    verify(() => repository.addBatch(tBatchEntity)).called(1);
    verifyNoMoreInteractions(repository);
  });

  test('should return a Failure when repository call fails', () async {
    // arrange
    const failure = ApiFailure(message: 'Failed to create batch');
    when(() => repository.addBatch(any())).thenAnswer(
      (_) async => const Left(failure),
    );

    // act
    final result = await usecase(tParams);

    // assert
    expect(result, const Left(failure));
    verify(() => repository.addBatch(tBatchEntity)).called(1);
    verifyNoMoreInteractions(repository);
  });
}