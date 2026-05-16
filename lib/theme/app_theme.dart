// // lib/theme/app_theme.dart
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';

// class AppColors {
//   static const primary = Color(0xFF1a5c2a);
//   static const primaryDark = Color(0xFF144a21);
//   static const primaryLight = Color(0xFF2d8048);
//   static const gold = Color(0xFFd4a017);
//   static const success = Color(0xFF27ae60);
//   static const danger = Color(0xFFe74c3c);
//   static const warning = Color(0xFFf39c12);
//   static const info = Color(0xFF2980b9);
//   static const bg = Color(0xFFF4F6F8);
//   static const surface = Color(0xFFFFFFFF);
//   static const textPrimary = Color(0xFF1a1a2e);
//   static const textLight = Color(0xFF6b7280);
//   static const border = Color(0xFFE5E7EB);
//   static const navBg = Color(0xFF0f3d1c);

//   // Category colors
//   static const Map<String, Color> category = {
//     'Imam Salary': Color(0xFF1a5c2a),
//     'Staff Salary': Color(0xFF2d8048),
//     'Electricity': Color(0xFFf39c12),
//     'Water': Color(0xFF2980b9),
//     'Gas': Color(0xFFe74c3c),
//     'Maintenance': Color(0xFF8e44ad),
//     'Other': Color(0xFF7f8c8d),
//   };
// }

// class AppTheme {
//   static ThemeData get theme => ThemeData(
//     useMaterial3: true,
//     colorScheme: ColorScheme.fromSeed(
//       seedColor: AppColors.primary,
//       primary: AppColors.primary,
//       surface: AppColors.surface,
//     ),
//     scaffoldBackgroundColor: AppColors.bg,
//     textTheme: GoogleFonts.poppinsTextTheme(),
//     appBarTheme: const AppBarTheme(
//       backgroundColor: AppColors.primary,
//       foregroundColor: Colors.white,
//       elevation: 0,
//       titleTextStyle: TextStyle(
//         fontFamily: 'Poppins',
//         fontSize: 18,
//         fontWeight: FontWeight.w600,
//         color: Colors.white,
//       ),
//     ),
//     cardTheme: CardThemeData(
//       color: AppColors.surface,
//       elevation: 0,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(16),
//         side: const BorderSide(color: AppColors.border, width: 1),
//       ),
//       margin: const EdgeInsets.only(bottom: 12),
//     ),
//     inputDecorationTheme: InputDecorationTheme(
//       filled: true,
//       fillColor: const Color(0xFFF9FAFB),
//       border: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(10),
//         borderSide: const BorderSide(color: AppColors.border),
//       ),
//       enabledBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(10),
//         borderSide: const BorderSide(color: AppColors.border),
//       ),
//       focusedBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(10),
//         borderSide: const BorderSide(color: AppColors.primary, width: 2),
//       ),
//       contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
//       labelStyle: const TextStyle(color: AppColors.textLight, fontSize: 13),
//     ),
//     elevatedButtonTheme: ElevatedButtonThemeData(
//       style: ElevatedButton.styleFrom(
//         backgroundColor: AppColors.primary,
//         foregroundColor: Colors.white,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//         padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
//         textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
//       ),
//     ),
//     navigationBarTheme: NavigationBarThemeData(
//       backgroundColor: AppColors.navBg,
//       indicatorColor: AppColors.primaryLight.withOpacity(0.3),
//       labelTextStyle: WidgetStateProperty.resolveWith((states) {
//         final active = states.contains(WidgetState.selected);
//         return TextStyle(
//           color: active ? Colors.white : Colors.white54,
//           fontSize: 11,
//           fontWeight: active ? FontWeight.w600 : FontWeight.normal,
//         );
//       }),
//       iconTheme: WidgetStateProperty.resolveWith((states) {
//         final active = states.contains(WidgetState.selected);
//         return IconThemeData(color: active ? Colors.white : Colors.white54);
//       }),
//     ),
//     dividerTheme: const DividerThemeData(color: AppColors.border, thickness: 1),
//   );
// }

