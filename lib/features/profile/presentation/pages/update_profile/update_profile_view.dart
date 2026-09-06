import 'package:flutter/material.dart';
import 'package:movies_app/core/utils/app_assets.dart';
import 'package:movies_app/core/utils/app_colors.dart';
import 'package:movies_app/features/profile/presentation/widgets/profile_text_field.dart';
import 'package:movies_app/features/profile/presentation/widgets/profile_button.dart';
import 'package:movies_app/features/profile/presentation/widgets/avatar_picker_bottom_sheet.dart';
import 'package:movies_app/l10n/app_localizations.dart';
import 'package:movies_app/features/profile/domain/repositories/profile_repository.dart';
import 'package:movies_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:movies_app/core/di/service_locator.dart';
import 'package:movies_app/core/errors/failure.dart';
import 'package:movies_app/features/auth/presentation/pages/login/login_view.dart';

class UpdateProfileView extends StatefulWidget {
  const UpdateProfileView({super.key});

  @override
  State<UpdateProfileView> createState() => _UpdateProfileViewState();
}

class _UpdateProfileViewState extends State<UpdateProfileView> {
  int _selectedAvatarIndex = 0;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  bool _isLoading = true;
  String? _currentEmail;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final userData = await sl<ProfileRepository>().getUserData();
      if (userData != null && mounted) {
        String avatarUrl = userData['avatarUrl'] ?? AppAssets.avatars[0];
        int avatarIndex = AppAssets.avatars.indexOf(avatarUrl);
        if (avatarIndex == -1) avatarIndex = 0;

        setState(() {
          _nameController.text = userData['name'] ?? '';
          _phoneController.text = userData['phone'] ?? '';
          _selectedAvatarIndex = avatarIndex;
          _currentEmail = userData['email'];
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _updateProfile() async {
    final name = _nameController.text.trim();
    final phone = _phoneController.text.trim();
    final avatarUrl = AppAssets.avatars[_selectedAvatarIndex];

    try {
      await sl<ProfileRepository>().updateProfile(name, phone, avatarUrl);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile Updated Successfully')),
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

  void _deleteAccount() async {
    try {
      await sl<ProfileRepository>().deleteAccount();
      if (mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const LoginView()),
          (route) => false,
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

  void _resetPassword() async {
    if (_currentEmail != null) {
      try {
        await sl<AuthRepository>().resetPassword(_currentEmail!);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Reset password email sent. Please check your email.',
              ),
            ),
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

  void _onAvatarTap() {
    AvatarPickerBottomSheet.show(
      context,
      avatars: AppAssets.avatars,
      selectedIndex: _selectedAvatarIndex,
      onAvatarSelected: (newIndex) {
        setState(() => _selectedAvatarIndex = newIndex);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    if (_isLoading) {
      return const Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            } else {
              // If we can't pop, we probably came from pushReplacement (Login/Register)
              // Since the user is logged in, we should probably stay or go to Home.
              // For now, let's just do nothing or show a message.
              debugPrint("No screen to go back to.");
            }
          },
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
        ),
        title: Text(
          localizations.updateProfile,
          style: const TextStyle(color: AppColors.primary, fontSize: 20),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            const SizedBox(height: 24),
            GestureDetector(
              onTap: _onAvatarTap,
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CircleAvatar(
                    radius: 70,
                    backgroundColor: AppColors.primary,
                    child: CircleAvatar(
                      radius: 68,
                      backgroundImage: AssetImage(
                        AppAssets.avatars[_selectedAvatarIndex],
                      ),
                    ),
                  ),
                  const CircleAvatar(
                    radius: 18,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.camera_alt,
                      color: Colors.black,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 48),
            ProfileTextField(
              controller: _nameController,
              hintText: localizations.userName,
              prefixIcon: Icons.person,
            ),
            const SizedBox(height: 16),
            ProfileTextField(
              controller: _phoneController,
              hintText: localizations.phoneNumber,
              prefixIcon: Icons.phone,
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton(
                onPressed: _resetPassword,
                style: TextButton.styleFrom(padding: EdgeInsets.zero),
                child: Text(
                  localizations.resetPassword,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 100),
            ProfileButton(
              label: localizations.deleteAccount,
              backgroundColor: AppColors.delete,
              textColor: Colors.white,
              onPressed: _deleteAccount,
            ),
            const SizedBox(height: 16),
            ProfileButton(
              label: localizations.updateData,
              backgroundColor: AppColors.primary,
              textColor: Colors.black,
              onPressed: _updateProfile,
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
