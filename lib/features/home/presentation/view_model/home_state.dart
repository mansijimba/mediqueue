import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mediqueue/app/service_locator/service_locator.dart';
import 'package:mediqueue/features/doctor/presentation/view/doctor_list_view.dart';
import 'package:mediqueue/features/appointment/presentation/view_model/appointment_view_model.dart';
import 'package:mediqueue/features/doctor/presentation/view_model/doctor_view_model.dart';
import 'package:mediqueue/features/home/presentation/view/bottom_view/appointment_view.dart';
import 'package:mediqueue/features/home/presentation/view/bottom_view/profile_view.dart';

class HomeState {
  final int selectedIndex;
  final List<Widget> views;
  final bool isLoggingOut; // 🆕 added for shake-based logout

  const HomeState({
    required this.selectedIndex,
    required this.views,
    required this.isLoggingOut,
  });

  static HomeState initial() {
    return HomeState(
      selectedIndex: 0,
      views: [
        BlocProvider.value(
          value: serviceLocator<DoctorListViewModel>(),
          child: const DoctorListScreen(),
        ),
        BlocProvider.value(
          value: serviceLocator<AppointmentViewModel>(),
          child: const AppointmentListView(patientId: ''),
        ),
        const ProfileView(),
      ],
      isLoggingOut: false, // 🆕 initialize to false
    );
  }

  HomeState copyWith({
    int? selectedIndex,
    List<Widget>? views,
    bool? isLoggingOut, // 🆕 allow copying with new logout state
  }) {
    return HomeState(
      selectedIndex: selectedIndex ?? this.selectedIndex,
      views: views ?? this.views,
      isLoggingOut: isLoggingOut ?? this.isLoggingOut,
    );
  }
}
