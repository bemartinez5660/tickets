// ignore_for_file: body_might_complete_normally_nullable, must_be_immutable, avoid_types_as_parameter_names, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:isu_corp_test/screens/dashboard/dashboard_screen.dart';
import 'package:isu_corp_test/services/authentication/authentication_service.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FlutterLogin(
      title: 'Tickets',
      logo: const AssetImage('assets/images/logo.jpg'),
      onLogin: (data) => AuthenticationService().onLogin(data),
      onSignup: (signupData) => AuthenticationService().onSignUp(signupData),
      loginProviders: <LoginProvider>[
        AuthenticationService().onGoogleSignIn(),
      ],
      onSubmitAnimationCompleted: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const DashboardScreen(),
            ));
      },
      onRecoverPassword: (email) {
        AuthenticationService().resetPassword(email, context);
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
