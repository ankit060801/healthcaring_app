import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'auth_service.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin Dashboard"),
        actions: [
          IconButton(icon: const Icon(Icons.logout), onPressed: () => logout()),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .where('role', isEqualTo: 'doctor')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data!.docs;

          if (docs.isEmpty) {
            return const Center(child: Text("No doctors found"));
          }

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index].data() as Map<String, dynamic>;
              final approved = data['approved'] ?? false;

              return Card(
                margin: const EdgeInsets.all(10),
                child: ListTile(
                  title: Text(data['name'] ?? 'No Name'),
                  subtitle: Text(data['email'] ?? ''),
                  trailing: approved
                      ? const Text(
                          "Approved",
                          style: TextStyle(color: Colors.green),
                        )
                      : ElevatedButton(
                          onPressed: () async {
                            await FirebaseFirestore.instance
                                .collection('users')
                                .doc(docs[index].id)
                                .update({'approved': true});
                          },
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
