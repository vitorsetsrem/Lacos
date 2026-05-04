import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static const Color primaryPink = Color(0xFFFF6F91);
  static const Color primaryLilas = Color(0xFFA66DD4);
  static const Color lightPink = Color(0xFFFFB6C1);
  static const Color lightLilas = Color(0xFFD4B6E8);
  static const Color pastelPink = Color(0xFFFFF0F3);
  static const Color pastelLilas = Color(0xFFF5EEFF);
  static const Color background = Color(0xFFFFFBFD);
  static const Color cardBackground = Colors.white;
  static const Color textPrimary = Color(0xFF2D2D2D);
  static const Color textSecondary = Color(0xFF6B6B6B);
  static const Color textLight = Color(0xFF9E9E9E);
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFFC107);
  static const Color error = Color(0xFFE53935);

  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryPink, primaryLilas],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const LinearGradient backgroundGradient = LinearGradient(
    colors: [pastelPink, pastelLilas],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
