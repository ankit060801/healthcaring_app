import 'package:flutter/material.dart';

import 'auth_service.dart';
import 'book_appointment.dart'; // 👈 ADD THIS

class PatientHome extends StatelessWidget {
  const PatientHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Patient Dashboard"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await logout(context);
            },
          ),
        ],
      ),

      // 👇 BODY UPDATED HERE
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Welcome Patient 🧑‍🦽", style: TextStyle(fontSize: 22)),
            const SizedBox(height: 30),

            ElevatedButton.icon(
              icon: const Icon(Icons.calendar_today),
              label: const Text("Book Appointment"),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const BookAppointment()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
