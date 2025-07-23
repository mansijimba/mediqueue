import 'package:mediqueue/features/queue/domain/entity/queue_entity.dart';

abstract interface class IQueueDataSource {
  Future<QueueEntity> getQueueStatus(String patientId);
}
