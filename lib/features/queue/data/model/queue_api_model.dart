import 'package:json_annotation/json_annotation.dart';
import 'package:mediqueue/features/queue/domain/entity/queue_entity.dart';

part 'queue_api_model.g.dart';

@JsonSerializable()
class QueueApiModel {
  final String status;
  final int position;
  final int totalAhead;
  final int estimatedWait;

  QueueApiModel({
    required this.status,
    required this.position,
    required this.totalAhead,
    required this.estimatedWait,
  });

  factory QueueApiModel.fromJson(Map<String, dynamic> json) =>
      _$QueueApiModelFromJson(json);

  Map<String, dynamic> toJson() => _$QueueApiModelToJson(this);

   QueueEntity toEntity() {
    return QueueEntity(
      status: status,
      position: position,
      totalAhead: totalAhead,
      estimatedWait: estimatedWait,
    );
  }
}
