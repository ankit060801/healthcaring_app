import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool loading = false;
  bool isLogin = true; // toggle login / register

  // 🔹 GOOGLE SIGN-IN (FORCE ACCOUNT CHOOSER EVERY TIME)
  Future<void> signInWithGoogle() async {
    try {
      setState(() => loading = true);

      final GoogleSignIn googleSignIn = GoogleSignIn();

      // FORCE ACCOUNT CHOOSER
      await googleSignIn.signOut();

      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        setState(() => loading = false);
        return;
      }

      final googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCred = await FirebaseAuth.instance.signInWithCredential(
        credential,
      );

      await _createUserIfNotExists(userCred.user!);
    } catch (e) {
      _showError(e.toString());
    } finally {
      setState(() => loading = false);
    }
  }

  // 🔹 EMAIL LOGIN / REGISTER
  Future<void> emailAuth() async {
    try {
      setState(() => loading = true);

      UserCredential userCred;

      if (isLogin) {
        userCred = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );
      } else {
        userCred = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );
      }

      await _createUserIfNotExists(userCred.user!);
    } catch (e) {
      _showError(e.toString());
    } finally {
      setState(() => loading = false);
    }
  }

  // 🔹 CREATE FIRESTORE USER (ONLY FIRST TIME)
  Future<void> _createUserIfNotExists(User user) async {
    final ref = FirebaseFirestore.instance.collection('users').doc(user.uid);

    final doc = await ref.get();

    if (!doc.exists) {
      await ref.set({
        'uid': user.uid,
        'email': user.email,
        'name': user.displayName ?? '',
        'role': '', // 🔑 EMPTY → ROLE PAGE WILL OPEN
        'approved': false,
        'createdAt': FieldValue.serverTimestamp(),
      });
    }
  }

  // 🔹 FORGOT PASSWORD
  Future<void> forgotPassword() async {
    if (emailController.text.isEmpty) {
      _showError("Please enter your email first");
      return;
    }

    await FirebaseAuth.instance.sendPasswordResetEmail(
      email: emailController.text.trim(),
    );

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Password reset email sent")));
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  // 🔹 UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    labelText: "Email",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: "Password",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),

                if (loading)
                  const CircularProgressIndicator()
                else ...[
                  ElevatedButton(
                    onPressed: emailAuth,
                    child: Text(isLogin ? "Login" : "Register"),
                  ),

                  TextButton(
                    onPressed: () => setState(() => isLogin = !isLogin),
                    child: Text(
                      isLogin
                          ? "Create new account"
                          : "Already have an account?",
                    ),
                  ),

                  TextButton(
                    onPressed: forgotPassword,
                    child: const Text("Forgot Password?"),
                  ),

                  const Divider(height: 40),

                  ElevatedButton(
                    onPressed: signInWithGoogle,
                    child: const Text("Sign in with Google"),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
