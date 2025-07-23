import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:mediqueue/app/shared_pref/token_shared_prefs.dart';
import 'package:mediqueue/core/network/api_service.dart';
import 'package:mediqueue/core/network/hive_service.dart';
import 'package:mediqueue/features/appointment/data/data_source/remote_datasource/appointment_remote_data_source.dart';
import 'package:mediqueue/features/appointment/data/repository/remote_repository/appointment_remote_repository.dart';
import 'package:mediqueue/features/appointment/domain/use_case/appointment_cancel.usecase.dart';
import 'package:mediqueue/features/appointment/domain/use_case/appointment_get_by_patient_id_usecase.dart';
import 'package:mediqueue/features/appointment/domain/use_case/book_appointment_usecase.dart';
import 'package:mediqueue/features/appointment/presentation/view_model/appointment_view_model.dart';
import 'package:mediqueue/features/auth/data/data_source/local_datasource/user_local_datasource.dart';
import 'package:mediqueue/features/auth/data/data_source/remote_datasource/user_remote_datasource.dart';
import 'package:mediqueue/features/auth/data/repository/local_repository/user_local_repository.dart';
import 'package:mediqueue/features/auth/data/repository/remote_repository/user_remote_repository.dart';
import 'package:mediqueue/features/auth/domain/use_case/user_get_current_usecase.dart';
import 'package:mediqueue/features/auth/domain/use_case/user_login_usecase.dart';
import 'package:mediqueue/features/auth/domain/use_case/user_register_usecase.dart';
import 'package:mediqueue/features/auth/presentation/view_model/login_view_model.dart/login_view_model.dart';
import 'package:mediqueue/features/auth/presentation/view_model/register_view_model.dart/register_view_model.dart';
import 'package:mediqueue/features/doctor/data/datasource/local_datasource/doctor_local_data_source.dart';
import 'package:mediqueue/features/doctor/data/datasource/remote_datasource/doctor_remote_data_source.dart';
import 'package:mediqueue/features/doctor/data/repository/local_repository/doctor_local_repository.dart';
import 'package:mediqueue/features/doctor/data/repository/remote_repository/doctor_remote_repository.dart';
import 'package:mediqueue/features/doctor/domain/usecase/doctor_get_all_usecase.dart';
import 'package:mediqueue/features/doctor/domain/usecase/doctor_get_byId_usecase.dart';
import 'package:mediqueue/features/doctor/presentation/view_model/doctor_view_model.dart';
import 'package:mediqueue/features/queue/data/data_source/remote_data_source/queue_remote_datasource.dart';
import 'package:mediqueue/features/queue/data/repository/remote_repository/queue_remote_repository.dart';
import 'package:mediqueue/features/queue/domain/use_case/get_queue_status_usecase.dart';
import 'package:mediqueue/features/queue/presentation/view_model/queue_view_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  await _initHiveService();
  await _initSharedPreferences();
  await initApiModule();
  await _initAuthModule();
  await _initDoctorModule();
  await _initAppointmentModule();
  await _initQueueModule();
}

Future<void> _initHiveService() async {
  serviceLocator.registerLazySingleton(() => HiveService());
}

Future<void> _initSharedPreferences() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  serviceLocator.registerLazySingleton<SharedPreferences>(
    () => sharedPreferences,
  );
  serviceLocator.registerLazySingleton<TokenSharedPrefs>(
    () => TokenSharedPrefs(
      sharedPreferences: serviceLocator<SharedPreferences>(),
    ),
  );
}

Future<void> initApiModule() async {
  // Dio instance
  serviceLocator.registerLazySingleton<Dio>(() => Dio());
  serviceLocator.registerLazySingleton(() => ApiService(serviceLocator<Dio>()));
}

Future<void> _initQueueModule() async {
   //DataSource
  serviceLocator.registerFactory(
    () => QueueRemoteDatasource(apiService: serviceLocator<ApiService>()),
  );

  //Repositorty
  serviceLocator.registerFactory(
    () => QueueRemoteRepository(
      queueRemoteDatasource:
          serviceLocator<QueueRemoteDatasource>(),
    ),
  );

  //usecase
  serviceLocator.registerFactory(
    () => GetQueueStatusUseCase(
      queueRepository: serviceLocator<QueueRemoteRepository>(),
    ),
  );

    //view model
  serviceLocator.registerFactory(
    () => QueueViewModel(
      getQueueStatusUseCase: serviceLocator<GetQueueStatusUseCase>(),
    ),
  );

}

