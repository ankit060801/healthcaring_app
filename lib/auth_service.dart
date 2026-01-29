import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

final GoogleSignIn _googleSignIn = GoogleSignIn();

Future<void> logout() async {
  try {
    await _googleSignIn.signOut();
  } catch (_) {}
  await FirebaseAuth.instance.signOut();
}
