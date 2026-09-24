import 'package:flutter/material.dart';
import 'package:movies_app/core/di/service_locator.dart';
import 'package:movies_app/core/errors/failure.dart';
import 'package:movies_app/core/utils/app_assets.dart';
import 'package:movies_app/core/utils/app_colors.dart';
import 'package:movies_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:movies_app/features/auth/presentation/pages/login/login_view.dart';
import 'package:movies_app/l10n/app_localizations.dart';

import '../domain/profile_repo.dart';
import 'avatar_bottom_sheet.dart';

class ProfileScreen extends StatefulWidget {
  final String currentName;
  final String currentPhone;
  final int currentAvatarIndex;

  const ProfileScreen({
    super.key,
    this.currentName = 'John Safwat',
    this.currentPhone = '01200000000',
    this.currentAvatarIndex = 0,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late int _selectedAvatarIndex;
  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  bool _isLoading = true;
  String? _currentEmail;

  @override
  void initState() {
    super.initState();
    _selectedAvatarIndex = widget.currentAvatarIndex;
    _nameController = TextEditingController(text: widget.currentName);
    _phoneController = TextEditingController(text: widget.currentPhone);
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final userData = await sl<ProfileRepo>().getUserData();
      if (userData != null && mounted) {
        String avatarUrl = userData['avatarUrl'] ?? AppAssets.avatars[0];
        int avatarIndex = AppAssets.avatars.indexOf(avatarUrl);
        if (avatarIndex == -1) avatarIndex = 0;

        setState(() {
          _nameController.text = userData['name'] ?? widget.currentName;
          _phoneController.text = userData['phone'] ?? widget.currentPhone;
          _selectedAvatarIndex = avatarIndex;
          _currentEmail = userData['email'];
          _isLoading = false;
        });
      } else if (mounted) {
        setState(() => _isLoading = false);
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

  void _updateProfile() async {
    final name = _nameController.text.trim();
    final phone = _phoneController.text.trim();
    final avatarIndex = AppAssets.avatars[_selectedAvatarIndex];

    try {
      await sl<ProfileRepo>().updateProfile(
        name: name,
        phone: phone,
        avatarIndex: _selectedAvatarIndex,
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile Updated Successfully')),
        );
        Navigator.pop(context, {
          'name': name,
          'phone': phone,
          'avatarIndex': _selectedAvatarIndex,
        });
      }
    } catch (e) {
      if (mounted) {
        final failure = Failure.fromFirebaseException(e);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(failure.message)),
        );
      }
    }
  }

  void _deleteAccount() async {
    try {
      await sl<ProfileRepo>().deleteAccount();
      if (mounted) {
        Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const LoginView()),
              (route) => false,
        );
      }
    } catch (e) {
      if (mounted) {
        final failure = Failure.fromFirebaseException(e);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(failure.message)),
        );
      }
    }
  }

  void _resetPassword() async {
    if (_currentEmail != null && _currentEmail!.isNotEmpty) {
      try {
        await sl<AuthRepository>().resetPassword(_currentEmail!);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Reset password email sent. Please check your email.'),
              backgroundColor: AppColors.primary,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          final failure = Failure.fromFirebaseException(e);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(failure.message)),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

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
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          localizations?.updateProfile ?? 'Pick Avatar',
          style: const TextStyle(
            color: AppColors.primary,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 20),
            GestureDetector(
              onTap: _onAvatarTap,
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CircleAvatar(
                    radius: 70,
                    backgroundColor: AppColors.black,
                    child: CircleAvatar(
                      radius: 66,
                      backgroundImage: AssetImage(
                        AppAssets.avatars[_selectedAvatarIndex],
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.edit,
                      size: 18,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 35),
            ProfileTextField(
              controller: _nameController,
              hintText: localizations?.userName ?? 'User Name',
              prefixIcon: Icons.person,
            ),
            const SizedBox(height: 16),
            ProfileTextField(
              controller: _phoneController,
              hintText: localizations?.phoneNumber ?? 'Phone Number',
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
                  localizations?.resetPassword ?? 'Reset Password',
                  style: const TextStyle(
                    color: AppColors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
            ProfileButton(
              label: localizations?.deleteAccount ?? 'Delete Account',
              backgroundColor: AppColors.delete,
              textColor: AppColors.white,
              onPressed: _deleteAccount,
            ),
            const SizedBox(height: 14),
            ProfileButton(
              label: localizations?.updateData ?? 'Update Data',
              backgroundColor: AppColors.primary,
              textColor: AppColors.black,
              onPressed: _updateProfile,
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class ProfileTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData prefixIcon;
  final TextInputType keyboardType;

  const ProfileTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.prefixIcon,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      style: const TextStyle(color: AppColors.white, fontSize: 16),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: AppColors.grey),
        prefixIcon: Icon(prefixIcon, color: AppColors.white),
        filled: true,
        fillColor: AppColors.textfield,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

class ProfileButton extends StatelessWidget {
  final String label;
  final Color backgroundColor;
  final Color textColor;
  final VoidCallback onPressed;

  const ProfileButton({
    super.key,
    required this.label,
    required this.backgroundColor,
    required this.textColor,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          elevation: 0,
        ),
        child: Text(
          label,
          style: TextStyle(
            color: textColor,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}