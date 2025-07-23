import 'package:dio/dio.dart';
import 'package:mediqueue/app/constant/api_endpoints.dart';
import 'package:mediqueue/core/network/api_service.dart';
import 'package:mediqueue/features/doctor/data/datasource/doctor_data_source.dart';
import 'package:mediqueue/features/doctor/data/model/doctor_api_model.dart';
import 'package:mediqueue/features/doctor/domain/entity/doctor_entity.dart';

class DoctorRemoteDataSource implements IDoctorDataSource {
  final ApiService _apiService;

  DoctorRemoteDataSource({required ApiService apiService}) : _apiService = apiService;

  @override
  Future<List<DoctorEntity>> getAllDoctors() async {
    try {
      final response = await _apiService.dio.get(
        ApiEndpoints.baseUrl + ApiEndpoints.getAllDoctor,
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = response.data['data'];
        return jsonList
            .map((json) => DoctorApiModel.fromJson(json).toEntity())
            .toList();
      } else {
        throw Exception(response.statusMessage ?? 'Failed to fetch doctors');
      }
    } on DioException catch (e) {
      throw Exception('Dio Error: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected Error: $e');
    }
  }

  @override
  Future<DoctorEntity> getDoctorById(String doctorId) async {
    try {
      final response = await _apiService.dio.get(
        ApiEndpoints.baseUrl + ApiEndpoints.getDoctorById + doctorId,
      );

      if (response.statusCode == 200) {
        return DoctorApiModel.fromJson(response.data['data']).toEntity();
      } else {
        throw Exception(response.statusMessage ?? 'Failed to fetch doctor by ID');
      }
    } on DioException catch (e) {
      throw Exception('Dio Error: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected Error: $e');
    }
  }
}
