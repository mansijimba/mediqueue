import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mediqueue/app/service_locator/service_locator.dart';
import 'package:mediqueue/features/appointment/presentation/view/book_appointment_view.dart';
import 'package:mediqueue/features/appointment/presentation/view_model/appointment_view_model.dart';
import 'package:mediqueue/features/auth/domain/use_case/user_get_current_usecase.dart';
import 'package:mediqueue/features/doctor/domain/usecase/doctor_get_byId_usecase.dart';
import 'package:mediqueue/features/doctor/presentation/view_model/doctor_event.dart';
import 'package:mediqueue/features/doctor/presentation/view_model/doctor_state.dart';
import 'package:mediqueue/features/doctor/presentation/view_model/doctor_view_model.dart';

class DoctorListScreen extends StatefulWidget {
  const DoctorListScreen({super.key});

  @override
  State<DoctorListScreen> createState() => _DoctorListScreenState();
}

class _DoctorListScreenState extends State<DoctorListScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) =>
              serviceLocator<DoctorListViewModel>()..add(FetchDoctors()),
        ),
        BlocProvider(
          create: (_) => serviceLocator<AppointmentViewModel>(),
        ),
      ],
      child: BlocBuilder<DoctorListViewModel, DoctorListState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.errorMessage != null) {
            return Center(
              child: Text(
                state.errorMessage!,
                style: const TextStyle(color: Colors.red, fontSize: 16),
              ),
            );
          }

          if (state.isSuccess && state.doctors.isNotEmpty) {
            
            return ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              itemCount: state.doctors.length,
              separatorBuilder: (_, __) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final doctor = state.doctors[index];
                return Material(
                  color: Colors.white,
                  elevation: 3,
                  borderRadius: BorderRadius.circular(14),
                  shadowColor: Colors.teal.withOpacity(0.3),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(14),
                    onTap: () {},
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          doctor.filepath != null
                              ? CircleAvatar(
                                  radius: 32,
                                  backgroundImage: NetworkImage(doctor.filepath!),
                                )
                              : const CircleAvatar(
                                  radius: 32,
                                  child: Icon(Icons.person, size: 36),
                                ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  doctor.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 20,
                                    color: Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  doctor.specialty,
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.grey.shade600,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          ElevatedButton.icon(
                            onPressed: () async {
                              final userGetCurrentUsecase =
                                  serviceLocator<UserGetCurrentUsecase>();
                              final result = await userGetCurrentUsecase.call();

                              result.fold(
                                (failure) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Error loading user: ${failure.message}',
                                      ),
                                    ),
                                  );
                                },
                                (user) {
                                  final doctorGetByIdUsecase =
                                      serviceLocator<DoctorGetByIdUsecase>();

                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => BlocProvider.value(
                                        value: context.read<AppointmentViewModel>(),
                                        child: BookAppointmentScreen(
                                          doctorId: doctor.id,
                                          patientId: user.userId!,
                                          doctorGetByIdUsecase:
                                              doctorGetByIdUsecase,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                            icon: const Icon(
                              Icons.calendar_today_outlined,
                              color: Colors.white,
                              size: 18,
                            ),
                            label: const Text(
                              'Book',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.teal,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 14,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 4,
                              shadowColor: Colors.teal.shade700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }

          return const Center(
            child: Text(
              'No doctors found.',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          );
        },
      ),
    );
  }
}
