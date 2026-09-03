import 'package:flutter/material.dart';
import 'package:movies_app/core/utils/app_assets.dart';
import 'package:movies_app/features/update_screen/presentation/text_field.dart';

import '../../../core/utils/app_colors.dart';

import 'avatar_bottom_sheet.dart';
import 'button.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final List<String> _avatars = List.generate(
    9,
    (index) => 'assets/images/avatar_${index + 1}.png',
  );

  int _selectedAvatarIndex = 0;
  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: 'John Safwat');
    _phoneController = TextEditingController(text: '01200000000');
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
      avatars: _avatars,
      selectedIndex: _selectedAvatarIndex,
      onAvatarSelected: (newIndex) {
        setState(() => _selectedAvatarIndex = newIndex);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const Icon(Icons.arrow_back, color: AppColors.primary),
        title: const Text(
          'Pick Avatar',
          style: TextStyle(color: AppColors.primary, fontSize: 20),
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
              child: CircleAvatar(
                radius: 65,
                backgroundColor: AppColors.black,
                child: CircleAvatar(
                  radius: 70,
                  backgroundImage: AssetImage(
                    AppAssets.avatars[_selectedAvatarIndex],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 35),
            CustomTextField(
              controller: _nameController,
              hint: 'User Name',
              prefixIcon: Icons.person,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              controller: _phoneController,
              hint: 'Phone Number',
              prefixIcon: Icons.phone,
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(padding: EdgeInsets.zero),
                child: const Text(
                  'Reset Password',
                  style: TextStyle(color: Colors.white, fontSize: 17),
                ),
              ),
            ),

            const SizedBox(height: 250),
            PrimaryButton(
              label: 'Delete Account',
              backgroundColor: AppColors.delete,
              textColor: Colors.white,
              onPressed: () {},
            ),
            const SizedBox(height: 14),
            PrimaryButton(
              label: 'Update Data',
              backgroundColor: AppColors.primary,
              textColor: Colors.black,
              onPressed: () {},
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
