import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PatientAppointmentsPage extends StatelessWidget {
  const PatientAppointmentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final patientId = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(title: const Text("My Appointments")),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('appointments')
            .where('patientId', isEqualTo: patientId)
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No appointments found"));
          }

          final appointments = snapshot.data!.docs;

          return ListView.builder(
            itemCount: appointments.length,
            itemBuilder: (context, index) {
              final data = appointments[index].data() as Map<String, dynamic>;

              // SAFE FALLBACKS
              final doctorName = data['doctorName'] ?? 'Doctor';
              final status = data['status'] ?? 'pending';

              final DateTime date = data['date'] != null
                  ? (data['date'] as Timestamp).toDate()
                  : DateTime.now();

              return Card(
                margin: const EdgeInsets.all(10),
                child: ListTile(
                  title: Text(
                    doctorName,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    "Date: ${date.toLocal().toString().split(' ')[0]}",
                  ),
                  trailing: Text(
                    status.toUpperCase(),
                    style: TextStyle(
                      color: status == 'approved'
                          ? Colors.green
                          : status == 'rejected'
                          ? Colors.red
                          : Colors.orange,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
