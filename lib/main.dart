import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'admin_dashboard.dart';
import 'doctor_home.dart';
import 'doctor_waiting_page.dart';
import 'login_page.dart';
import 'patient_home.dart';
import 'role_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true),
      home: const AuthGate(),
    );
  }
}

///
/// 🔐 CENTRAL AUTH + ROLE GATE
///
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, authSnap) {
        // ⏳ Firebase auth loading
        if (authSnap.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // ❌ Not logged in
        if (!authSnap.hasData) {
          return const LoginPage();
        }

        final String uid = authSnap.data!.uid;

        // 🔥 Listen to Firestore user document
        return StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(uid)
              .snapshots(),
          builder: (context, userSnap) {
            // ⏳ Firestore loading
            if (userSnap.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }

            // ❌ User document missing (safety fallback)
            if (!userSnap.hasData || !userSnap.data!.exists) {
              return const LoginPage();
            }

            final data = userSnap.data!.data() as Map<String, dynamic>;

            final String role = data['role'] ?? '';

            // 🆕 First-time user → select role
            if (role.isEmpty) {
              return const RolePage();
            }

            // 🛠 Admin
            if (role == 'admin') {
              return const AdminDashboard();
            }

            // 👨‍⚕️ Doctor flow
            if (role == 'doctor') {
              final bool approved = data['approved'] ?? false;

              if (!approved) {
                return const DoctorWaitingPage();
              }

              return const DoctorHome();
            }

            // 🧑‍🦽 Patient (default)
            return const PatientHome();
          },
        );
      },
    );
  }
}
