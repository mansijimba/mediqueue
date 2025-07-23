import 'package:dartz/dartz.dart';
import 'package:mediqueue/core/error/failure.dart';
import 'package:mediqueue/features/queue/data/data_source/remote_data_source/queue_remote_datasource.dart';
import 'package:mediqueue/features/queue/domain/entity/queue_entity.dart';
import 'package:mediqueue/features/queue/domain/repository/queue_repository.dart';

class QueueRemoteRepository implements IQueueRepository {
  final QueueRemoteDatasource _queueRemoteDatasource;

  QueueRemoteRepository({required QueueRemoteDatasource queueRemoteDatasource})
      : _queueRemoteDatasource = queueRemoteDatasource;

  @override
  Future<Either<Failure, QueueEntity>> getQueueStatus(String patientId) async {
    try {
      final queue = await _queueRemoteDatasource.getQueueStatus(patientId);
      return Right(queue);
    } catch (e) {
      return Left(RemoteDatabaseFailure(message: e.toString()));
    }
  }
}
