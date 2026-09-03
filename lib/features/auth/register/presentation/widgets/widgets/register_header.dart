import 'package:flutter/material.dart';

import '../../../../../../core/utils/app_colors.dart';



class RegisterHeader extends StatelessWidget {
  const RegisterHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back,
            color: AppColors.primary
          ),
        ),

        const Expanded(
          child: Center(
            child: Text(
              'Register',
              style: TextStyle(
                color: AppColors.primary,
                fontSize: 16,
              ),
            ),
          ),
        ),

        const SizedBox(width: 50),
      ],
    );
  }
}