import 'package:flutter/material.dart';
import 'package:movies_app/core/utils/app_assets.dart';
import 'package:movies_app/core/utils/app_colors.dart';
import 'avatar_bottom_sheet.dart';
import 'button.dart';
import 'text_field.dart';

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
  final List<String> _avatars = List.generate(
    9,
        (index) => 'assets/images/avatar_${index + 1}.png',
  );

  late int _selectedAvatarIndex;
  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();
    _selectedAvatarIndex = widget.currentAvatarIndex;
    _nameController = TextEditingController(text: widget.currentName);
    _phoneController = TextEditingController(text: widget.currentPhone);
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Pick Avatar',
          style: TextStyle(
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
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Reset password link sent to your email'),
                      backgroundColor: AppColors.primary,
                    ),
                  );
                },
                style: TextButton.styleFrom(padding: EdgeInsets.zero),
                child: const Text(
                  'Reset Password',
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 40),


            PrimaryButton(
              label: 'Delete Account',
              backgroundColor: AppColors.delete,
              textColor: AppColors.white,
              onPressed: () {
                Navigator.pop(context);
              },
            ),

            const SizedBox(height: 14),


            PrimaryButton(
              label: 'Update Data',
              backgroundColor: AppColors.primary,
              textColor: AppColors.black,
              onPressed: () {
                Navigator.pop(context, {
                  'name': _nameController.text.trim(),
                  'phone': _phoneController.text.trim(),
                  'avatarIndex': _selectedAvatarIndex,
                });
              },
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}