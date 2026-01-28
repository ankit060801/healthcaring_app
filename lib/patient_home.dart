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
          // PROFILE
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ProfilePage()),
              );
            },
          ),

          // LOGOUT
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await logout();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Text("Welcome Patient 🧑‍🦽", style: TextStyle(fontSize: 22)),
            const SizedBox(height: 30),

            // BOOK APPOINTMENT
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const BookAppointmentPage(),
                  ),
                );
              },
              child: const Text("Book Appointment"),
            ),

            const SizedBox(height: 16),

            //APPOINTMENT HISTORY
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const PatientAppointmentsPage(),
                  ),
                );
              },
              child: const Text("My Appointments"),
            ),
          ],
        ),
      ),
    );
  }
}
