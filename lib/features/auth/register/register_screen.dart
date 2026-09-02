import 'package:flutter/material.dart';


import '../../../core/utils/app_colors.dart';
import '../widgets/register_header.dart';
import '../widgets/avatar_section.dart';
import '../widgets/register_field.dart';
import '../widgets/create_account_button.dart';
import '../widgets/social_login.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 9,
          ),

          child: Column(
            children: [

              // Header
              const RegisterHeader(),

              // Avatars
              const AvatarSection(),

              const SizedBox(height: 12),

              // Fields
              const RegisterField(
                hint: 'Name',
                icon: Icons.person_outline,
              ),

              const RegisterField(
                hint: 'Email',
                icon: Icons.email,
              ),

              const RegisterField(
                hint: 'Password',
                icon: Icons.lock,
                isPassword: true,
              ),

              const RegisterField(
                hint: 'Confirm Password',
                icon: Icons.lock,
                isPassword: true,
              ),

              const RegisterField(
                hint: 'Phone Number',
                icon: Icons.phone,
              ),

              const SizedBox(height: 2),

              // Button
              const CreateAccountButton(),

              // Login
              const SocialLogin(),
            ],
          ),
        ),
      ),
    );
  }
}
