import 'package:flutter/material.dart';

import 'auth_service.dart'; // 👈 IMPORTANT

class DoctorHome extends StatelessWidget {
  const DoctorHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Doctor Dashboard"),

        // 👇 LOGOUT BUTTON IS HERE
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await logout(context);
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
