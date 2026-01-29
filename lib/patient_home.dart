import 'package:flutter/material.dart';

import 'auth_service.dart';
import 'book_appointment_page.dart';
import 'patient_appointments_page.dart';
import 'profile_page.dart';

class PatientHome extends StatelessWidget {
  const PatientHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Patient Dashboard"),
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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const BookAppointmentPage()),
            ),
            child: const Text("Book Appointment"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const PatientAppointmentsPage(),
              ),
            ),
            child: const Text("My Appointments"),
          ),
        ],
      ),
    );
  }
}
