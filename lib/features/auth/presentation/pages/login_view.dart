import 'package:flutter/material.dart';
import '../../../../core/utils/app_assets.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../onboarding/presentation/widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
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
              const CustomTextField(
                hintText: 'Email',
                prefixIcon: Icon(Icons.email, color: AppColors.white),
              ),
              const SizedBox(height: 24),
              const CustomTextField(
                hintText: 'Password',
                obscureText: true,
                prefixIcon: Icon(Icons.lock, color: AppColors.white),
                suffixIcon: Icon(Icons.visibility_off, color: AppColors.white),
              ),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  'Forget Password ?',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              CustomButton(text: 'Login', onPressed: () {}),
              const SizedBox(height: 24),
              Center(
                child: RichText(
                  text: TextSpan(
                    text: 'Don\'t Have Account ? ',
                    style: const TextStyle(color: AppColors.white),
                    children: [
                      TextSpan(
                        text: 'Create One',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),
              const Row(
                children: [
                  Expanded(
                    child: Divider(color: AppColors.primary, endIndent: 10),
                  ),
                  Text('OR', style: TextStyle(color: AppColors.primary)),
                  Expanded(
                    child: Divider(color: AppColors.primary, indent: 10),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: () {},
                icon: Image.asset(AppAssets.googleIcon, height: 24),
                label: const Text('Login With Google'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.black,
                  minimumSize: const Size(double.infinity, 56),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
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
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                        child: Image.asset(AppAssets.usIcon, height: 25),
                      ),
                      const SizedBox(width: 25),
                      Image.asset(AppAssets.egIcon, height: 24),
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
    );
  }
}
