import 'package:equatable/equatable.dart';
import 'package:mediqueue/features/queue/domain/entity/queue_entity.dart';

class QueueState extends Equatable {
  final bool isLoading;
  final bool isSuccess;
  final String? errorMessage;
  final QueueEntity? queueStatus;

  const QueueState({
    required this.isLoading,
    required this.isSuccess,
    this.errorMessage,
    this.queueStatus,
  });

  factory QueueState.initial() {
    return const QueueState(
      isLoading: false,
      isSuccess: false,
      errorMessage: null,
      queueStatus: null,
    );
  }

  QueueState copyWith({
    bool? isLoading,
    bool? isSuccess,
    String? errorMessage,
    QueueEntity? queueStatus,
  }) {
    return QueueState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      errorMessage: errorMessage,
      queueStatus: queueStatus ?? this.queueStatus,
    );
  }

  @override
  List<Object?> get props => [isLoading, isSuccess, errorMessage, queueStatus];
}
