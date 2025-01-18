import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ThemedScaffold extends StatelessWidget {
  const ThemedScaffold({
    required this.body,
    this.appBar,
    this.floatingActionButton,
    super.key,
  });

  final Widget body;
  final AppBar? appBar;
  final Widget? floatingActionButton;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      floatingActionButton: floatingActionButton,
      body: Stack(
        children: [
          Positioned.fill(
            child: SvgPicture.asset(
              'assets/themes/background_theme.svg',
              fit: BoxFit.cover,
            ),
          ),
          body,
        ],
      ),
    );
  }
}
