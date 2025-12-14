import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'admin_home.dart';
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

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, authSnap) {
        if (authSnap.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (!authSnap.hasData) {
          return const LoginPage();
        }

        final uid = authSnap.data!.uid;

        return StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(uid)
              .snapshots(), // 🔑 STREAM, NOT FUTURE
          builder: (context, userSnap) {
            if (userSnap.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }

            if (!userSnap.hasData || !userSnap.data!.exists) {
              return const LoginPage();
            }

            final data = userSnap.data!.data() as Map<String, dynamic>;
            final role = data['role'] ?? '';

            if (role == '') {
              return const RolePage();
            }

            if (role == 'admin') {
              return const AdminHome();
            }

            if (role == 'doctor') {
              final approved = data['approved'] ?? false;

              if (!approved) {
                return const DoctorWaitingPage();
              }

              return const DoctorHome();
            }
            return const PatientHome();
          },
        );
      },
    );
  }
}
