// lib/theme/app_theme.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const primary     = Color(0xFF1a5c2a);
  static const primaryDark = Color(0xFF144a21);
  static const primaryLight= Color(0xFF2d8048);
  static const gold        = Color(0xFFd4a017);
  static const success     = Color(0xFF27ae60);
  static const danger      = Color(0xFFe74c3c);
  static const warning     = Color(0xFFf39c12);
  static const info        = Color(0xFF2980b9);
  static const bg          = Color(0xFFF4F6F8);
  static const surface     = Color(0xFFFFFFFF);
  static const textPrimary = Color(0xFF1a1a2e);
  static const textLight   = Color(0xFF6b7280);
  static const border      = Color(0xFFE5E7EB);
  static const navBg       = Color(0xFF0f3d1c);

  // Category colors
  static const Map<String, Color> category = {
    'Imam Salary' : Color(0xFF1a5c2a),
    'Staff Salary': Color(0xFF2d8048),
    'Electricity' : Color(0xFFf39c12),
    'Water'       : Color(0xFF2980b9),
    'Gas'         : Color(0xFFe74c3c),
    'Maintenance' : Color(0xFF8e44ad),
    'Other'       : Color(0xFF7f8c8d),
  };
}

class AppTheme {
  static ThemeData get theme => ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      primary:   AppColors.primary,
      surface:   AppColors.surface,
    ),
    scaffoldBackgroundColor: AppColors.bg,
    textTheme: GoogleFonts.poppinsTextTheme(),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      elevation: 0,
      titleTextStyle: TextStyle(
        fontFamily: 'Poppins',
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
    ),
    cardTheme: CardThemeData(
      color: AppColors.surface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppColors.border, width: 1),
      ),
      margin: const EdgeInsets.only(bottom: 12),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFFF9FAFB),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.primary, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      labelStyle: const TextStyle(color: AppColors.textLight, fontSize: 13),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
      ),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: AppColors.navBg,
      indicatorColor: AppColors.primaryLight.withOpacity(0.3),
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        final active = states.contains(WidgetState.selected);
        return TextStyle(
          color: active ? Colors.white : Colors.white54,
          fontSize: 11,
          fontWeight: active ? FontWeight.w600 : FontWeight.normal,
        );
      }),
      iconTheme: WidgetStateProperty.resolveWith((states) {
        final active = states.contains(WidgetState.selected);
        return IconThemeData(color: active ? Colors.white : Colors.white54);
      }),
    ),
    dividerTheme: const DividerThemeData(color: AppColors.border, thickness: 1),
  );
}
