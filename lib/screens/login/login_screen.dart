// ignore_for_file: body_might_complete_normally_nullable, must_be_immutable, avoid_types_as_parameter_names, use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:isu_corp_test/screens/dashboard/dashboard_screen.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  Duration get loginTime => const Duration(milliseconds: 2250);
  final FirebaseAuth _auth = FirebaseAuth.instance;
  UserCredential? userCredential;

  // Onlogin method to Sign In with Firebase Service
  Future<String?> _onLogin(data) async {
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
  Future<String?> _onSignUp(signUpData) async {
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
      Navigator.of(context).popUntil((route) => route.isFirst);
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FlutterLogin(
      title: 'Tickets',
      logo: const AssetImage('assets/images/logo.jpg'),
      onLogin: (data) => _onLogin(data),
      onSignup: (signupData) => _onSignUp(signupData),
      onSubmitAnimationCompleted: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const DashboardScreen(),
            ));
      },
      onRecoverPassword: (email) {
        resetPassword(email, context);
        return null;
      },
      loginAfterSignUp: false,
      messages: LoginMessages(
        userHint: 'Email',
        passwordHint: 'Password',
        confirmPasswordHint: 'Confirm',
        loginButton: 'LOG IN',
        signupButton: 'REGISTER',
        forgotPasswordButton: 'Forgot your password?',
        recoverPasswordButton: 'HELP ME',
        goBackButton: 'GO BACK',
        confirmPasswordError: 'Not match!',
        recoverPasswordDescription:
            'We send you an email to recover your password',
        recoverPasswordSuccess: 'Password rescued successfully',
      ),
    );
  }
}
