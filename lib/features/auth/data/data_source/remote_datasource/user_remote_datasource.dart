import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:mediqueue/app/constant/api_endpoints.dart';
import 'package:mediqueue/app/shared_pref/token_shared_prefs.dart';
import 'package:mediqueue/core/network/api_service.dart';
import 'package:mediqueue/features/auth/data/data_source/user_data_source.dart';
import 'package:mediqueue/features/auth/data/model/user_api_model.dart';
import 'package:mediqueue/features/auth/domain/entity/user_entity.dart';
import 'package:dartz/dartz.dart';

class UserRemoteDatasource implements IUserDataSource {
  final ApiService _apiService;

  UserRemoteDatasource({required ApiService apiService})
    : _apiService = apiService;

  @override
  Future<String> loginUser(String email, String password) async {
    try {
      final response = await _apiService.dio.post(
        ApiEndpoints.baseUrl + ApiEndpoints.login, // adjust endpoint as needed
        data: {'email': email, 'password': password},
      );

      if (response.statusCode == 200) {
        // Assuming token is in response.data['token']
        final token = response.data['token'] as String?;
        if (token == null || token.isEmpty) {
          throw Exception('Token not found in response');
        }
        return token;
      } else {
        throw Exception(response.statusMessage ?? 'Login failed');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  @override
  Future<void> registerUser(UserEntity userData) async {
    try {
      final response = await _apiService.dio.post(
        ApiEndpoints.baseUrl + ApiEndpoints.register, // adjust endpoint
        data: userData.toJson(), // Make sure UserEntity has toJson()
      );

      if (response.statusCode != 201) {
        // or your API's success status
        throw Exception(response.statusMessage ?? 'Registration failed');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  @override
  Future<UserEntity> getCurrentUser() async {
    try {
      final tokenSharedPrefs = GetIt.instance<TokenSharedPrefs>();
      final tokenResult = await tokenSharedPrefs.getToken();

      return await tokenResult.fold(
        (failure) => throw Exception('Failed to get token: ${failure.message}'),
        (token) async {
          final response = await _apiService.dio.get(
            ApiEndpoints.baseUrl + ApiEndpoints.getCurrentUser,
            options: Options(headers: {'Authorization': 'Bearer $token'}),
          );

          if (response.statusCode == 200) {
            final data = response.data; // <-- Use whole data object here
            if (data == null) {
              throw Exception('User data not found in response');
            }
            return UserApiModel.fromJson(data).toEntity();
          } else {
            throw Exception(
              response.statusMessage ?? 'Failed to fetch current user',
            );
          }
        },
      );
    } on DioException catch (e) {
      throw Exception('Dio Error: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected Error: $e');
    }
  }
}
