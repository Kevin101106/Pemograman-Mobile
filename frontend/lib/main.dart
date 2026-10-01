import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(const FreshTrackApp());
}

class FreshTrackApp extends StatelessWidget {
  const FreshTrackApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FreshTrack',
      home: const SplashScreen(),
    );
  }
}