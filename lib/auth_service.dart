import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

final GoogleSignIn googleSignIn = GoogleSignIn();

Future<void> logout() async {
  try {
    // Try aggressive logout (may fail)
    await googleSignIn.disconnect();
  } catch (_) {
    // Ignore error safely
  } finally {
    // Always sign out from Google
    await googleSignIn.signOut();

    // Always sign out from Firebase
    await FirebaseAuth.instance.signOut();
  }
}
