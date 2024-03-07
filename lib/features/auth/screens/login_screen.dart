import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:ml_project/features/auth/controller/auth_controller.dart';
import 'package:ml_project/features/home/screens/fetch_screen.dart';
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

  void signIn() async {
    try {
      UserCredential userCredential;
      GoogleSignIn _googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      final googleAuth = await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      userCredential = await _auth.signInWithCredential(credential);

      // UserModel userModel;

      if (userCredential.additionalUserInfo!.isNewUser) {
        setState(() {
          _userModel = UserModel(
              name: userCredential.user!.displayName ?? "No Name",
              profilePic: userCredential.user!.photoURL!,
              uid: userCredential.user!.uid,
              isAuthenticated: true,
              subject: []);
        });
        await FirebaseFirestore.instance
            .collection("users")
            .doc(userCredential.user!.uid)
            .set(_userModel!.toMap());
      } else {
        _userModel = await getUserData(userCredential.user!.uid).first;
        setState(() {});
      }
      ref.read(userProvider.notifier).update((state) => _userModel);
      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const FetchScreen()));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      throw e.toString();
    }
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
                      signIn();
                      
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
