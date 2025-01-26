import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:thesis_app/app/themed_scaffold.dart';
import 'package:thesis_app/features/auth/presentation/login_page.dart';
import 'package:thesis_app/features/welcome/domain/models/onboarding.dart';
import 'package:thesis_app/features/widgets/thesis_year.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  void _onNextPressed(BuildContext context) {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const LoginPage(),
        ),
      );
    }
  }

  static final TextStyle boldStyle = GoogleFonts.inter(
    fontWeight: FontWeight.w600,
    fontSize: 20,
    color: const Color(0xFF605D67),
  );

  final List<Onboarding> _pages = [
    Onboarding(
      title: 'Welcome!',
      descriptionSpans: [
        TextSpan(
          children: [
            const TextSpan(
              text: 'This application was created as part of my thesis at ',
            ),
            TextSpan(
              text: 'Andrzej Frycz Modrzewski University ',
              style: boldStyle,
            ),
            const TextSpan(
              text: 'in ',
            ),
            TextSpan(
              text: 'Krakow ',
              style: boldStyle,
            ),
            const TextSpan(
              text: 'during the academic year ',
            ),
            TextSpan(
              text: '2024/2025.',
              style: boldStyle,
            ),
          ],
        ),
      ],
    ),
    Onboarding(
      title: 'Goal',
      descriptionSpans: [
        TextSpan(
          children: [
            const TextSpan(
              text:
                  'The goal of the application is to demonstrate the practical use of ',
            ),
            TextSpan(
              text: 'unit tests ',
              style: boldStyle,
            ),
            const TextSpan(
              text: 'through an example of the ',
            ),
            TextSpan(
              text: 'login functionality ',
              style: boldStyle,
            ),
            const TextSpan(
              text: 'in a mobile application.',
            ),
          ],
        ),
      ],
    ),
    Onboarding(
      title: 'About the author',
      descriptionSpans: [
        TextSpan(
          children: [
            TextSpan(
              text: 'Kacper Majcher ',
              style: boldStyle,
            ),
            const TextSpan(
              text: '- a passionate ',
            ),
            TextSpan(
              text: 'Flutter mobile app developer ',
              style: boldStyle,
            ),
            const TextSpan(
              text: 'and a student of ',
            ),
            TextSpan(
              text: 'Computer Science and Econometrics ',
              style: boldStyle,
            ),
            const TextSpan(
              text: 'with a specialization in ',
            ),
            TextSpan(
              text: 'Information Security ',
              style: boldStyle,
            ),
            const TextSpan(
              text: 'at ',
            ),
            TextSpan(
              text: 'Andrzej Frycz Modrzewski University ',
              style: boldStyle,
            ),
            const TextSpan(
              text: 'in ',
            ),
            TextSpan(
              text: 'Krakow.',
              style: boldStyle,
            ),
          ],
        ),
      ],
    ),
    Onboarding(title: 'The Application', descriptionSpans: [
      TextSpan(
        children: [
          TextSpan(
            text: 'Is an excellent example ',
            style: boldStyle,
          ),
          const TextSpan(
            text: 'of how to prepare and enhance the ',
          ),
          TextSpan(
            text: 'login flow ',
            style: boldStyle,
          ),
          const TextSpan(
            text: 'of a mobile application using unit tests.',
          ),
          const TextSpan(
            text: '\n\n',
          ),
          TextSpan(
            text: 'User authentication ',
            style: boldStyle,
          ),
          const TextSpan(
            text:
                'is based on the Firebase database, which is a popular approach among ',
          ),
          TextSpan(
            text: 'Flutter developers.',
            style: boldStyle,
          ),
        ],
      ),
    ]),
    Onboarding(
      title: 'Tools Used',
      descriptionSpans: [
        TextSpan(
          style: const TextStyle(height: 1.75),
          children: [
            const TextSpan(
              text: 'Framework: ',
            ),
            TextSpan(
              text: 'Flutter\n',
              style: boldStyle,
            ),
            const TextSpan(
              text: 'Programming Language: ',
            ),
            TextSpan(
              text: 'Dart\n',
              style: boldStyle,
            ),
            const TextSpan(
              text: 'Backend Service: ',
            ),
            TextSpan(
              text: 'Firebase\n',
              style: boldStyle,
            ),
            const TextSpan(
              text: 'Packages: ',
            ),
            TextSpan(
              text: 'flutter_bloc, injectable, get_it, freezed, mocktail ',
              style: boldStyle,
            ),
            const TextSpan(
              text: 'and others.',
            ),
          ],
        ),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ThemedScaffold(
      body: Column(
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
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: _pages.length,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              itemBuilder: (context, index) {
                final item = _pages[index];
                return _buildPage(
                  title: item.title,
                  description: item.description,
                  descriptionSpans: item.descriptionSpans,
                );
              },
            ),
          ),
          ThesisYear(
            onPressed: () => _onNextPressed(context),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                SmoothPageIndicator(
                  controller: _pageController,
                  count: _pages.length,
                  effect: const ExpandingDotsEffect(
                    dotHeight: 10,
                    dotWidth: 10,
                    activeDotColor: Color(0xFF006089),
                    expansionFactor: 3,
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPage({
    required String title,
    String? description,
    List<InlineSpan>? descriptionSpans,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: GoogleFonts.montserrat(
              fontWeight: FontWeight.bold,
              fontSize: 36,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),
          if (descriptionSpans != null)
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w400,
                  fontSize: 20,
                  color: const Color(0xFF605D67),
                ),
                children: descriptionSpans,
              ),
            )
          else if (description != null)
            Text(
              description,
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w400,
                color: const Color(0xFF605D67),
                fontSize: 20,
              ),
              textAlign: TextAlign.center,
            ),
        ],
      ),
    );
  }
}
