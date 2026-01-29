import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'auth_service.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final nameController = TextEditingController();
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadProfile();
  }

  Future<void> loadProfile() async {
    final user = FirebaseAuth.instance.currentUser!;
    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    final data = doc.data()!;
    nameController.text = data['name'] ?? '';
    setState(() => loading = false);
  }

  Future<void> saveProfile() async {
    final user = FirebaseAuth.instance.currentUser!;

    await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
      'name': nameController.text.trim(),
    });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Profile updated")));
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await logout();
            },
          ),
        ],
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  //  NAME
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: "Name",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // EMAIL (READ ONLY)
                  TextField(
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: "Email",
                      border: const OutlineInputBorder(),
                      hintText: user?.email ?? '',
                    ),
                  ),
                  const SizedBox(height: 16),

                  // ROLE (READ ONLY)
                  StreamBuilder<DocumentSnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('users')
                        .doc(user!.uid)
                        .snapshots(),
                    builder: (context, snap) {
                      if (!snap.hasData) return const SizedBox();
                      final role =
                          (snap.data!.data() as Map<String, dynamic>)['role'] ??
                          '';
                      return Text(
                        "Role: $role",
                        style: const TextStyle(fontSize: 16),
                      );
                    },
                  ),

                  const SizedBox(height: 24),

                  ElevatedButton(
                    onPressed: saveProfile,
                    child: const Text("Save Changes"),
                  ),
                ],
              ),
            ),
    );
  }
}
