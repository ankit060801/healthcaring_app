import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'google_auth.dart';

Future<void> logout(BuildContext context) async {
  try {
    await googleSignIn.disconnect(); // force email chooser
    await FirebaseAuth.instance.signOut();
  } catch (e) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text("Logout failed: $e")));
  }
}
