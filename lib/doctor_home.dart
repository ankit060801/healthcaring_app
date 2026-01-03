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
          // 👤 PROFILE BUTTON
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ProfilePage()),
              );
            },
          ),
          ElevatedButton(
            child: const Text("View Appointments"),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const DoctorAppointmentsPage(),
                ),
              );
            },
          ),

          // 🚪 LOGOUT BUTTON
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await logout();
            },
          ),
        ],
      ),
      body: const Center(
        child: Text("Welcome Doctor 👨‍⚕️", style: TextStyle(fontSize: 22)),
      ),
    );
  }
}
