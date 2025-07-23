import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mediqueue/features/appointment/presentation/view_model/appointment_event.dart';
import 'package:mediqueue/features/appointment/presentation/view_model/appointment_view_model.dart';
import 'package:mediqueue/features/doctor/domain/entity/doctor_entity.dart';
import 'package:mediqueue/features/doctor/domain/usecase/doctor_get_byId_usecase.dart';

class BookAppointmentScreen extends StatefulWidget {
  final String doctorId;
  final String patientId;
  final DoctorGetByIdUsecase doctorGetByIdUsecase;

  const BookAppointmentScreen({
    super.key,
    required this.doctorId,
    required this.patientId,
    required this.doctorGetByIdUsecase,
  });

  @override
  State<BookAppointmentScreen> createState() => _BookAppointmentScreenState();
}

class _BookAppointmentScreenState extends State<BookAppointmentScreen> {
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  String type = 'Consultation';

  DoctorEntity? doctor;
  bool isLoadingDoctor = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchDoctor();
  }

  Future<void> _fetchDoctor() async {
    final result = await widget.doctorGetByIdUsecase.call(
      DoctorGetByIdParams(widget.doctorId),
    );
    result.fold(
      (failure) => setState(() {
        isLoadingDoctor = false;
        errorMessage = failure.message;
      }),
      (doctorEntity) => setState(() {
        doctor = doctorEntity;
        isLoadingDoctor = false;
      }),
    );
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder:
          (context, child) => Theme(
            data: Theme.of(context).copyWith(
              colorScheme: const ColorScheme.light(
                primary: Colors.teal,
                onPrimary: Colors.white,
                onSurface: Colors.black,
              ),
            ),
            child: child!,
          ),
    );
    if (picked != null) {
      setState(() => selectedDate = picked);
    }
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder:
          (context, child) => Theme(
            data: Theme.of(context).copyWith(
              timePickerTheme: TimePickerThemeData(
                dialHandColor: Colors.teal,
                dialBackgroundColor: Colors.teal.shade50,
              ),
            ),
            child: child!,
          ),
    );
    if (picked != null) {
      setState(() => selectedTime = picked);
    }
  }

  void _bookAppointment() {
    if (selectedDate == null || selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select date and time')),
      );
      return;
    }

    if (doctor == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Doctor details not loaded')),
      );
      return;
    }

    final dateStr =
        '${selectedDate!.year}-${selectedDate!.month.toString().padLeft(2, '0')}-${selectedDate!.day.toString().padLeft(2, '0')}';
    final timeStr =
        '${selectedTime!.hour.toString().padLeft(2, '0')}:${selectedTime!.minute.toString().padLeft(2, '0')}';

    context.read<AppointmentViewModel>().add(
      BookAppointmentEvent(
        doctorId: widget.doctorId,
        patientId: widget.patientId,
        specialty: doctor!.specialty,
        date: dateStr,
        time: timeStr,
        type: type,
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Appointment booked successfully!')),
    );

    Navigator.pop(context,true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Appointment'),
        backgroundColor: Colors.teal,
      ),
      body:
          isLoadingDoctor
              ? const Center(child: CircularProgressIndicator())
              : errorMessage != null
              ? Center(
                child: Text(
                  errorMessage!,
                  style: const TextStyle(color: Colors.red, fontSize: 18),
                ),
              )
              : SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 40,
                            backgroundImage:
                                doctor!.filepath != null
                                    ? NetworkImage(doctor!.filepath!)
                                    : null,
                            child:
                                doctor!.filepath == null
                                    ? const Icon(Icons.person, size: 40)
                                    : null,
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Dr. ${doctor!.name}',
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  doctor!.specialty,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey.shade700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                      _buildSectionTitle('Select Date'),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.calendar_today),
                        label: Text(
                          selectedDate == null
                              ? 'Choose Date'
                              : '${selectedDate!.toLocal()}'.split(' ')[0],
                        ),
                        onPressed: _pickDate,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                        ),
                      ),
                      const SizedBox(height: 20),
                      _buildSectionTitle('Select Time'),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.access_time),
                        label: Text(
                          selectedTime == null
                              ? 'Choose Time'
                              : selectedTime!.format(context),
                        ),
                        onPressed: _pickTime,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                        ),
                      ),
                      const SizedBox(height: 20),
                      _buildSectionTitle('Appointment Type'),
                      DropdownButtonFormField<String>(
                        value: type,
                        items: const [
                          DropdownMenuItem(
                            value: 'Consultation',
                            child: Text('Consultation'),
                          ),
                          DropdownMenuItem(
                            value: 'Follow-up',
                            child: Text('Follow-up'),
                          ),
                        ],
                        onChanged: (value) {
                          if (value != null) {
                            setState(() => type = value);
                          }
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      ElevatedButton(
                        onPressed: _bookAppointment,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: const Text(
                          'Book Appointment',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.teal,
      ),
    );
  }
}
