import 'package:flutter/material.dart';
import 'package:movies_app/core/di/service_locator.dart';
import 'package:movies_app/core/utils/app_colors.dart';
import 'package:movies_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:movies_app/features/auth/presentation/pages/login/login_view.dart';
import 'package:movies_app/features/profile/presentation/pages/update_profile/update_profile_view.dart';

class ProfileTabScreen extends StatelessWidget {
  const ProfileTabScreen({super.key});

  Future<void> _logout(BuildContext context) async {
    try {
      await sl<AuthRepository>().signOut();
      if (context.mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const LoginView()),
          (route) => false,
        );
      }
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Logout failed')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Profile',
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.black,
              ),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const UpdateProfileView(),
                  ),
                );
              },
              child: const Text('Update Profile'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.black,
              ),
              onPressed: () => _logout(context),
              child: const Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}
