import 'package:flutter/material.dart';

import 'features/forget_password/presentetion/forget_password.dart';


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
      home:  ForgotPasswordScreen(),
    );
  }
}
