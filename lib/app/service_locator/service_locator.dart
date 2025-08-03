// import 'package:dio/dio.dart';
// import 'package:get_it/get_it.dart';
// import 'package:mediqueue/app/shared_pref/token_shared_prefs.dart';
// import 'package:mediqueue/core/network/api_service.dart';
// import 'package:mediqueue/core/network/hive_service.dart';
// import 'package:mediqueue/features/appointment/data/data_source/remote_datasource/appointment_remote_data_source.dart';
// import 'package:mediqueue/features/appointment/data/repository/remote_repository/appointment_remote_repository.dart';
// import 'package:mediqueue/features/appointment/domain/use_case/appointment_cancel.usecase.dart';
// import 'package:mediqueue/features/appointment/domain/use_case/appointment_get_by_patient_id_usecase.dart';
// import 'package:mediqueue/features/appointment/domain/use_case/book_appointment_usecase.dart';
// import 'package:mediqueue/features/appointment/presentation/view_model/appointment_view_model.dart';
// import 'package:mediqueue/features/auth/data/data_source/local_datasource/user_local_datasource.dart';
// import 'package:mediqueue/features/auth/data/data_source/remote_datasource/user_remote_datasource.dart';
// import 'package:mediqueue/features/auth/data/repository/local_repository/user_local_repository.dart';
// import 'package:mediqueue/features/auth/data/repository/remote_repository/user_remote_repository.dart';
// import 'package:mediqueue/features/auth/domain/use_case/user_get_current_usecase.dart';
// import 'package:mediqueue/features/auth/domain/use_case/user_login_usecase.dart';
// import 'package:mediqueue/features/auth/domain/use_case/user_register_usecase.dart';
// import 'package:mediqueue/features/auth/presentation/view_model/login_view_model.dart/login_view_model.dart';
// import 'package:mediqueue/features/auth/presentation/view_model/register_view_model.dart/register_view_model.dart';
// import 'package:mediqueue/features/doctor/data/datasource/local_datasource/doctor_local_data_source.dart';
// import 'package:mediqueue/features/doctor/data/datasource/remote_datasource/doctor_remote_data_source.dart';
// import 'package:mediqueue/features/doctor/data/repository/local_repository/doctor_local_repository.dart';
// import 'package:mediqueue/features/doctor/data/repository/remote_repository/doctor_remote_repository.dart';
// import 'package:mediqueue/features/doctor/domain/usecase/doctor_get_all_usecase.dart';
// import 'package:mediqueue/features/doctor/domain/usecase/doctor_get_byId_usecase.dart';
// import 'package:mediqueue/features/doctor/presentation/view_model/doctor_view_model.dart';
// import 'package:mediqueue/features/home/domain/usecase/home_usecase.dart';
// import 'package:mediqueue/features/home/presentation/view_model/home_view_model.dart';
// import 'package:mediqueue/features/queue/data/data_source/remote_data_source/queue_remote_datasource.dart';
// import 'package:mediqueue/features/queue/data/repository/remote_repository/queue_remote_repository.dart';
// import 'package:mediqueue/features/queue/domain/use_case/get_queue_status_usecase.dart';
// import 'package:mediqueue/features/queue/presentation/view_model/queue_view_model.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// final serviceLocator = GetIt.instance;

// Future<void> initDependencies() async {
//   await _initHiveService();
//   await _initSharedPreferences();
//   await _initApiModule();
//   await _initAuthModule();
//   await _initDoctorModule();
//   await _initAppointmentModule();
//   await _initQueueModule();
//   await _initHomeModule();
// }

// Future<void> _initHiveService() async {
//   serviceLocator.registerLazySingleton(() => HiveService());
// }

// Future<void> _initSharedPreferences() async {
//   final sharedPreferences = await SharedPreferences.getInstance();
//   serviceLocator.registerLazySingleton<SharedPreferences>(
//     () => sharedPreferences,
//   );
//   serviceLocator.registerLazySingleton<TokenSharedPrefs>(
//     () => TokenSharedPrefs(
//       sharedPreferences: serviceLocator<SharedPreferences>(),
//     ),
//   );
// }

// Future<void> _initApiModule() async {
//   serviceLocator.registerLazySingleton(() => Dio());
//   serviceLocator.registerLazySingleton(() => ApiService(serviceLocator<Dio>()));
// }

// Future<void> _initAuthModule() async {
//   // Data Sources
//   serviceLocator.registerFactory(
//     () => UserLocalDatasource(hiveService: serviceLocator<HiveService>()),
//   );
//   serviceLocator.registerFactory(
//     () => UserRemoteDatasource(apiService: serviceLocator<ApiService>()),
//   );

//   // Repositories
//   serviceLocator.registerFactory(
//     () => UserLocalRepository(
//       userLocalDatasource: serviceLocator<UserLocalDatasource>(),
//     ),
//   );
//   serviceLocator.registerFactory(
//     () => UserRemoteRepository(
//       userRemoteDatasource: serviceLocator<UserRemoteDatasource>(),
//     ),
//   );

