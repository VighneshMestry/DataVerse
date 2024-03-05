import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ml_project/features/auth/controller/auth_controller.dart';
import 'package:ml_project/features/home/screens/fetch_screen.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;

  @override
  void initState() {
    super.initState();
    _auth.authStateChanges().listen((event) {
      setState(() {
        _user = event;
      });
    });
  }

  void signIn() {
    ref.read(authControllerProvider.notifier).signInWithGoogle();
    setState(() {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => const FetchScreen()));
    });
  }

  void logOut() {
    // ref.read(authControllerProvider.notifier).logOut();
    _auth.signOut();
  }

  void signInWithGoogle() async {
    try {
      GoogleAuthProvider _googleAuthProvider = GoogleAuthProvider();
      _auth.signInWithProvider(_googleAuthProvider);
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _user != null ? Text(_user!.displayName!) : ElevatedButton(
              onPressed: () => signInWithGoogle(),
              child: Text("Login"),
            ),
            ElevatedButton(
              onPressed: () => logOut(),
              child: Text("Logout"),
            ),
          ],
        ),
      ),
    );
  }
}
