import 'package:flutter/material.dart';

class Onboarding {
  final String title;
  final String? description;
  final List<InlineSpan>? descriptionSpans;

  Onboarding({
    required this.title,
    this.description,
    this.descriptionSpans,
  });
}
