import 'package:flutter/material.dart';
import 'package:movies_app/core/utils/app_assets.dart';
import 'package:movies_app/core/utils/app_colors.dart';
import 'package:movies_app/features/auth/presentation/widgets/avatar_section.dart';
import 'package:movies_app/features/auth/presentation/widgets/auth_text_field.dart';
import 'package:movies_app/features/auth/presentation/widgets/auth_header.dart';
import 'package:movies_app/features/onboarding/presentation/widgets/custom_button.dart';
import 'package:movies_app/l10n/app_localizations.dart';
import 'package:movies_app/main.dart';
import 'package:movies_app/core/di/service_locator.dart';
import 'package:movies_app/core/errors/failure.dart';
import 'package:movies_app/features/auth/domain/repositories/auth_repository.dart';

import '../../../../home_screen/presentation/screens/home_view.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _phoneController = TextEditingController();
  int _selectedAvatarIndex = 0;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _register() async {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final phone = _phoneController.text.trim();
    final avatarUrl = AppAssets.avatars[_selectedAvatarIndex];

    if (name.isNotEmpty && email.isNotEmpty && password.isNotEmpty) {
      try {
        await sl<AuthRepository>().signUp(
          email,
          password,
          name,
          phone,
          avatarUrl,
        );
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
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                AuthHeader(title: localizations.register),
                AvatarSection(
                  selectedIndex: _selectedAvatarIndex,
                  onAvatarSelected: (index) {
                    setState(() {
                      _selectedAvatarIndex = index;
                    });
                  },
                ),
                const SizedBox(height: 24),
                AuthTextField(
                  controller: _nameController,
                  hintText: localizations.name,
                  prefixIcon: Icons.person_outline,
                ),
                const SizedBox(height: 16),
                AuthTextField(
                  controller: _emailController,
                  hintText: localizations.email,
                  prefixIcon: Icons.email,
                ),
                const SizedBox(height: 16),
                AuthTextField(
                  controller: _passwordController,
                  hintText: localizations.password,
                  prefixIcon: Icons.lock,
                  obscureText: true,
                ),
                const SizedBox(height: 16),
                AuthTextField(
                  controller: _confirmPasswordController,
                  hintText: localizations.confirmPassword,
                  prefixIcon: Icons.lock,
                  obscureText: true,
                ),
                const SizedBox(height: 16),
                AuthTextField(
                  controller: _phoneController,
                  hintText: localizations.phoneNumber,
                  prefixIcon: Icons.phone,
                ),
                const SizedBox(height: 32),
                CustomButton(
                  text: localizations.createAccount,
                  onPressed: _register,
                ),
                const SizedBox(height: 32),
                Center(
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.primary),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        GestureDetector(
                          onTap: () =>
                              MyApp.setLocale(context, const Locale('en')),
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: !isArabic
                                  ? AppColors.primary
                                  : Colors.transparent,
                              shape: BoxShape.circle,
                            ),
                            child: Image.asset(AppAssets.usIcon, height: 25),
                          ),
                        ),
                        const SizedBox(width: 25),
                        GestureDetector(
                          onTap: () =>
                              MyApp.setLocale(context, const Locale('ar')),
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: isArabic
                                  ? AppColors.primary
                                  : Colors.transparent,
                              shape: BoxShape.circle,
                            ),
                            child: Image.asset(AppAssets.egIcon, height: 24),
                          ),
                        ),
                        const SizedBox(width: 4),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
