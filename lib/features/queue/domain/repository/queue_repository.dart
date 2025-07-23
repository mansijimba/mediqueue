import 'package:dartz/dartz.dart';
import 'package:mediqueue/core/error/failure.dart';
import 'package:mediqueue/features/queue/domain/entity/queue_entity.dart';

abstract interface class IQueueRepository {
  Future<Either<Failure, QueueEntity>> getQueueStatus(String patientId);
}
