import 'package:flutter/material.dart';
import '../core/utils/app_colors.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: [

                // Back + Title
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.arrow_back,
                        color: AppColors.primary,
                      ),
                    ),

                    const Expanded(
                      child: Center(
                        child: Text(
                          'Forget Password',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontSize: 17,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 48),
                  ],
                ),

                const SizedBox(height: 30),

                // Image
                Image.asset(
                  'assets/images/forget_password.png',
                  height: 430,
                  width: 430,
                ),

                const SizedBox(height: 35),

                // Email Field
                TextField(
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: AppColors.textfield,

                    hintText: 'Email',
                    hintStyle: const TextStyle(
                      color: Colors.white70,
                      fontSize: 17,
                    ),

                    prefixIcon: const Icon(
                      Icons.email,
                      color: Colors.white,
                      size: 25,
                    ),

                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // Verify Button
                SizedBox(
                  width: double.infinity,
                  height: 45,
                  child: ElevatedButton(
                    onPressed: () {},

                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),

                    child: const Text(
                      'Verify Email',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 17,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}