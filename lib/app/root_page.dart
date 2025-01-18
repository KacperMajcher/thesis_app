import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:thesis_app/features/home/presentation/home_page.dart';
import 'package:thesis_app/features/welcome/presentation/onboarding_page.dart';
import 'package:thesis_app/features/welcome/presentation/welcome_page.dart';

class RootPage extends StatelessWidget {
  const RootPage({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        final user = snapshot.data;
        if (user == null) {
          return WelcomePage(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const OnboardingPage(),
                ),
              );
            },
          );
        }
        return HomePage(user: user);
      },
    );
  }
}
