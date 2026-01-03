import 'package:flutter/material.dart';

import 'auth_service.dart';

class DoctorWaitingPage extends StatelessWidget {
  const DoctorWaitingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Approval Pending"),
        actions: [
          IconButton(icon: const Icon(Icons.logout), onPressed: () => logout()),
        ],
      ),
      body: const Center(
        child: Text(
          "⏳ Your account is waiting for admin approval",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
