import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:ml_project/models/user_model.dart';

final userProvider = StateProvider<UserModel?>((ref) => null);

final authRepositoryProvider = Provider(
  (ref) => AuthRepository(
      firestore: FirebaseFirestore.instance,
      auth: FirebaseAuth.instance,
      googleSignIn: GoogleSignIn(),),
);

class AuthRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  final GoogleSignIn _googleSignIn;

  AuthRepository({
    required FirebaseFirestore firestore,
    required FirebaseAuth auth,
    required GoogleSignIn googleSignIn,
  })  : _auth = auth,
        _firestore = firestore,
        _googleSignIn = googleSignIn;

  CollectionReference get _users => _firestore.collection("users");

  Stream<User?> get authStateChange => _auth.authStateChanges();

  Future<UserModel> signInWithGoogle() async {
    try {
      print("1111111111111111111111111111111111111111111111111111");
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      final googleAuth = await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      UserCredential userCredential =
          await _auth.signInWithCredential(credential);

      UserModel userModel;
      print("2222222222222222222222222222222222222222222222222222222222222222222");
      if (userCredential.additionalUserInfo!.isNewUser) {
        userModel = UserModel(
          name: userCredential.user!.displayName ?? "No Name",
          profilePic: "",
          uid: userCredential.user!.uid,
          isAuthenticated: true,
          subject: [],
        );
        print("33333333333333333333333333333333333333333333333333333333333333333333333333333");
        await _users.doc(userCredential.user!.uid).set(userModel.toMap());
      } else {
        print("444444444444444444444444444444444444444444444444444444444444444");
        userModel = await getUserData(userCredential.user!.uid).first;
        print("666666666666666666666666666666666666666666666666666666666666");
      }
      return userModel;
    } catch (e) {
      throw e.toString();
    }
  }

  void logOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }

  Stream<UserModel> getUserData(String uid) {
    print("55555555555555555555555555555555555555555555555555555555555555555555555");
    return _users.doc(uid).snapshots().map(
        (event) => UserModel.fromMap(event.data() as Map<String, dynamic>));
  }
}
