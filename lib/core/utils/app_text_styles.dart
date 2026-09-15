import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {
  static TextStyle movieTitle = const TextStyle(
    color: AppColors.white,
    fontSize: 26,
    fontWeight: FontWeight.bold,
  );

  static TextStyle movieYear = const TextStyle(
    color: AppColors.grey,
    fontSize: 18,
  );

  static TextStyle watchButton = const TextStyle(
    color: AppColors.white,
    fontSize: 20,
    fontWeight: FontWeight.bold,
  );

  static TextStyle statValue = const TextStyle(
    color: AppColors.white,
    fontSize: 18,
    fontWeight: FontWeight.bold,
  );

  static TextStyle sectionHeader = const TextStyle(
    color: AppColors.white,
    fontSize: 22,
    fontWeight: FontWeight.bold,
  );

  static TextStyle summaryText = const TextStyle(
    color: AppColors.white,
    fontSize: 16,
    height: 1.6,
  );

  static TextStyle castName = const TextStyle(
    color: AppColors.white,
    fontSize: 18,
    fontWeight: FontWeight.w600,
  );

  static TextStyle castCharacter = const TextStyle(
    color: AppColors.grey,
    fontSize: 16,
  );

  static TextStyle genreText = const TextStyle(
    color: Colors.white,
    fontSize: 16,
  );

  static TextStyle errorText = const TextStyle(color: AppColors.white);
}