//   // UseCases
//   serviceLocator.registerFactory(
//     () => UserRegisterUsecase(
//       userRepository: serviceLocator<UserRemoteRepository>(),
//     ),
//   );
//   serviceLocator.registerFactory(
//     () => UserLoginUsecase(
//       userRepository: serviceLocator<UserRemoteRepository>(),
//       tokenSharedPrefs: serviceLocator<TokenSharedPrefs>(),
//     ),
//   );
//   serviceLocator.registerFactory(
//     () => UserGetCurrentUsecase(
//       userRepository: serviceLocator<UserRemoteRepository>(),
//     ),
//   );

//   // ViewModels
//   serviceLocator.registerLazySingleton(
//     () => RegisterViewModel(
//       registerUsecase: serviceLocator<UserRegisterUsecase>(),
//     ),
//   );
//   serviceLocator.registerLazySingleton(
//     () => LoginViewModel(serviceLocator<UserLoginUsecase>()),
//   );
// }

// Future<void> _initDoctorModule() async {
//   // Data Sources
//   serviceLocator.registerFactory(
//     () => DoctorLocalDataSource(hiveService: serviceLocator<HiveService>()),
//   );
//   serviceLocator.registerFactory(
//     () => DoctorRemoteDataSource(apiService: serviceLocator<ApiService>()),
//   );

//   // Repositories
//   serviceLocator.registerFactory(
//     () => DoctorLocalRepository(
//       doctorLocalDataSource: serviceLocator<DoctorLocalDataSource>(),
//     ),
//   );
//   serviceLocator.registerFactory(
//     () => DoctorRemoteRepository(
//       doctorRemoteDataSource: serviceLocator<DoctorRemoteDataSource>(),
//     ),
//   );

//   // UseCases
//   serviceLocator.registerFactory(
//     () => DoctorGetAllUsecase(
//       doctorRepository: serviceLocator<DoctorRemoteRepository>(),
//     ),
//   );
//   serviceLocator.registerFactory(
//     () => DoctorGetByIdUsecase(
//       doctorRepository: serviceLocator<DoctorRemoteRepository>(),
//     ),
//   );

//   // ViewModels
//   serviceLocator.registerFactory(
//     () => DoctorListViewModel(serviceLocator<DoctorGetAllUsecase>()),
//   );
// }

// Future<void> _initAppointmentModule() async {
//   // Data Sources
//   serviceLocator.registerFactory(
//     () => AppointmentRemoteDataSource(apiService: serviceLocator<ApiService>()),
//   );

//   // Repositories
//   serviceLocator.registerFactory(
//     () => AppointmentRemoteRepository(
//       appointmentRemoteDataSource:
//           serviceLocator<AppointmentRemoteDataSource>(),
//     ),
//   );

//   // UseCases
//   serviceLocator.registerFactory(
//     () => AppointmentBookUseCase(
//       appointmentRepository: serviceLocator<AppointmentRemoteRepository>(),
//     ),
//   );
//   serviceLocator.registerFactory(
//     () => GetUserAppointmentsUseCase(
//       appointmentRepository: serviceLocator<AppointmentRemoteRepository>(),
//     ),
//   );
//   serviceLocator.registerFactory(
//     () => CancelAppointmentUseCase(
//       appointmentRepository: serviceLocator<AppointmentRemoteRepository>(),
//     ),
//   );

//   // ViewModels
// serviceLocator.registerLazySingleton<AppointmentViewModel>(() => AppointmentViewModel(
//   getAppointmentsUseCase: serviceLocator<GetUserAppointmentsUseCase>(),
//   bookAppointmentUseCase: serviceLocator<AppointmentBookUseCase>(),
//   cancelAppointmentUseCase: serviceLocator<CancelAppointmentUseCase>(),
// ));

// }

// Future<void> _initQueueModule() async {
//   // Data Sources
//   serviceLocator.registerFactory(
//     () => QueueRemoteDatasource(apiService: serviceLocator<ApiService>()),
//   );

//   // Repositories
//   serviceLocator.registerFactory(
//     () => QueueRemoteRepository(
//       queueRemoteDatasource: serviceLocator<QueueRemoteDatasource>(),
//     ),
//   );

//   // UseCases
//   serviceLocator.registerFactory(
//     () => GetQueueStatusUseCase(
//       queueRepository: serviceLocator<QueueRemoteRepository>(),
//     ),
//   );

//   // ViewModels
//   serviceLocator.registerFactory(
//     () => QueueViewModel(
//       getQueueStatusUseCase: serviceLocator<GetQueueStatusUseCase>(),
//     ),
//   );
// }

// Future<void> _initHomeModule() async {
//   // You need to register LogoutUseCase here first (depends on LoginViewModel)
//   serviceLocator.registerFactory<LogoutUseCase>(
//     () => LogoutUseCase(serviceLocator<LoginViewModel>()),
//   );

//   // ShakeDetectionUseCase has no dependencies, so just register directly
//   serviceLocator.registerFactory<ShakeDetectionUseCase>(
//     () => ShakeDetectionUseCase(),
//   );

//   // HomeViewModel depends on LogoutUseCase and LoginViewModel
//   serviceLocator.registerFactory<HomeViewModel>(
//     () => HomeViewModel(
//       logoutUseCase: serviceLocator<LogoutUseCase>(),
//       loginViewModel: serviceLocator<LoginViewModel>(),
//     ),
//   );
// }
