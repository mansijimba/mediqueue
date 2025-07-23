import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:mediqueue/app/app.dart';
import 'package:mediqueue/app/service_locator/service_locator.dart';
import 'package:mediqueue/core/network/hive_service.dart';
import 'package:mediqueue/features/appointment/presentation/view_model/appointment_view_model.dart';
import 'package:mediqueue/features/doctor/presentation/view_model/doctor_view_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize dependencies and HiveService
  await initDependencies();
  await HiveService().init();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<AppointmentViewModel>(
          create: (_) => serviceLocator<AppointmentViewModel>(),
        ),
        BlocProvider<DoctorListViewModel>(
          create: (_) => serviceLocator<DoctorListViewModel>(),
        ),
        // Add other Blocs/Providers as needed
      ],
      child: const MyApp(),
    ),
  );
}
