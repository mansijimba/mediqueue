import 'package:flutter/material.dart';

import 'package:lucide_icons_flutter/lucide_icons.dart';

class MediQueueDashboard extends StatelessWidget {
  const MediQueueDashboard({super.key});

  final List<Map<String, dynamic>> upcomingAppointments = const [
    {
      'doctor': 'Dr. Sarah Johnson',
      'specialty': 'Cardiologist',
      'time': '10:30 AM',
      'date': 'Today',
      'status': 'confirmed',
    },
    {
      'doctor': 'Dr. Michael Chen',
      'specialty': 'Dermatologist',
      'time': '2:15 PM',
      'date': 'Tomorrow',
      'status': 'pending',
    },
    {
      'doctor': 'Dr. Emily Davis',
      'specialty': 'General Practice',
      'time': '9:00 AM',
      'date': 'Dec 15',
      'status': 'confirmed',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE6FFFA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.teal,
              radius: 20,
              child: ClipOval(
                child: Image.asset(
                  'assets/images/logo.png',
                  width: 30,
                  height: 30,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'MediQueue',
                  style: TextStyle(
                    color: Colors.teal,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Healthcare Simplified',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications),
                onPressed: () {},
              ),
              Positioned(
                right: 6,
                top: 6,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: const Text(
                    '3',
                    style: TextStyle(fontSize: 10, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 10),
            const Text(
              "Welcome back, John!",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const Text(
              "Manage your healthcare appointments efficiently",
              style: TextStyle(color: Colors.grey),
            ),

            const SizedBox(height: 20),
            // Search Bar
            TextField(
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: 'Search doctors, specialties, or services...',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 20),
            // Quick Actions
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Quick Actions",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 10),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _quickAction(
                  Icons.calendar_today,
                  "Book Appointment",
                  Colors.teal,
                ),
                _quickAction(Icons.access_time, "Queue Status", Colors.blue),
                _quickAction(Icons.local_hospital, "Find Doctor", Colors.green),
                _quickAction(
                  Icons.folder_shared,
                  "Medical Records",
                  Colors.purple,
                ),
              ],
            ),

            const SizedBox(height: 20),
            // Upcoming Appointments
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  "Upcoming Appointments",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Icon(Icons.add),
              ],
            ),
            const SizedBox(height: 10),
            Column(
              children: upcomingAppointments.map(_appointmentCard).toList(),
            ),

            const SizedBox(height: 20),
            // Health Overview
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Health Overview",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                _statCard("12", "Total Visits", Colors.blue),
                const SizedBox(width: 10),
                _statCard("3", "This Month", Colors.green),
              ],
            ),

            const SizedBox(height: 20),
            // Featured Doctor
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Featured Doctor",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 10),
            Card(
              child: ListTile(
                leading: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    image: const DecorationImage(
                      image: AssetImage(
                        "assets/images/doctor-consultation.png",
                      ),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                title: const Text("Dr. Sarah Johnson"),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Cardiologist • 15 years exp."),
                    Row(
                      children: const [
                        Icon(Icons.star, color: Colors.amber, size: 16),
                        Icon(Icons.star, color: Colors.amber, size: 16),
                        Icon(Icons.star, color: Colors.amber, size: 16),
                        Icon(Icons.star, color: Colors.amber, size: 16),
                        Icon(Icons.star, color: Colors.amber, size: 16),
                        SizedBox(width: 4),
                        Text(
                          "(4.9)",
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                  ],
                ),
                trailing: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                  child: const Text("Book Now"),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _quickAction(IconData icon, String label, Color color) {
    return Card(
      child: InkWell(
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                backgroundColor: color,
                child: Icon(icon, color: Colors.white),
              ),
              const SizedBox(height: 10),
              Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 13),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _appointmentCard(Map<String, dynamic> appointment) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.teal.shade100,
          child: Text(appointment['doctor'].split(' ').map((e) => e[0]).join()),
        ),
        title: Text(appointment['doctor']),
        subtitle: Text(
          "${appointment['specialty']} • ${appointment['date']} at ${appointment['time']}",
        ),
        trailing: Chip(
          label: Text(appointment['status']),
          backgroundColor:
              appointment['status'] == 'confirmed'
                  ? Colors.green[100]
                  : Colors.yellow[100],
          labelStyle: TextStyle(
            color:
                appointment['status'] == 'confirmed'
                    ? Colors.green
                    : Colors.orange,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _statCard(String value, String label, Color color) {
    return Expanded(
      child: Card(
        color: color,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(label, style: const TextStyle(color: Colors.white70)),
            ],
          ),
        ),
      ),
    );
  }
}
