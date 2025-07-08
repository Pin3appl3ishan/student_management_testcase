import 'package:student_management/features/batch/domain/entity/batch_entity.dart';

class BatchTestData {
  BatchTestData._();

  static List<BatchEntity> getBatchTestData() {
    List<BatchEntity> lstBatches = [
      BatchEntity(batchId: '20fjjdaajdijklf', batchName: 'Batch 1'),
      BatchEntity(batchId: '378dhf-fh89df-jfh45', batchName: 'Batch 2'),
      BatchEntity(batchId: 'rt5vg7-fh89df-jfh45', batchName: 'Batch 3'),
      BatchEntity(batchId: '5fdc5-fh89df-jfh45', batchName: 'Batch 4'),
      BatchEntity(batchId: '09juf-fh89df-jfh45', batchName: 'Batch 5'),
    ];
    return lstBatches;
  }
}
