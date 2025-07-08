import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:student_management/app/use_case/usecase.dart';
import 'package:student_management/core/error/failure.dart';
import 'package:student_management/features/batch/domain/entity/batch_entity.dart';
import 'package:student_management/features/batch/domain/repository/batch_repository.dart';

import 'repository_mock.dart';

class GetallBatchUsecase implements UsecaseWithoutParams<List<BatchEntity>> {
  final IBatchRepository batchRepository;

  GetallBatchUsecase({required this.batchRepository});

  @override
  Future<Either<Failure, List<BatchEntity>>> call() {
    return batchRepository.getBatches();
  }
}

void main() {
  late MockBatchRepository repository;
  late GetallBatchUsecase usecase;

  setUp(() {
    repository = MockBatchRepository();
    usecase = GetallBatchUsecase(batchRepository: repository);
  });

  final tBatch1 = BatchEntity(batchName: 'Test Batch 1', batchId: '1');
  final tBatch2 = BatchEntity(batchName: 'Test Batch 2', batchId: '2');

  final tBatches = [tBatch1, tBatch2];

  test('should get batches from repository', () async {
    when(
      () => repository.getBatches(),
    ).thenAnswer((_) async => Right(tBatches));

    // act
    final result = await usecase();

    // Asssert
    expect(result, Right(tBatches));

    // Verify
    verify(() => repository.addBatch(any())).called(1);
  });
}
