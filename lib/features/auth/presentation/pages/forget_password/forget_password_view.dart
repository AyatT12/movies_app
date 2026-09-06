import 'package:flutter/material.dart';
import 'package:movies_app/core/utils/app_colors.dart';
import 'package:movies_app/features/auth/presentation/widgets/auth_header.dart';
import 'package:movies_app/features/auth/presentation/widgets/auth_text_field.dart';
import 'package:movies_app/features/onboarding/presentation/widgets/custom_button.dart';
import 'package:movies_app/l10n/app_localizations.dart';
import 'package:movies_app/features/auth/data/repositories/auth_repository_impl.dart';

class ForgetPasswordView extends StatefulWidget {
  const ForgetPasswordView({super.key});

  @override
  State<ForgetPasswordView> createState() => _ForgetPasswordViewState();
}

class _ForgetPasswordViewState extends State<ForgetPasswordView> {
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _resetPassword() async {
    final email = _emailController.text.trim();
    if (email.isNotEmpty) {
      try {
        await AuthRepositoryImpl().resetPassword(email);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Password reset email sent')),
          );
          Navigator.pop(context);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(e.toString())));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              children: [
                AuthHeader(title: localizations.forgetPassword),
                const SizedBox(height: 30),
                Image.asset(
                  'assets/images/forget_password.png',
                  height: 300,
                  width: double.infinity,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 48),
                AuthTextField(
                  controller: _emailController,
                  hintText: localizations.email,
                  prefixIcon: Icons.email,
                ),
                const SizedBox(height: 24),
                CustomButton(
                  text: localizations.verifyEmail,
                  onPressed: _resetPassword,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
