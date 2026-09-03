import 'package:flutter/material.dart';

import '../../../../../../core/utils/app_colors.dart';



class RegisterField extends StatelessWidget {
  final String hint;
  final IconData icon;
  final bool isPassword;

  const RegisterField({
    super.key,
    required this.hint,
    required this.icon,
    this.isPassword = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      margin: const EdgeInsets.only(bottom: 11),
      child: TextField(
        obscureText: isPassword,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 15,
        ),
        decoration: InputDecoration(
          filled: true,
          fillColor: AppColors.textfield,

          hintText: hint,
          hintStyle: const TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),

          prefixIcon: Icon(
            icon,
            color: Colors.white,
            size: 25,
          ),

          suffixIcon: isPassword
              ? const Icon(
            Icons.visibility_off,
            color: Colors.white,
            size: 25,
          )
              : null,

          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}