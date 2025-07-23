import 'package:equatable/equatable.dart';

abstract class QueueEvent extends Equatable {
  const QueueEvent();

  @override
  List<Object?> get props => [];
}

class FetchQueueStatus extends QueueEvent {
  final String patientId;

  const FetchQueueStatus(this.patientId);

  @override
  List<Object?> get props => [patientId];
}
