import 'package:dartz/dartz.dart';
import 'package:mediqueue/app/use_case/usecase.dart';
import 'package:mediqueue/core/error/failure.dart';
import 'package:mediqueue/features/queue/domain/entity/queue_entity.dart';
import 'package:mediqueue/features/queue/domain/repository/queue_repository.dart';

class GetQueueStatusUseCase implements UsecaseWithParams<QueueEntity, String> {
  final IQueueRepository _queueRepository;

  GetQueueStatusUseCase({required IQueueRepository queueRepository})
      : _queueRepository = queueRepository;

  @override
  Future<Either<Failure, QueueEntity>> call(String patientId) {
    return _queueRepository.getQueueStatus(patientId);
  }
}
