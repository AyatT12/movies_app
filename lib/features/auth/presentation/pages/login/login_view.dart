import 'package:flutter/material.dart';
import 'package:movies_app/core/utils/app_assets.dart';
import 'package:movies_app/core/utils/app_colors.dart';
import 'package:movies_app/features/onboarding/presentation/widgets/custom_button.dart';
import 'package:movies_app/features/auth/presentation/widgets/auth_text_field.dart';
import 'package:movies_app/features/auth/presentation/pages/register/register_view.dart';
import 'package:movies_app/features/auth/presentation/pages/forget_password/forget_password_view.dart';
import 'package:movies_app/l10n/app_localizations.dart';
import 'package:movies_app/features/auth/presentation/widgets/social_login.dart';
import 'package:movies_app/features/profile/presentation/pages/update_profile/update_profile_view.dart';
import 'package:movies_app/core/di/service_locator.dart';
import 'package:movies_app/core/errors/failure.dart';
import 'package:movies_app/features/auth/domain/repositories/auth_repository.dart';

import '../../../../home_screen/presentation/screens/home_view.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    if (email.isNotEmpty && password.isNotEmpty) {
      try {
        await sl<AuthRepository>().signIn(email, password);
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomeView()),
          );
        }
      } catch (e) {
        if (mounted) {
          final failure = Failure.fromFirebaseException(e);
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(failure.message)));
        }
      }
    }
  }

  void _loginWithGoogle() async {
    try {
      await sl<AuthRepository>().signInWithGoogle();
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeView()),
        );
      }
    } catch (e) {
      if (mounted) {
        final failure = Failure.fromFirebaseException(e);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(failure.message)));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final bool isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 80),
              Center(child: Image.asset(AppAssets.logo, height: 150)),
              const SizedBox(height: 48),
              AuthTextField(
                controller: _emailController,
                hintText: localizations.email,
                prefixIcon: Icons.email,
              ),
              const SizedBox(height: 24),
              AuthTextField(
                controller: _passwordController,
                hintText: localizations.password,
                obscureText: true,
                prefixIcon: Icons.lock,
                suffixIcon: const Icon(
                  Icons.visibility_off,
                  color: AppColors.white,
                ),
              ),
              const SizedBox(height: 16),
              Align(
                alignment: isArabic
                    ? Alignment.centerLeft
                    : Alignment.centerRight,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ForgetPasswordView(),
                      ),
                    );
                  },
                  child: Text(
                    localizations.forgetPassword,
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              CustomButton(text: localizations.login, onPressed: _login),
              SocialLogin(
                onGoogleLogin: _loginWithGoogle,
                onSwitch: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const RegisterView(),
                    ),
                  );
                },
                isLogin: true,
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
