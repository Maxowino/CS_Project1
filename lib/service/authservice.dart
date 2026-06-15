import 'dart:convert';
import 'package:crypto/crypto.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth =
      FirebaseAuth.instance;

  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  // hash password 
  String hashPassword(String password) {
    return sha256
        .convert(
          utf8.encode(password),
        )
        .toString();
  }

  // REGISTER
  Future<String?> register({
    required String email,
    required String password,
  }) async {
    try {

      UserCredential user =
          await _auth
              .createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // send verification email
      await user.user?.sendEmailVerification();

      // store user profile
      await _firestore
          .collection("users")
          .doc(user.user!.uid)
          .set({

        "email": email,
               "hashedPassword":
                   hashPassword(password),

                   "verified": false,
                   "createdAt":
                   Timestamp.now(),
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
                      await user.user?.reload();
                 if (!(user.user?.emailVerified ?? false)) {
                  await _auth.signOut();
                  return "Verify your email first";
                     }

      // update firestore i
      await _firestore
          .collection("users")
          .doc(user.user!.uid)
          .update({
        "verified": true,
      });

      return null;

    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  // LOGOUT
  Future<void> logout() async {
    await _auth.signOut();
  }
}