import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:isu_corp_test/screens/dashboard/dashboard_screen.dart';
import 'package:isu_corp_test/screens/login/login_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Returning the Dashboard Screen if the user is authenticated (if the
    // idTokenChamges stream hasData)
    return StreamBuilder<User?>(
        stream: FirebaseAuth.instance.idTokenChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return const DashboardScreen();
          }
          return LoginScreen();
        });
  }
}
