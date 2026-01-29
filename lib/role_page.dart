import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RolePage extends StatefulWidget {
  const RolePage({super.key});

  @override
  State<RolePage> createState() => _RolePageState();
}

class _RolePageState extends State<RolePage> {
  bool loading = false;

  Future<void> setRole(String role) async {
    if (loading) return;

    setState(() => loading = true);

    final uid = FirebaseAuth.instance.currentUser!.uid;

    await FirebaseFirestore.instance.collection('users').doc(uid).update({
      'role': role,
      'approved': role == 'doctor' ? false : true,
    });
    // AuthGate will redirect automatically
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Select Your Role")),
      body: Center(
        child: loading
            ? const CircularProgressIndicator()
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ElevatedButton(
                    onPressed: () => setRole('patient'),
                    child: const Text("Patient"),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => setRole('doctor'),
                    child: const Text("Doctor"),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => setRole('admin'),
                    child: const Text("Admin"),
                  ),
                ],
              ),
      ),
    );
  }
}
