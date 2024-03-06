import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthenticationService {
  Duration get loginTime => const Duration(milliseconds: 2250);
  final FirebaseAuth _auth = FirebaseAuth.instance;
  UserCredential? userCredential;
  GoogleSignIn _googleSignIn = GoogleSignIn();

  User? _currentUser;

  Future<void> _handleSignIn() async {
    try {
      await _googleSignIn.signIn();
    } catch (error) {
      print('Error al iniciar sesión con Google: $error');
    }
  }

  // Onlogin method to Sign In with Firebase Service
  Future<String?> onLogin(data) async {
    try {
      // Trying to authenticate with email and password
      await _auth.signInWithEmailAndPassword(
          email: data.name, password: data.password);
    } catch (err) {
      // Handling errors of authentication
      return Future.delayed(loginTime).then((_) {
        String message = err.toString();
        if (message.contains('invalid-credential')) {
          message = 'invalid login credentials.';
        }
        return message;
      });
    }
    return null;
  }

  // Onlogin method to Sign Up with Firebase Service
  Future<String?> onSignUp(signUpData) async {
    try {
      // Trying to register a new account with email and password
      userCredential = await _auth.createUserWithEmailAndPassword(
          email: signUpData.name as String,
          password: signUpData.password as String);
    } catch (err) {
      // Handling errors of register
      return Future.delayed(loginTime).then((_) {
        String message = err.toString();
        if (message.contains('email-already-in-use')) {
          message = 'The email address is already in use by another account.';
        } else if (message.contains('weak-password')) {
          message = 'Password should be at least 6 characters.';
        }
        return message;
      });
    }
    return null;
  }

  // Method for reset password funcionality
  Future resetPassword(String email, BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    } catch (e) {}
  }

  LoginProvider onGoogleSignIn() {
    return LoginProvider(
      icon: FontAwesomeIcons.google,
      label: 'Google',
      callback: () async {
        debugPrint('start google sign in');
        try {
          final GoogleSignInAccount? googleAccount =
              await _googleSignIn.signIn();
          final GoogleSignInAuthentication? googleAuth =
              await googleAccount?.authentication;
          // _currentUser = user;
          final credential = GoogleAuthProvider.credential(
              accessToken: googleAuth?.accessToken,
              idToken: googleAuth?.idToken);
          final userCredentials =
              await FirebaseAuth.instance.signInWithCredential(credential);
          _currentUser = userCredentials.user;
          print(googleAuth?.accessToken);
        } catch (error) {
          await Future.delayed(loginTime);
          return 'Error al iniciar sesión con Google: $error';
        }
        if (_currentUser == null) {
          return "Google authentication cancelled";
        } else {
          return null;
        }
      },
    );
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn().signOut();
  }
}
