import 'package:flutter/material.dart';
import '../../../../../../core/utils/app_assets.dart';
import '../../../../../../core/utils/app_colors.dart';


class SocialLogin extends StatelessWidget {
  const SocialLogin({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 8),

        const Text(
          'Already Have Account ? login ',
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
          ),
        ),

        const SizedBox(height: 8),



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
                  child: Image.asset(
                    AppAssets.usIcon,
                    height: 25,
                  ),
                ),
                const SizedBox(width: 25),
                Image.asset(
                  AppAssets.egIcon,
                  height: 24,
                ),
                const SizedBox(width: 4),
              ],
            ),
          ),
        ),

        const SizedBox(height: 24),
      ],
    );
  }
}