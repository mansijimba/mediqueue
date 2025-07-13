import 'package:flutter/material.dart';

class AppointmentScreen extends StatefulWidget {
  const AppointmentScreen({super.key});

  @override
  State<AppointmentScreen> createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends State<AppointmentScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Map<String, dynamic>> upcomingAppointments = [
    {
      'doctor': 'Dr. Sarah Johnson',
      'specialty': 'Cardiologist',
      'date': 'July 10',
      'time': '10:30 AM',
      'status': 'Confirmed',
    },
  ];

  final List<Map<String, dynamic>> pastAppointments = [
    {
      'doctor': 'Dr. Emily Davis',
      'specialty': 'General Physician',
      'date': 'June 30',
      'time': '11:00 AM',
      'status': 'Completed',
    },
  ];

  // Booking form state
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _doctorController = TextEditingController();
  final TextEditingController _specialtyController = TextEditingController();
  final TextEditingController _reasonController = TextEditingController();
  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _doctorController.dispose();
    _specialtyController.dispose();
    _reasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE6FFFA),
      appBar: AppBar(
        title: const Text("Appointments"),
        backgroundColor: Colors.teal,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Upcoming'),
            Tab(text: 'Past'),
            Tab(text: 'Book Appointment'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildAppointmentList(upcomingAppointments),
          _buildAppointmentList(pastAppointments),
          _buildBookingForm(),
        ],
      ),
    );
  }

  Widget _buildAppointmentList(List<Map<String, dynamic>> appointments) {
    if (appointments.isEmpty) {
      return const Center(child: Text("No appointments found."));
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: appointments.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final appointment = appointments[index];
        return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: ListTile(
            leading: const CircleAvatar(
              backgroundImage: AssetImage(
                "assets/images/doctor-avatar.png",
              ), // Replace with your image
            ),
            title: Text(
              appointment['doctor'],
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              "${appointment['specialty']} • ${appointment['date']} at ${appointment['time']}",
            ),
            trailing: _buildStatusChip(appointment['status']),
          ),
        );
      },
    );
  }

  Widget _buildStatusChip(String status) {
    Color bgColor;
    Color textColor;

    switch (status.toLowerCase()) {
      case 'confirmed':
        bgColor = Colors.green[100]!;
        textColor = Colors.green[800]!;
        break;
      case 'completed':
        bgColor = Colors.blue[100]!;
        textColor = Colors.blue[800]!;
        break;
      case 'cancelled':
        bgColor = Colors.red[100]!;
        textColor = Colors.red[800]!;
        break;
      case 'pending':
        bgColor = Colors.yellow[100]!;
        textColor = Colors.orange[800]!;
        break;
      default:
        bgColor = Colors.grey[200]!;
        textColor = Colors.grey[800]!;
    }

    return Chip(
      label: Text(
        status,
        style: TextStyle(color: textColor, fontWeight: FontWeight.w500),
      ),
      backgroundColor: bgColor,
    );
  }

  Widget _buildBookingForm() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: ListView(
          children: [
            const Text(
              "Book New Appointment",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _doctorController,
              decoration: const InputDecoration(labelText: 'Doctor Name'),
              validator:
                  (value) => value!.isEmpty ? 'Please enter doctor name' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _specialtyController,
              decoration: const InputDecoration(labelText: 'Specialty'),
              validator:
                  (value) => value!.isEmpty ? 'Please enter specialty' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _reasonController,
              decoration: const InputDecoration(labelText: 'Reason for Visit'),
              maxLines: 2,
            ),
            const SizedBox(height: 12),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text("Choose Date"),
              subtitle: Text(
                selectedDate != null
                    ? "${selectedDate!.toLocal()}".split(' ')[0]
                    : "No date selected",
              ),
              trailing: const Icon(Icons.calendar_today),
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 365)),
                );
                if (picked != null) {
                  setState(() {
                    selectedDate = picked;
                  });
                }
              },
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text("Choose Time"),
              subtitle: Text(
                selectedTime != null
                    ? selectedTime!.format(context)
                    : "No time selected",
              ),
              trailing: const Icon(Icons.access_time),
              onTap: () async {
                final picked = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                );
                if (picked != null) {
                  setState(() {
                    selectedTime = picked;
                  });
                }
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
              onPressed: () {
                if (_formKey.currentState!.validate() &&
                    selectedDate != null &&
                    selectedTime != null) {
                  setState(() {
                    upcomingAppointments.add({
                      'doctor': _doctorController.text,
                      'specialty': _specialtyController.text,
                      'date': "${selectedDate!.month}/${selectedDate!.day}",
                      'time': selectedTime!.format(context),
                      'status': 'Pending',
                    });
                    _tabController.animateTo(0); // go to "Upcoming"
                  });

                  _doctorController.clear();
                  _specialtyController.clear();
                  _reasonController.clear();
                  selectedDate = null;
                  selectedTime = null;

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Appointment booked successfully"),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Please complete the form")),
                  );
                }
              },
              child: const Text("Book Appointment"),
            ),
          ],
        ),
      ),
    );
  }
}
