import 'package:firebase_auth/firebase_auth.dart';


class AuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String?> register(
      String email,
      String password,
  ) async {

    try {

      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await userCredential.user!
          .sendEmailVerification();

      return null;

    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future<String?> login(
      String email,
      String password,
  ) async {

    try {

      UserCredential credential =
          await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (!credential.user!.emailVerified) {
        await _auth.signOut();
        return "Verify your email first";
      }

      return null;

    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
  }
}