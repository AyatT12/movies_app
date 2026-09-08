import 'package:flutter/material.dart';
import 'package:movies_app/core/utils/app_colors.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const CustomBottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16,vertical: 10),
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF282A28),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color:AppColors.cardDark,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(icon: Icons.home_filled, index: 0),
          _buildNavItem(icon: Icons.search, index: 1),
          _buildNavItem(icon: Icons.explore_outlined, index: 2),
          _buildNavItem(icon: Icons.person_outline, index: 3),
        ],
      ),
    );
  }

  Widget _buildNavItem({required IconData icon, required int index}) {
    final bool isSelected = selectedIndex == index;
    return IconButton(
      onPressed: () => onItemTapped(index),
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      icon: Icon(
        icon,
        size: 28,
        color: isSelected ? const Color(0xFFF6BD00) : Colors.white,
      ),
    );
  }
}