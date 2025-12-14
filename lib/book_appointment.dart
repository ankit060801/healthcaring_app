import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class BookAppointment extends StatefulWidget {
  const BookAppointment({super.key});

  @override
  State<BookAppointment> createState() => _BookAppointmentState();
}

class _BookAppointmentState extends State<BookAppointment> {
  bool loading = false;

  Future<void> bookAppointment() async {
    setState(() => loading = true);

    await FirebaseFirestore.instance.collection('appointments').add({
      'patientId': FirebaseAuth.instance.currentUser!.uid,
      'status': 'pending',
      'createdAt': FieldValue.serverTimestamp(),
    });

    setState(() => loading = false);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Appointment booked successfully")),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Book Appointment")),
      body: Center(
        child: loading
            ? const CircularProgressIndicator()
            : ElevatedButton(
                onPressed: bookAppointment,
                child: const Text("Confirm Appointment"),
              ),
      ),
    );
  }
}
