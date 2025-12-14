import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RolePage extends StatelessWidget {
  const RolePage({super.key});

  Future<void> setRole(String role) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    await FirebaseFirestore.instance.collection('users').doc(uid).update({
      'role': role,
      'approved': role == 'doctor' ? false : true,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Select Role")),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: () => setRole('patient'),
              child: const Text("I am Patient"),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => setRole('doctor'),
              child: const Text("I am Doctor"),
            ),
          ],
        ),
      ),
    );
  }
}
