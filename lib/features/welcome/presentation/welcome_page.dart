import 'package:flutter/material.dart';
import 'package:thesis_app/app/themed_scaffold.dart';
import 'package:thesis_app/features/widgets/thesis_year.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({
    super.key,
    required this.onPressed,
  });

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ThemedScaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Image.asset(
              height: 148,
              'assets/logos/university_logo.png',
              fit: BoxFit.contain,
            ),
            SizedBox(height: 150),
            Text(
              'KACPER MAJCHER',
              style: TextStyle(
                fontFamily: 'ClashDisplay',
                fontWeight: FontWeight.w600,
                fontSize: 28,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Thesis Defense App',
              style: TextStyle(
                fontFamily: 'ClashDisplay',
                fontSize: 17,
              ),
            ),
            SizedBox(height: 280),
            ThesisYear(onPressed: onPressed),
          ],
        ),
      ),
    );
  }
}
