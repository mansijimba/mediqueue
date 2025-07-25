import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mediqueue/app/service_locator/service_locator.dart';
import 'package:mediqueue/features/appointment/presentation/view_model/appointment_view_model.dart';
import 'package:mediqueue/features/doctor/presentation/view_model/doctor_view_model.dart';
import 'package:mediqueue/features/home/presentation/view/home_view.dart';
import 'package:mediqueue/features/home/presentation/view_model/home_view_model.dart';

class MainDashboardEntry extends StatelessWidget {
  final String patientId;

  const MainDashboardEntry({Key? key, required this.patientId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => serviceLocator<HomeViewModel>()),
        BlocProvider(create: (_) => serviceLocator<AppointmentViewModel>()),
        BlocProvider(create: (_) => serviceLocator<DoctorListViewModel>()),
      ],
      child: DashboardScreen(patientId: patientId),
    );
  }
}