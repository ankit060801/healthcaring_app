import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AppointmentPage extends StatelessWidget {
  const AppointmentPage({super.key});

  Future<void> bookAppointment() async {
    final user = FirebaseAuth.instance.currentUser!;

    await FirebaseFirestore.instance
        .collection('appointments')
        .add({
      'patientId': user.uid,
      'patientName': user.displayName ?? '',
      'doctorId': 'doctor_uid_here', // later dynamic
      'date': DateTime.now(),
      'status': 'pending',
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Book Appointment")),
      body: Center(
        child: ElevatedButton(
          onPressed: bookAppointment,
          child: const Text("Book Appointment"),
        ),
      ),
    );
  }
}
