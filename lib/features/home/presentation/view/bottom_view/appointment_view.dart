import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mediqueue/features/appointment/presentation/view_model/appointment_event.dart';
import 'package:mediqueue/features/appointment/presentation/view_model/appointment_state.dart';
import 'package:mediqueue/features/appointment/presentation/view_model/appointment_view_model.dart';
import 'package:mediqueue/features/queue/presentation/view/queue_view.dart';
import 'package:mediqueue/features/appointment/domain/entity/appointment_entity.dart';

class AppointmentListView extends StatefulWidget {
  final String patientId;

  const AppointmentListView({super.key, required this.patientId});

  @override
  State<AppointmentListView> createState() => _AppointmentListViewState();
}

class _AppointmentListViewState extends State<AppointmentListView> {
  bool _hasFetched = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_hasFetched) {
      context.read<AppointmentViewModel>().add(
        FetchAppointmentsByPatientId(widget.patientId),
      );
      _hasFetched = true;
    }
  }

  void _cancelAppointment(String appointmentId) {
    context.read<AppointmentViewModel>().add(
      CancelAppointmentEvent(
        appointmentId: appointmentId,
        patientId: widget.patientId,
      ),
    );
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Cancelling appointment...')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Appointments'),
        backgroundColor: Colors.teal,
        elevation: 4,
      ),
      body: BlocListener<AppointmentViewModel, AppointmentState>(
        listener: (context, state) {
          if (state.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: ${state.errorMessage}')),
            );
          } else if (state.isSuccess && !state.isLoading) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Operation successful')),
            );
          }
        },
        child: BlocBuilder<AppointmentViewModel, AppointmentState>(
          builder: (context, state) {
            if (state.isLoading && state.appointments.isEmpty) {
              // Show loading only when initially loading appointments
              return const Center(child: CircularProgressIndicator());
            } else if (state.errorMessage != null &&
                state.appointments.isEmpty) {
              return Center(
                child: Text(
                  'Error: ${state.errorMessage}',
                  style: const TextStyle(color: Colors.red, fontSize: 16),
                ),
              );
            } else if (state.appointments.isEmpty) {
              return const Center(
                child: Text(
                  'No appointments found.',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              );
            } else {
              return ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: state.appointments.length,
                itemBuilder: (context, index) {
                  final AppointmentEntity appointment =
                      state.appointments[index];
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    elevation: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            appointment.doctorName ?? 'Unknown Doctor',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.teal,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              const Icon(
                                Icons.calendar_today,
                                size: 18,
                                color: Colors.grey,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                appointment.date,
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.teal,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 12,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                icon: const Icon(Icons.queue),
                                label: const Text('View Queue'),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (_) => QueueStatusView(
                                            appointmentId: appointment.id,
                                            patientId: widget.patientId,
                                          ),
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(width: 12),
                              ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.redAccent,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 12,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                icon: const Icon(Icons.cancel),
                                label: const Text('Cancel'),
                                onPressed:
                                    state.isLoading
                                        ? null
                                        : () =>
                                            _cancelAppointment(appointment.id),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
