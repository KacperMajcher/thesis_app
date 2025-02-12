import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:thesis_app/app/app.dart';
import 'package:thesis_app/dependencies/injection_container.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  configureDependencies();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const App());
}
