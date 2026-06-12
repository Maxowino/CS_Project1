import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // REGISTER
  Future<String?> register({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential user =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await user.user!.sendEmailVerification();

      await _firestore
          .collection("users")
          .doc(user.user!.uid)
          .set({
        "email": email,
        "verified": false,
        "createdAt": Timestamp.now(),
      });

      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  // LOGIN
  Future<String?> login({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential user =
          await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      await user.user!.reload();

      if (!user.user!.emailVerified) {
        await _auth.signOut();

        return "Verify your email first";
      }

      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future logout() async {
    await _auth.signOut();
  }
}