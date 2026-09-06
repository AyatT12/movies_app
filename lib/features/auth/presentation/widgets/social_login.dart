import 'package:flutter/material.dart';
import 'package:movies_app/core/utils/app_assets.dart';
import 'package:movies_app/core/utils/app_colors.dart';
import 'package:movies_app/l10n/app_localizations.dart';

class SocialLogin extends StatelessWidget {
  final VoidCallback onGoogleLogin;
  final VoidCallback? onSwitch;
  final bool isLogin;

  const SocialLogin({
    super.key,
    required this.onGoogleLogin,
    this.onSwitch,
    this.isLogin = true,
  });

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Column(
      children: [
        const SizedBox(height: 32),
        ElevatedButton.icon(
          onPressed: onGoogleLogin,
          icon: Image.asset(AppAssets.googleIcon, height: 24),
          label: Text(localizations.loginWithGoogle),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.black,
            minimumSize: const Size(double.infinity, 56),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              isLogin
                  ? localizations.dontHaveAccount
                  : localizations.alreadyHaveAccount,
              style: const TextStyle(color: AppColors.white),
            ),
            GestureDetector(
              onTap: onSwitch ?? () => Navigator.pop(context),
              child: Text(
                isLogin ? localizations.register : localizations.login,
                style: const TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}
