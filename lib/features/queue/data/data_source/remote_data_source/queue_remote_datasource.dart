import 'package:dio/dio.dart';
import 'package:mediqueue/app/constant/api_endpoints.dart';
import 'package:mediqueue/core/network/api_service.dart';
import 'package:mediqueue/features/queue/data/data_source/queue_datasource.dart';
import 'package:mediqueue/features/queue/data/model/queue_api_model.dart';
import 'package:mediqueue/features/queue/domain/entity/queue_entity.dart';

class QueueRemoteDatasource implements IQueueDataSource {
  final ApiService _apiService;
  final String? token;

  QueueRemoteDatasource({
    required ApiService apiService,
    this.token,
  }) : _apiService = apiService;

  @override
  Future<QueueEntity> getQueueStatus(String patientId) async {
    try {
      final response = await _apiService.dio.get(
        ApiEndpoints.baseUrl + ApiEndpoints.getQueueStatus,
        queryParameters: {'patientId': patientId},
        options: Options(
          headers: token != null ? {'Authorization': 'Bearer $token'} : null,
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        return QueueApiModel.fromJson(response.data).toEntity();
      } else {
        throw Exception(response.statusMessage ?? 'Failed to fetch queue status');
      }
    } on DioException catch (e) {
      throw Exception('Dio Error: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected Error: $e');
    }
  }
}
