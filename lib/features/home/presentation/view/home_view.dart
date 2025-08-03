import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mediqueue/features/doctor/presentation/view/doctor_list_view.dart';
import 'package:mediqueue/features/home/presentation/view/bottom_view/appointment_view.dart';
import 'package:mediqueue/features/home/presentation/view/bottom_view/profile_view.dart';
import 'package:mediqueue/features/home/presentation/view_model/home_state.dart';
import 'package:mediqueue/features/home/presentation/view_model/home_view_model.dart';
import 'package:mediqueue/features/home/presentation/view_model/home_event.dart';

class DashboardScreen extends StatefulWidget {
  final String patientId;

  const DashboardScreen({super.key, required this.patientId});

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
  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return "Good Morning";
    if (hour < 17) return "Good Afternoon";
    return "Good Evening";
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    context.read<HomeViewModel>().setContext(context);
  }

  final homeView = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Text(
                "Take the first step toward better health book your appointment now.",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal,
                  height: 1.3,
                ),
              ),
            ),
            const Expanded(child: DoctorListScreen()),
          ],
        );

     @override
  void initState() {
    super.initState();
    views = [
      homeView,
      AppointmentListView(patientId: widget.patientId),
      const ProfileView(),
    ];
  }

List<Widget> views = [];
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeViewModel, HomeState>(
      builder: (context, state) {
        // Wrap DoctorListScreen with heading message
      

        return Scaffold(
          backgroundColor: Colors.teal.shade50,
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(90),
            child: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: Colors.teal.shade600,
              elevation: 10,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(30),
                ),
              ),
              title: Row(
                children: [
                  CircleAvatar(
                    radius: 26,
                    backgroundColor: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Image.asset(
                        'assets/images/logo.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _getGreeting(),
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white70,
                        ),
                      ),
                      const Text(
                        'MediQueue',
                        style: TextStyle(
                          fontSize: 24,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.notifications, color: Colors.white),
                  onPressed: () {},
                ),
                const SizedBox(width: 8),
              ],
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: Card(
              elevation: 8,
              shadowColor: Colors.teal.shade100,
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
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, -2),
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
              elevation: 15,
              onTap: (index) {
                context.read<HomeViewModel>().add(TabChanged(index));
              },
              items:
                  DashboardScreen._bottomNavItems.map((item) {
                    final selected =
                        state.selectedIndex ==
                        DashboardScreen._bottomNavItems.indexOf(item);
                    return BottomNavigationBarItem(
                      icon: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        padding: const EdgeInsets.all(8),
                        decoration:
                            selected
                                ? BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.teal.shade100,
                                      Colors.teal.shade300,
                                    ],
                                  ),
                                )
                                : null,
                        child: Icon(
                          (item.icon as Icon).icon,
                          color:
                              selected
                                  ? Colors.teal.shade800
                                  : Colors.grey.shade600,
                          size: 26,
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
