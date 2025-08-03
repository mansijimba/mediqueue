import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mediqueue/features/queue/presentation/view_model/queue_event.dart';
import 'package:mediqueue/features/queue/presentation/view_model/queue_state.dart';
import 'package:mediqueue/features/queue/presentation/view_model/queue_view_model.dart';

class QueueStatusView extends StatefulWidget {
  final String patientId;

  const QueueStatusView({super.key, required this.patientId, required String appointmentId});

  @override
  State<QueueStatusView> createState() => _QueueStatusViewState();
}

class _QueueStatusViewState extends State<QueueStatusView> {
  late QueueViewModel _queueViewModel;

  @override
  void initState() {
    super.initState();
    _queueViewModel = BlocProvider.of<QueueViewModel>(context);
    _queueViewModel.add(FetchQueueStatus(widget.patientId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Queue Status'),
        backgroundColor: Colors.teal,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
          tooltip: 'Back',
        ),
      ),
      backgroundColor: Colors.grey[100], // Light background color
      body: BlocBuilder<QueueViewModel, QueueState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state.isSuccess == false && state.errorMessage != null) {
            return Center(
              child: Text(
                'Error: ${state.errorMessage}',
                style: const TextStyle(
                  color: Colors.red, // Error text in red
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            );
          } else if (state.isSuccess && state.queueStatus != null) {
            final queue = state.queueStatus!;
            return Padding(
              padding: const EdgeInsets.all(24),
              child: Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 24,
                    horizontal: 20,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Queue Status',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueGrey[800],
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        queue.status,
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.teal[700],
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _infoRow('Your Position:', '${queue.position}'),
                      const SizedBox(height: 8),
                      _infoRow('Patients Ahead:', '${queue.totalAhead}'),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              ),
            );
          }
          // Default empty widget
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Row(
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        ),
        const SizedBox(width: 8),
        Text(value, style: const TextStyle(fontSize: 16)),
      ],
    );
  }
}
