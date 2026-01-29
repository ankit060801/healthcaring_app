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
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AuthGate(),
    );
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    //  Listen ONLY to authentication state
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, authSnap) {
        //  Auth loading
        if (authSnap.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        //  Not logged in
        if (!authSnap.hasData) {
          return const LoginPage();
        }

        final String uid = authSnap.data!.uid;

        //  One-time Firestore fetch (NO stream → NO flicker)
        return FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance.collection('users').doc(uid).get(),
          builder: (context, userSnap) {
            //  Firestore loading
            if (userSnap.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }

            //  Safety fallback
            if (!userSnap.hasData || !userSnap.data!.exists) {
              return const LoginPage();
            }

            final Map<String, dynamic> data =
                userSnap.data!.data() as Map<String, dynamic>;

            final String role = (data['role'] ?? '').toString().trim();

            //  FIRST LOGIN → ROLE DASHBOARD
            if (role.isEmpty) {
              return const RolePage();
            }

            //  ADMIN
            if (role == 'admin') {
              return const AdminDashboard();
            }

            //  DOCTOR (needs approval)
            if (role == 'doctor') {
              final bool approved = data['approved'] ?? false;

              if (!approved) {
                return const DoctorWaitingPage();
              }

              return const DoctorHome();
            }

            //  PATIENT (default)
            return const PatientHome();
          },
        );
      },
    );
  }
}
