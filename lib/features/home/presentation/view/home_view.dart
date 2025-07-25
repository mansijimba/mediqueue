import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:mediqueue/features/doctor/presentation/view/doctor_list_view.dart';
import 'package:mediqueue/features/home/presentation/view/bottom_view/appointment_view.dart';
import 'package:mediqueue/features/home/presentation/view/bottom_view/profile_view.dart';
import 'package:mediqueue/features/home/presentation/view_model/home_state.dart';
import 'package:mediqueue/features/home/presentation/view_model/home_view_model.dart';

class DashboardScreen extends StatefulWidget {
  final String patientId;

  const DashboardScreen({Key? key, required this.patientId}) : super(key: key);

  static const List<BottomNavigationBarItem> _bottomNavItems = [
    BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
    BottomNavigationBarItem(
      icon: Icon(Icons.calendar_today),
      label: 'Appointments',
    ),
    BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
  ];

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  StreamSubscription? _accelerometerSubscription;
  DateTime _lastShakeTime = DateTime.now();

  @override
  void initState() {
    super.initState();
    _startListeningToShake();
  }

  void _startListeningToShake() {
    const double shakeThreshold = 15.0;

    _accelerometerSubscription = accelerometerEvents.listen((
      AccelerometerEvent event,
    ) {
      double acceleration = sqrt(
        event.x * event.x + event.y * event.y + event.z * event.z,
      );

      if (acceleration > shakeThreshold) {
        final now = DateTime.now();
        if (now.difference(_lastShakeTime) > const Duration(seconds: 2)) {
          _lastShakeTime = now;
          context.read<HomeViewModel>().logout(context);
        }
      }
    });
  }

  @override
  void dispose() {
    _accelerometerSubscription?.cancel();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    context.read<HomeViewModel>().setContext(context);
     print("Context set in HomeViewModel");
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeViewModel, HomeState>(
      builder: (context, state) {
        final views = [
          const DoctorListScreen(),
          AppointmentListView(patientId: widget.patientId),
          const ProfileView(),
        ];

        return Scaffold(
          backgroundColor: Colors.teal.shade50,
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(70),
            child: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: Colors.teal.shade700,
              elevation: 8,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(30),
                ),
              ),
              title: Row(
                children: [
                  Material(
                    elevation: 8,
                    shape: const CircleBorder(),
                    clipBehavior: Clip.antiAlias,
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 24,
                      child: Image.asset(
                        'assets/images/logo.png',
                        width: 34,
                        height: 34,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Text(
                    'MediQueue',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: 26,
                      letterSpacing: 1.5,
                      shadows: [
                        Shadow(
                          color: Colors.black45,
                          offset: Offset(1, 1),
                          blurRadius: 3,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            child: Card(
              elevation: 6,
              shadowColor: Colors.teal.shade200,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: IndexedStack(
                  index: state.selectedIndex,
                  children: views,
                ),
              ),
            ),
          ),
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.teal.shade200.withOpacity(0.4),
                  blurRadius: 15,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: BottomNavigationBar(
              backgroundColor: Colors.white,
              selectedItemColor: Colors.teal.shade700,
              unselectedItemColor: Colors.grey.shade500,
              currentIndex: state.selectedIndex,
              type: BottomNavigationBarType.fixed,
              showUnselectedLabels: true,
              selectedLabelStyle: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
              unselectedLabelStyle: const TextStyle(fontSize: 12),
              elevation: 20,
              onTap:
                  (index) => context.read<HomeViewModel>().onTabTapped(index),
              items:
                  DashboardScreen._bottomNavItems.map((item) {
                    final selected =
                        state.selectedIndex ==
                        DashboardScreen._bottomNavItems.indexOf(item);
                    return BottomNavigationBarItem(
                      icon: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          gradient:
                              selected
                                  ? LinearGradient(
                                    colors: [
                                      Colors.teal.shade100,
                                      Colors.teal.shade300,
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  )
                                  : null,
                        ),
                        child: Icon(
                          (item.icon as Icon).icon,
                          color:
                              selected
                                  ? Colors.teal.shade800
                                  : Colors.grey.shade600,
                          size: 28,
                        ),
                      ),
                      label: item.label,
                    );
                  }).toList(),
            ),
          ),
        );
      },
    );
  }
}
