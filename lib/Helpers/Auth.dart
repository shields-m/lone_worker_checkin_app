import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';


Future<String> signIn(FirebaseAuth _firebaseAuth, String email, String password) async {

   String _errorMessage = '';


  try {

   FirebaseUser user = await _firebaseAuth
        .signInWithEmailAndPassword(email: email, password: password);

      _errorMessage= user.uid;

  } catch (e) {


      if (Platform.isIOS) {
        _errorMessage = e.details;
      } else
        _errorMessage = e.message;

  }
  return _errorMessage;
}

Future<String> signOut(FirebaseAuth _firebaseAuth) async {
  await _firebaseAuth.signOut();
}

Future<String> sendForgotPasswordEmail(FirebaseAuth _firebaseAuth, String email) async {
  String _errorMessage = '';
  try {
    await _firebaseAuth.sendPasswordResetEmail(
        email: email);

      _errorMessage = "Password reset email sent.";

  } catch (e) {

      if (Platform.isIOS) {
        _errorMessage = e.details;
      } else
        _errorMessage = e.message;

  }

  return _errorMessage;
}

