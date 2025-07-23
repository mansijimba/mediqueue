import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mediqueue/features/appointment/presentation/view_model/appointment_event.dart';
import 'package:mediqueue/features/appointment/presentation/view_model/appointment_state.dart';
import 'package:mediqueue/features/appointment/presentation/view_model/appointment_view_model.dart';
import 'package:mediqueue/features/queue/presentation/view/queue_view.dart';

class AppointmentListView extends StatefulWidget {
  final String patientId;

  const AppointmentListView({Key? key, required this.patientId})
    : super(key: key);

  @override
  State<AppointmentListView> createState() => _AppointmentListViewState();
}

class _AppointmentListViewState extends State<AppointmentListView> {
  @override
  void initState() {
    super.initState();
    context.read<AppointmentViewModel>().add(
      FetchAppointmentsByPatientId(widget.patientId),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppointmentViewModel, AppointmentState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state.errorMessage != null) {
          return Center(child: Text('Error: ${state.errorMessage}'));
        } else if (state.appointments.isEmpty) {
          return const Center(child: Text('No Appointments Found.'));
        }

        return ListView.separated(
          padding: const EdgeInsets.all(12),
          itemCount: state.appointments.length,
          separatorBuilder: (_, __) => const SizedBox(height: 10),
          itemBuilder: (context, index) {
            final appointment = state.appointments[index];
            return Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Dr. ${appointment.doctorName}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text('${appointment.date} at ${appointment.time}'),
                    Text('Type: ${appointment.type}'),
                    Text('Status: ${appointment.status}'),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (_) => QueueStatusView(
                                    patientId: widget.patientId,
                                  ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: const Text(
                          'View Queue Status',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
