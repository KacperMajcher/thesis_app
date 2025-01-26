import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:thesis_app/app/themed_scaffold.dart';
import 'package:thesis_app/features/auth/presentation/login_page.dart';
import 'package:thesis_app/features/widgets/custom_button.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
    required this.user,
  });

  @override
  HomePageState createState() => HomePageState();
  final User user;
}

class HomePageState extends State<HomePage> {
  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut();
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ThemedScaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 60),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              children: [
                Image.asset(
                  'assets/logos/university_logo.png',
                  height: 60,
                  fit: BoxFit.contain,
                ),
                Expanded(
                  child: Text(
                    'KACPER MAJCHER',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamily: 'ClashDisplay',
                      fontWeight: FontWeight.w400,
                      fontSize: 18,
                    ),
                  ),
                ),
                const SizedBox(width: 60),
              ],
            ),
          ),
          Spacer(),
          Text(
            '${widget.user.displayName}, You logged into your account successfully!',
            style: GoogleFonts.inter(fontSize: 20),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20),
          SvgPicture.asset(
            'assets/icons/check.svg',
          ),
          SizedBox(height: 70),
          Image.asset('assets/icons/graduation.png'),
          const Spacer(),
          CustomButton(
            text: 'Log out',
            onPressed: () {
              _logout();
            },
          ),
          const SizedBox(height: 15),
          const SizedBox(height: 50),
        ],
      ),
    );
  }
}
