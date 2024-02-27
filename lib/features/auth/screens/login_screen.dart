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
  void signIn() {
    ref.read(authControllerProvider.notifier).signInWithGoogle();
    setState(() {
      Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const FetchScreen()));
    });
  }

  void logOut() {
    ref.read(authControllerProvider.notifier).logOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => signIn(),
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
