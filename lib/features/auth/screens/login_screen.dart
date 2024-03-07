import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ml_project/features/auth/controller/auth_controller.dart';
import 'package:ml_project/models/user_model.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  UserModel? _userModel;

  @override
  void initState() {
    super.initState();
  }

void signIn(WidgetRef ref) {
    ref.read(authControllerProvider.notifier).signInWithGoogle(context);
    setState(() {
      print("done");
    });
  }

  Stream<UserModel> getUserData(String uid) {
    return ref.read(authControllerProvider.notifier).getUserData(uid);
  }

  void logOut() {
    ref.read(authControllerProvider.notifier).logOut();
    _userModel = null;
    setState(() {});
    // _auth.signOut();
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
            _userModel != null
                ? Text(_userModel!.name)
                : ElevatedButton(
                    onPressed: () {
                      signIn(ref);
                      
                    },
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
