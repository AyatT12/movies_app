import 'package:flutter/material.dart';

import 'features/auth/register/presentation/pages/register_screen.dart';
import 'features/forget_password/presentetion/forget_password.dart';
import 'features/onboarding/presentation/pages/onboarding_view.dart';
import 'features/update_screen/presentation/profile_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Movies App',
      home: RegisterScreen(),
    );
  }
}