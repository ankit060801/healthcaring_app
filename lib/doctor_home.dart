import 'package:flutter/material.dart';

import 'auth_service.dart';
import 'doctor_appointments_page.dart';
import 'profile_page.dart';

class DoctorHome extends StatelessWidget {
  const DoctorHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Doctor Dashboard"),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ProfilePage()),
            ),
          ),
          IconButton(icon: const Icon(Icons.logout), onPressed: logout),
        ],
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const DoctorAppointmentsPage()),
          ),
          child: const Text("View Appointments"),
        ),
      ),
    );
  }
}
