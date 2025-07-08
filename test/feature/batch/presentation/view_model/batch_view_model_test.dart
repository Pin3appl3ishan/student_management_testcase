import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:student_management/core/error/failure.dart';
import 'package:student_management/features/batch/domain/entity/batch_entity.dart';
import 'package:student_management/features/batch/domain/use_case/create_batch_usecase.dart';
import 'package:student_management/features/batch/domain/use_case/delete_batch_usecase.dart';
import 'package:student_management/features/batch/domain/use_case/get_all_batch_usecase.dart';
import 'package:student_management/features/batch/presentation/view_model/batch_event.dart';
import 'package:student_management/features/batch/presentation/view_model/batch_state.dart';
import 'package:student_management/features/batch/presentation/view_model/batch_view_model.dart';

class MockGetAllBatchUsecase extends Mock implements GetAllBatchUsecase {}

class MockCreateBatchUsecase extends Mock implements CreateBatchUsecase {}

class MockDeleteBatchUsecase extends Mock implements DeleteBatchUsecase {}

void main() {
  late MockGetAllBatchUsecase mockGetAllBatchUsecase;
  late MockCreateBatchUsecase mockCreateBatchUsecase;
  late MockDeleteBatchUsecase mockDeleteBatchUsecase;

  final batch1 = BatchEntity(batchId: '1', batchName: 'Batch 1');
  final batch2 = BatchEntity(batchId: '2', batchName: 'Batch 2');
  final batchList = [batch1, batch2];
  const batchName = 'Batch 1';
  const batchId = '1';
  const errorMessage = 'Server Failure';

  setUp(() {
    mockGetAllBatchUsecase = MockGetAllBatchUsecase();
    mockCreateBatchUsecase = MockCreateBatchUsecase();
    mockDeleteBatchUsecase = MockDeleteBatchUsecase();
  });

  BatchViewModel batchBloc() {
    return BatchViewModel(
      getAllBatchUsecase: mockGetAllBatchUsecase,
      createBatchUsecase: mockCreateBatchUsecase,
      deleteBatchUsecase: mockDeleteBatchUsecase,
    );
  }

  group('LoadBatches', () {
    blocTest<BatchViewModel, BatchState>(
      'emits [loading] when LoadBatchesEvent is added',
      build: batchBloc,
      act: (bloc) => bloc.add(LoadBatchesEvent()),
      expect: () => [
        const BatchState(batches: [], isLoading: true, errorMessage: null),
      ],
    );

    blocTest<BatchViewModel, BatchState>(
      'emits [loading, loaded] when LoadBatchesEvent is added and data is fetched successfully',
      build: () {
        when(
          () => mockGetAllBatchUsecase(),
        ).thenAnswer((_) async => Right(batchList));
        return batchBloc();
      },
      act: (bloc) => bloc.add(LoadBatchesEvent()),
      expect: () => [
        const BatchState(batches: [], isLoading: true, errorMessage: null),
        BatchState(batches: batchList, isLoading: false, errorMessage: null),
      ],
    );
    blocTest<BatchViewModel, BatchState>(
      'emits [BatchState] with loaded batches when LoadBatches is added with skip 1 ',
      build: () {
        when(
          () => mockGetAllBatchUsecase(),
        ).thenAnswer((_) async => Right(batchList));
        return batchBloc();
      },
      act: (bloc) => bloc.add(LoadBatchesEvent()),
      skip: 1,
      expect: () => [
        BatchState.initial().copyWith(batches: batchList, isLoading: false, errorMessage: null),
      ],
      verify: (_) {
        verify(() => mockGetAllBatchUsecase()).called(1);
      },
    );



    blocTest<BatchViewModel, BatchState>(
      'emits [loading, error] when LoadBatchesEvent is added and data fetch fails',
      build: () {
        when(() => mockGetAllBatchUsecase()).thenAnswer(
          (_) async => const Left(ApiFailure(message: errorMessage)),
        );
        return batchBloc();
      },
      act: (bloc) => bloc.add(LoadBatchesEvent()),
      expect: () => [
        const BatchState(batches: [], isLoading: true, errorMessage: null),
        const BatchState(
          batches: [],
          isLoading: false,
          errorMessage: errorMessage,
        ),
      ],
      verify: (_) {
        verify(() => mockGetAllBatchUsecase()).called(1);
      },
    );
  });

  group('CreateBatch', () {
    blocTest<BatchViewModel, BatchState>(
      'calls createBatchUsecase with correct parameters',
      build: () {
        when(
          () => mockCreateBatchUsecase(any()),
        ).thenAnswer((_) async => const Right(null));
        when(
          () => mockGetAllBatchUsecase(),
        ).thenAnswer((_) async => Right(batchList));
        return batchBloc();
      },
      act: (bloc) => bloc.add(CreateBatchEvent(batchName: batchName)),
      verify: (_) {
        verify(
          () => mockCreateBatchUsecase(
            const CreateBatchParams(batchName: batchName),
          ),
        ).called(1);
      },
    );

    blocTest<BatchViewModel, BatchState>(
      'emits [loading, success] when CreateBatchEvent is added and batch is created successfully',
      build: () {
        when(
          () => mockCreateBatchUsecase(any()),
        ).thenAnswer((_) async => const Right(null));
        when(
          () => mockGetAllBatchUsecase(),
        ).thenAnswer((_) async => Right(batchList));
        return batchBloc();
      },
      act: (bloc) => bloc.add(CreateBatchEvent(batchName: batchName)),
      expect: () => [
        const BatchState(batches: [], isLoading: true, errorMessage: null),
        const BatchState(batches: [], isLoading: false, errorMessage: null),
        BatchState(batches: batchList, isLoading: false, errorMessage: null),
      ],
      verify: (_) {
        verify(() => mockCreateBatchUsecase(any())).called(1);
      },
    );
  });

  group('DeleteBatch', () {
    blocTest<BatchViewModel, BatchState>(
      'calls deleteBatchUsecase with correct parameters',
      build: () {
        when(
          () => mockDeleteBatchUsecase(any()),
        ).thenAnswer((_) async => const Right(null));
        when(
          () => mockGetAllBatchUsecase(),
        ).thenAnswer((_) async => Right(batchList));
        return batchBloc();
      },
      act: (bloc) => bloc.add(DeleteBatchEvent(batchId: batchId)),
      verify: (_) {
        verify(
          () =>
              mockDeleteBatchUsecase(const DeleteBatchParams(batchId: batchId)),
        ).called(1);
      },
    );

    blocTest<BatchViewModel, BatchState>(
      'emits [loading, success] when DeleteBatchEvent is added and batch is deleted successfully',
      build: () {
        when(
          () => mockDeleteBatchUsecase(any()),
        ).thenAnswer((_) async => const Right(null));
        when(
          () => mockGetAllBatchUsecase(),
        ).thenAnswer((_) async => Right(batchList));
        return batchBloc();
      },
      act: (bloc) => bloc.add(DeleteBatchEvent(batchId: batchId)),
      expect: () => [
        const BatchState(batches: [], isLoading: true, errorMessage: null),
        const BatchState(batches: [], isLoading: false, errorMessage: null),
        BatchState(batches: batchList, isLoading: false, errorMessage: null),
      ],
      verify: (_) {
        verify(() => mockDeleteBatchUsecase(any())).called(1);
      },
    );
  });
}
