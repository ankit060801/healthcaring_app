import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'auth_service.dart';

class AdminHome extends StatelessWidget {
  const AdminHome({super.key});

  Future<void> approveDoctor(String uid) async {
    await FirebaseFirestore.instance.collection('users').doc(uid).update({
      'approved': true,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin Approval Panel"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => logout(context),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .where('role', isEqualTo: 'doctor')
            .where('approved', isEqualTo: false)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data!.docs;

          if (docs.isEmpty) {
            return const Center(child: Text("No doctors waiting for approval"));
          }

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index].data() as Map<String, dynamic>;

              return Card(
                margin: const EdgeInsets.all(10),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(data['photo']),
                  ),
                  title: Text(data['name']),
                  subtitle: Text(data['email']),
                  trailing: ElevatedButton(
                    onPressed: () => approveDoctor(docs[index].id),
                    child: const Text("Approve"),
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
