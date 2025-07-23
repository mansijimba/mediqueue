import 'package:equatable/equatable.dart';

class QueueEntity extends Equatable {
  final String status;
  final int position;
  final int totalAhead;
  final int estimatedWait;

  const QueueEntity({
    required this.status,
    required this.position,
    required this.totalAhead,
    required this.estimatedWait,
  });

  @override
  List<Object?> get props => [status, position, totalAhead, estimatedWait];
}
