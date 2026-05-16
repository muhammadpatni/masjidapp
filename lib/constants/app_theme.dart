// import 'package:flutter/material.dart';

// // ═══════════════════════════════════════════
// //  COLORS
// // ═══════════════════════════════════════════
// const Color kPrimary = Color(0xFF1A5C2A);
// const Color kPrimaryDark = Color(0xFF0F3D1A);
// const Color kPrimaryLight = Color(0xFF2D8048);
// const Color kPrimarySoft = Color(0xFFE8F5EC);
// const Color kGold = Color(0xFFC9A227);
// const Color kGoldSoft = Color(0xFFFDF8E8);
// const Color kBackground = Color(0xFFF4F1E8);
// const Color kCard = Color(0xFFFFFFFF);
// const Color kSuccess = Color(0xFF27AE60);
// const Color kDanger = Color(0xFFE74C3C);
// const Color kWarning = Color(0xFFF39C12);
// const Color kInfo = Color(0xFF2980B9);
// const Color kTextLight = Color(0xFF666666);
// const Color kTextMuted = Color(0xFF999999);
// const Color kBorder = Color(0xFFE0D9C8);

// // ═══════════════════════════════════════════
// //  THEME
// // ═══════════════════════════════════════════
// ThemeData appTheme() {
//   return ThemeData(
//     useMaterial3: true,
//     colorScheme: ColorScheme.fromSeed(seedColor: kPrimary, primary: kPrimary),
//     scaffoldBackgroundColor: kBackground,
//     appBarTheme: const AppBarTheme(
//       backgroundColor: kPrimary,
//       foregroundColor: Colors.white,
//       elevation: 0,
//       centerTitle: false,
//       titleTextStyle: TextStyle(
//         color: Colors.white,
//         fontSize: 18,
//         fontWeight: FontWeight.w600,
//       ),
//       iconTheme: IconThemeData(color: Colors.white),
//     ),
//     cardTheme: CardThemeData(
//       color: kCard,
//       elevation: 2,
//       shadowColor: const Color(0x151A5C2A),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       margin: EdgeInsets.zero,
//     ),
//     floatingActionButtonTheme: const FloatingActionButtonThemeData(
//       backgroundColor: kPrimary,
//       foregroundColor: Colors.white,
//     ),
//     bottomNavigationBarTheme: const BottomNavigationBarThemeData(
//       backgroundColor: kCard,
//       selectedItemColor: kPrimary,
//       unselectedItemColor: kTextMuted,
//       type: BottomNavigationBarType.fixed,
//       elevation: 12,
//     ),
//     inputDecorationTheme: InputDecorationTheme(
//       filled: true,
//       fillColor: Colors.white,
//       border: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(8),
//         borderSide: const BorderSide(color: kBorder),
//       ),
//       enabledBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(8),
//         borderSide: const BorderSide(color: kBorder),
//       ),
//       focusedBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(8),
//         borderSide: const BorderSide(color: kPrimaryLight, width: 2),
//       ),
//       contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
//       labelStyle: const TextStyle(color: kTextLight),
//     ),
//     elevatedButtonTheme: ElevatedButtonThemeData(
//       style: ElevatedButton.styleFrom(
//         backgroundColor: kPrimary,
//         foregroundColor: Colors.white,
//         minimumSize: const Size(double.infinity, 48),
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//         textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
//       ),
//     ),
//     dividerTheme: const DividerThemeData(color: kBorder, space: 1),
//   );
// }

// // ═══════════════════════════════════════════
// //  FORMATTERS
// // ═══════════════════════════════════════════
// String fmtCurrency(num amount) {
//   final val = amount.toStringAsFixed(0);
//   final buf = StringBuffer();
//   int count = 0;
//   for (int i = val.length - 1; i >= 0; i--) {
//     if (count > 0 && count % 3 == 0) buf.write(',');
//     buf.write(val[i]);
//     count++;
//   }
//   return 'PKR ${buf.toString().split('').reversed.join()}';
// }

// String fmtDate(DateTime d) {
//   const m = [
//     'Jan',
//     'Feb',
//     'Mar',
//     'Apr',
//     'May',
//     'Jun',
//     'Jul',
//     'Aug',
//     'Sep',
//     'Oct',
//     'Nov',
//     'Dec',
//   ];
//   return '${d.day.toString().padLeft(2, '0')} ${m[d.month - 1]} ${d.year}';
// }

// String currentMonth() {
//   final n = DateTime.now();
//   return '${n.year}-${n.month.toString().padLeft(2, '0')}';
// }

