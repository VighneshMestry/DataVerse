import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:ml_project/models/user_model.dart';

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
      UserCredential userCredential;
      GoogleSignIn _googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      late UserModel? _userModel;

      final googleAuth = await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      userCredential = await _auth.signInWithCredential(credential);

      // UserModel userModel;

      if (userCredential.additionalUserInfo!.isNewUser) {
          _userModel = UserModel(
              name: userCredential.user!.displayName ?? "No Name",
              profilePic: userCredential.user!.photoURL!,
              uid: userCredential.user!.uid,
              isAuthenticated: true,
              subject: []);
        await FirebaseFirestore.instance
            .collection("users")
            .doc(userCredential.user!.uid)
            .set(_userModel.toMap());
      } else {
        _userModel = await getUserData(userCredential.user!.uid).first;
      }
      return _userModel;
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      throw e.toString();
    }
  }

  void logOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }

  Stream<UserModel> getUserData(String uid) {
    return _users.doc(uid).snapshots().map(
        (event) => UserModel.fromMap(event.data() as Map<String, dynamic>));
  }
}
