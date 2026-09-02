import 'package:flutter/material.dart';
import 'package:movies_app/update_screen/profile_screen.dart';
import 'features/auth/register/register_screen.dart';
import 'features/onboarding/presentation/pages/onboarding_view.dart';
import 'forget_password/forget_password.dart';

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