import 'package:flutter/material.dart';
import 'features/home_screen/presentation/screens/home_view.dart';
import 'features/onboarding/presentation/pages/onboarding_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Movies App',
      home: const MainNavigationScreen(),
    );
  }
}
