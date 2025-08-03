import 'package:dio/dio.dart';
import 'package:mediqueue/app/constant/api_endpoints.dart';
import 'package:mediqueue/core/network/api_service.dart';
import 'package:mediqueue/features/appointment/data/data_source/appointment_data_source.dart';
import 'package:mediqueue/features/appointment/data/model/appointment_api_model.dart';
import 'package:mediqueue/features/appointment/domain/entity/appointment_entity.dart';

class AppointmentRemoteDataSource implements IAppointmentDataSource {
  final ApiService _apiService;

  AppointmentRemoteDataSource({required ApiService apiService})
    : _apiService = apiService;

  @override
  Future<AppointmentEntity> bookAppointment({
    required String doctorId,
    required String patientId,
    required String specialty,
    required String date,
    required String time,
    required String type,
  }) async {
    try {
      final response = await _apiService.dio.post(
        ApiEndpoints.baseUrl + ApiEndpoints.bookAppointment,
        data: {
          'doctorId': doctorId,
          'patientId': patientId,
          'specialty': specialty,
          'date': date,
          'time': time,
          'type': type,
        },
      );

      if (response.statusCode == 201) {
        final appointmentData = response.data['appointment'];

        if (appointmentData is Map<String, dynamic>) {
          return AppointmentApiModel.fromJson(appointmentData).toEntity();
        } else {
          throw Exception(
            // 'Unexpected format: appointment data is not a map. Got: $appointmentData',
          );
        }
      } else {
        throw Exception(response.statusMessage ?? 'Failed to book appointment');
      }
      // } on DioException catch (e) {
      //   throw Exception('Dio Error: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected Error: $e');
    }
  }

  @override
  Future<List<AppointmentEntity>> getAppointmentsByPatientId(
    String patientId,
  ) async {
    try {
      final response = await _apiService.dio.get(
        ApiEndpoints.baseUrl + ApiEndpoints.getAppointments,
        queryParameters: {'patientId': patientId},
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = response.data['appointments'];
        return jsonList
            .map((json) => AppointmentApiModel.fromJson(json).toEntity())
            .toList();
      } else {
        throw Exception(
          response.statusMessage ?? 'Failed to fetch appointments',
        );
      }
    } on DioException catch (e) {
      throw Exception('Dio Error: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected Error: $e');
    }
  }

  @override
  Future<bool> cancelAppointment(String appointmentId) async {
    try {
      final response = await _apiService.dio.post(
        '${ApiEndpoints.baseUrl}${ApiEndpoints.cancelAppointment}$appointmentId/cancel',
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception(
          response.statusMessage ?? 'Failed to cancel appointment',
        );
      }
    } on DioException catch (e) {
      throw Exception('Dio Error: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected Error: $e');
    }
  }
}
