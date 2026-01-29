import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DoctorAppointmentsPage extends StatelessWidget {
  const DoctorAppointmentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final doctorId = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(title: const Text("Appointments")),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('appointments')
            .where('doctorId', isEqualTo: doctorId)
            .snapshots(),
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snap.hasData || snap.data!.docs.isEmpty) {
            return const Center(child: Text("No appointments"));
          }

          return ListView(
            children: snap.data!.docs.map((doc) {
              final data = doc.data() as Map<String, dynamic>;
              return ListTile(
                title: Text(data['patientName']),
                subtitle: Text(data['status']),
                trailing: IconButton(
                  icon: const Icon(Icons.check),
                  onPressed: () => doc.reference.update({'status': 'approved'}),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