// lib/theme/app_theme.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const primary = Color(0xFF0A2E24); // Deep Emerald/Masjid Background
  static const primaryDark = Color(0xFF051C15); // Darker shade for depths
  static const primaryLight = Color(
    0xFF144D3E,
  ); // Lighter emerald for glow borders
  static const gold = Color(0xFFD4AF37); // Premium Metallic Gold for accents
  static const success = Color(0xFF2ECC71); // Clean Islamic Green
  static const danger = Color(0xFFE74C3C); // Glassy Red
  static const warning = Color(0xFFF39C12); // Amber
  static const info = Color(0xFF3498DB); // Info Blue
  static const bg = Color(0xFF07221A); // App Scaffold Background
  static const surface = Color(
    0x14FFFFFF,
  ); // 8% Transparent White for Frosted Glass Look
  static const textPrimary = Color(
    0xFFE0E0E0,
  ); // Crisp Light Grey for readability
  static const textLight = Color(0xB3FFFFFF); // 70% White for muted text
  static const border = Color(
    0x26D4AF37,
  ); // Transparent Golden Border for Glass Cards (15%)
  static const navBg = Color(
    0xFF051C15,
  ); // Deep Dark Emerald for Navigation Bar

  // ═══════════════════════════════════════════
  //  CATEGORY COLORS (Enhanced for Dark Theme Glass Glow)
  // ═══════════════════════════════════════════
  static const Map<String, Color> category = {
    'Imam Salary': Color(0xFF2ECC71), // Bright Islamic Green
    'Staff Salary': Color(0xFF27AE60), // Medium Green
    'Electricity': Color(0xFFF1C40F), // Electric Yellow/Gold
    'Water': Color(0xFF3498DB), // Clean Blue
    'Gas': Color(0xFFE67E22), // Neon Orange
    'Maintenance': Color(0xFF9B59B6), // Soft Purple
    'Other': Color(0xFF95A5A6), // Metallic Silver/Grey
  };
}

class AppTheme {
  static ThemeData get theme => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.gold,
      primary: AppColors.gold,
      surface: AppColors.primary,
      brightness: Brightness.dark,
    ),
    scaffoldBackgroundColor: AppColors.bg,

    // Changing font to 'Cairo' for a premium Islamic vibe
    textTheme: GoogleFonts.cairoTextTheme(ThemeData.dark().textTheme).copyWith(
      bodyLarge: GoogleFonts.cairo(color: AppColors.textPrimary, fontSize: 16),
      bodyMedium: GoogleFonts.cairo(color: AppColors.textLight, fontSize: 14),
      titleLarge: GoogleFonts.cairo(
        color: AppColors.gold,
        fontWeight: FontWeight.bold,
      ),
    ),

    // Beautiful Transparent App Bar with Golden Accent
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      foregroundColor: AppColors.gold,
      elevation: 0,
      centerTitle: true, // Professional center aligned title
      titleTextStyle: GoogleFonts.cairo(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: AppColors.gold,
        letterSpacing: 0.5,
      ),
      iconTheme: const IconThemeData(color: AppColors.gold),
    ),

    // Base Setup for Glass Cards
    cardTheme: CardThemeData(
      color: AppColors.surface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppColors.border, width: 1.2),
      ),
      margin: const EdgeInsets.only(bottom: 12),
    ),

    // Modern Frosted Input Fields with Metallic Gold Focus
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white.withOpacity(0.04),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.gold, width: 1.5),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      labelStyle: const TextStyle(color: AppColors.textLight, fontSize: 13),
      hintStyle: const TextStyle(color: Colors.white30),
    ),

    // Premium Golden Button
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.gold,
        foregroundColor: AppColors.primaryDark,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        textStyle: GoogleFonts.cairo(fontWeight: FontWeight.bold, fontSize: 15),
        elevation: 2,
      ),
    ),

    // Glassmorphism Friendly Bottom Navigation Bar
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: AppColors.navBg,
      elevation: 0,
      indicatorColor: AppColors.gold.withOpacity(
        0.15,
      ), // Subtle gold glow behind selected icon
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        final active = states.contains(WidgetState.selected);
        return GoogleFonts.cairo(
          color: active ? AppColors.gold : Colors.white54,
          fontSize: 12,
          fontWeight: active ? FontWeight.bold : FontWeight.normal,
        );
      }),
      iconTheme: WidgetStateProperty.resolveWith((states) {
        final active = states.contains(WidgetState.selected);
        return IconThemeData(
          color: active ? AppColors.gold : Colors.white54,
          size: 24,
        );
      }),
    ),

    dividerTheme: const DividerThemeData(color: AppColors.border, thickness: 1),
  );
}
