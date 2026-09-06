import 'package:flutter/material.dart';
import 'package:movies_app/core/utils/app_assets.dart';
import 'package:movies_app/core/utils/app_colors.dart';

class AvatarPickerBottomSheet extends StatelessWidget {
  final List<String> avatars;
  final int selectedIndex;
  final ValueChanged<int> onAvatarSelected;

  const AvatarPickerBottomSheet({
    super.key,
    required this.avatars,
    required this.selectedIndex,
    required this.onAvatarSelected,
  });

  static void show(
    BuildContext context, {
    required List<String> avatars,
    required int selectedIndex,
    required ValueChanged<int> onAvatarSelected,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.background,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => AvatarPickerBottomSheet(
        avatars: avatars,
        selectedIndex: selectedIndex,
        onAvatarSelected: onAvatarSelected,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24.0),
      child: GridView.builder(
        shrinkWrap: true,
        itemCount: avatars.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemBuilder: (context, index) {
          final isSelected = selectedIndex == index;
          return GestureDetector(
            onTap: () {
              onAvatarSelected(index);
              Navigator.pop(context);
            },
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.textfield,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isSelected ? AppColors.primary : Colors.transparent,
                  width: 2,
                ),
              ),
              child: Center(
                child: CircleAvatar(
                  radius: 40,
                  backgroundImage: AssetImage(avatars[index]),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