Future<void> _initAppointmentModule() async {
  //DataSource
  serviceLocator.registerFactory(
    () => AppointmentRemoteDataSource(apiService: serviceLocator<ApiService>()),
  );

  //Repositorty
  serviceLocator.registerFactory(
    () => AppointmentRemoteRepository(
      appointmentRemoteDataSource:
          serviceLocator<AppointmentRemoteDataSource>(),
    ),
  );

  //usecase
  serviceLocator.registerFactory(
    () => AppointmentBookUseCase(
      appointmentRepository: serviceLocator<AppointmentRemoteRepository>(),
    ),
  );

  serviceLocator.registerFactory(
    () => GetUserAppointmentsUseCase(
      appointmentRepository: serviceLocator<AppointmentRemoteRepository>(),
    ),
  );

  serviceLocator.registerFactory(
    () => CancelAppointmentUseCase(
      appointmentRepository: serviceLocator<AppointmentRemoteRepository>(),
    ),
  );

  //view model
  serviceLocator.registerFactory(
    () => AppointmentViewModel(
      getAppointmentsUseCase: serviceLocator<GetUserAppointmentsUseCase>(),
      bookAppointmentUseCase: serviceLocator<AppointmentBookUseCase>(),
      cancelAppointmentUseCase: serviceLocator<CancelAppointmentUseCase>(),
    ),
  );
}

Future<void> _initDoctorModule() async {
  // Data source
  serviceLocator.registerFactory(
    () => DoctorLocalDataSource(hiveService: serviceLocator<HiveService>()),
  );
  serviceLocator.registerFactory(
    () => DoctorRemoteDataSource(apiService: serviceLocator<ApiService>()),
  );

  // Repository
  serviceLocator.registerFactory(
    () => DoctorLocalRepository(
      doctorLocalDataSource: serviceLocator<DoctorLocalDataSource>(),
    ),
  );

  serviceLocator.registerFactory(
    () => DoctorRemoteRepository(
      doctorRemoteDataSource: serviceLocator<DoctorRemoteDataSource>(),
    ),
  );

  // UseCases
  serviceLocator.registerFactory(
    () => DoctorGetAllUsecase(
      doctorRepository: serviceLocator<DoctorRemoteRepository>(),
    ),
  );

  serviceLocator.registerFactory(
    () => DoctorGetByIdUsecase(
      doctorRepository: serviceLocator<DoctorRemoteRepository>(),
    ),
  );

  //viewmodel

  serviceLocator.registerFactory(
    () => DoctorListViewModel(serviceLocator<DoctorGetAllUsecase>()),
  );
}

Future<void> _initAuthModule() async {
  // Data Source
  serviceLocator.registerFactory(
    () => UserLocalDatasource(hiveService: serviceLocator<HiveService>()),
  );

  serviceLocator.registerFactory(
    () => UserRemoteDatasource(apiService: serviceLocator<ApiService>()),
  );

  // Repository
  serviceLocator.registerFactory(
    () => UserLocalRepository(
      userLocalDatasource: serviceLocator<UserLocalDatasource>(),
    ),
  );

  serviceLocator.registerFactory(
    () => UserRemoteRepository(
      userRemoteDatasource: serviceLocator<UserRemoteDatasource>(),
    ),
  );

  // UseCases
  serviceLocator.registerFactory(
    () => UserRegisterUsecase(
      userRepository: serviceLocator<UserRemoteRepository>(),
    ),
  );

  serviceLocator.registerFactory(
    () => UserLoginUsecase(
      userRepository: serviceLocator<UserRemoteRepository>(),
      tokenSharedPrefs: serviceLocator<TokenSharedPrefs>(),
    ),
  );

  serviceLocator.registerFactory(
    () => UserGetCurrentUsecase(
      userRepository: serviceLocator<UserRemoteRepository>(),
    ),
  );

  // ViewModels
  serviceLocator.registerLazySingleton(
    () => RegisterViewModel(
      registerUsecase: serviceLocator<UserRegisterUsecase>(),
    ),
  );

  serviceLocator.registerFactory(
    () => LoginViewModel(serviceLocator<UserLoginUsecase>()),
  );
}
