import 'package:flutter/material.dart';

class ThesisYear extends StatelessWidget {
  const ThesisYear({
    super.key,
    required this.onPressed,
  });
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '2024/2025',
                style: TextStyle(
                  fontFamily: 'ClashDisplay',
                  fontWeight: FontWeight.w500,
                  fontSize: 17,
                  color: Color(0xFF006089),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          right: 25,
          top: 5,
          child: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.black,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: Icon(
                Icons.arrow_forward_ios,
                color: Colors.white,
              ),
              onPressed: onPressed,
            ),
          ),
        ),
      ],
    );
  }
}
