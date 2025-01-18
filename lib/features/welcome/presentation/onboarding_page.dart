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
    fontWeight: FontWeight.bold,
    fontSize: 20,
    color: const Color(0xFF605D67),
  );

  final List<Onboarding> _pages = [
    Onboarding(
      title: 'Welcome!',
      description:
          'This application was created as part of my thesis at Andrzej Frycz Modrzewski University in Krakow during the academic year 2024/2025.',
    ),
    Onboarding(
      title: 'Goal',
      description:
          'The goal of the application is to demonstrate the practical use of unit tests through an example of the login functionality in a mobile application.',
    ),
    Onboarding(
      title: 'Who am I?',
      descriptionSpans: [
        const TextSpan(text: 'My name is '),
        TextSpan(
          text: 'Kacper Majcher',
          style: boldStyle,
        ),
        const TextSpan(
          text:
              ', and I am a computer science student at Andrzej Frycz Modrzewski University.',
        ),
      ],
    ),
    Onboarding(
      title: 'Who am I?',
      descriptionSpans: [
        const TextSpan(text: 'I am passionate about '),
        TextSpan(
          text: 'developing mobile applications',
          style: boldStyle,
        ),
        const TextSpan(text: ' and creating efficient, '),
        TextSpan(
          text: 'well-tested systems.',
          style: boldStyle,
        ),
        const TextSpan(
          text:
              ' As part of this project, I decided to combine these interests by designing and implementing the application following the best practices in software engineering.',
        ),
      ],
    ),
    Onboarding(
      title: 'The application',
      descriptionSpans: [
        const TextSpan(
          text: '- An example of the login process using ',
        ),
        TextSpan(
          text: 'Firebase',
          style: boldStyle,
        ),
        const TextSpan(text: '.'),
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