// String monthLabel(String ym) {
//   try {
//     final p = ym.split('-');
//     const m = [
//       'January',
//       'February',
//       'March',
//       'April',
//       'May',
//       'June',
//       'July',
//       'August',
//       'September',
//       'October',
//       'November',
//       'December',
//     ];
//     return '${m[int.parse(p[1]) - 1]} ${p[0]}';
//   } catch (_) {
//     return ym;
//   }
// }

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ═══════════════════════════════════════════
//  COLORS (Premium Islamic Glassmorphism Theme)
// ═══════════════════════════════════════════
const Color kPrimary = Color(0xFF0A2E24); // Deep Emerald/Masjid Background
const Color kPrimaryDark = Color(0xFF051C15); // Darker shade for deep gradients
const Color kPrimaryLight = Color(
  0xFF144D3E,
); // Lighter emerald for active borders
const Color kPrimarySoft = Color(0x1F2D8048); // Transparent tint for soft glows
const Color kGold = Color(0xFFD4AF37); // Premium Metallic Gold for accents
const Color kGoldSoft = Color(0x26D4AF37); // Subtle golden glow for overlays
const Color kBackground = Color(0xFF07221A); // App scaffold base color
const Color kCard = Color(
  0x14FFFFFF,
); // Transparent White for Frosted Glass Effect (8% Opacity)
const Color kSuccess = Color(0xFF2ECC71); // Clean Islamic Green for success
const Color kDanger = Color(0xFFE74C3C); // Sleek Red
const Color kWarning = Color(0xFFF39C12); // Amber/Warning
const Color kInfo = Color(0xFF3498DB); // Info Blue
const Color kTextLight = Color(0xFFE0E0E0); // Crisp White/Grey for primary text
const Color kTextMuted = Color(
  0xB3FFFFFF,
); // 70% White for secondary/muted text
const Color kBorder = Color(
  0x26D4AF37,
); // Transparent Golden Border for Glass Cards (15% Opacity)

// ═══════════════════════════════════════════
//  THEME (Material 3 with Custom Font Family)
// ═══════════════════════════════════════════
ThemeData appTheme() {
  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.fromSeed(
      seedColor: kGold,
      primary: kGold,
      secondary: kPrimaryLight,
      surface: kPrimary,
      brightness: Brightness.dark,
    ),
    scaffoldBackgroundColor: kBackground,

    // Applying Elegant Islamic Font (Cairo) Across the App
    textTheme: GoogleFonts.cairoTextTheme(ThemeData.dark().textTheme).copyWith(
      bodyLarge: GoogleFonts.cairo(color: kTextLight, fontSize: 16),
      bodyMedium: GoogleFonts.cairo(color: kTextMuted, fontSize: 14),
      titleLarge: GoogleFonts.cairo(color: kGold, fontWeight: FontWeight.bold),
    ),

    // Premium Transparent/Glassy App Bar Theme
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      foregroundColor: kGold,
      elevation: 0,
      centerTitle: true, // Elegant center titles like premium apps
      titleTextStyle: GoogleFonts.cairo(
        color: kGold,
        fontSize: 20,
        fontWeight: FontWeight.bold,
        letterSpacing: 0.5,
      ),
      iconTheme: const IconThemeData(color: kGold),
    ),

    // Base Glass Setup for Cards
    cardTheme: CardThemeData(
      color: kCard,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: kBorder, width: 1.2),
      ),
      margin: EdgeInsets.zero,
    ),

    // Floating Action Button with Metallic Gold Vibe
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: kGold,
      foregroundColor: kPrimaryDark,
      elevation: 4,
    ),

    // Sleek Bottom Navigation Bar (Ready for Glass Effect implementation)
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: kPrimaryDark,
      selectedItemColor: kGold,
      unselectedItemColor: Colors.white54,
      type: BottomNavigationBarType.fixed,
      elevation: 0,
    ),

    // Modern Input Fields with Golden Glow Focused Border
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white.withOpacity(0.05),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: kBorder),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: kBorder),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: kGold, width: 1.5),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      labelStyle: const TextStyle(color: kTextMuted),
      hintStyle: const TextStyle(color: Colors.white30),
    ),

    // Premium Gold Elevated Button
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: kGold,
        foregroundColor: kPrimaryDark,
        minimumSize: const Size(
          double.infinity,
          52,
        ), // Slightly taller for premium feel
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: GoogleFonts.cairo(fontSize: 16, fontWeight: FontWeight.bold),
        elevation: 2,
      ),
    ),
    dividerTheme: const DividerThemeData(color: kBorder, space: 1),
  );
}

// ═══════════════════════════════════════════
//  FORMATTERS (Logics are strictly untouched)
// ═══════════════════════════════════════════
String fmtCurrency(num amount) {
  final val = amount.toStringAsFixed(0);
  final buf = StringBuffer();
  int count = 0;
  for (int i = val.length - 1; i >= 0; i--) {
    if (count > 0 && count % 3 == 0) buf.write(',');
    buf.write(val[i]);
    count++;
  }
  return 'PKR ${buf.toString().split('').reversed.join()}';
}

String fmtDate(DateTime d) {
  const m = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];
  return '${d.day.toString().padLeft(2, '0')} ${m[d.month - 1]} ${d.year}';
}

String currentMonth() {
  final n = DateTime.now();
  return '${n.year}-${n.month.toString().padLeft(2, '0')}';
}

String monthLabel(String ym) {
  try {
    final p = ym.split('-');
    const m = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return '${m[int.parse(p[1]) - 1]} ${p[0]}';
  } catch (_) {
    return ym;
  }
}
