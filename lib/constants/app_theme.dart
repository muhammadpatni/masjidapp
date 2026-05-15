import 'package:flutter/material.dart';

// ═══════════════════════════════════════════
//  COLORS
// ═══════════════════════════════════════════
const Color kPrimary = Color(0xFF1A5C2A);
const Color kPrimaryDark = Color(0xFF0F3D1A);
const Color kPrimaryLight = Color(0xFF2D8048);
const Color kPrimarySoft = Color(0xFFE8F5EC);
const Color kGold = Color(0xFFC9A227);
const Color kGoldSoft = Color(0xFFFDF8E8);
const Color kBackground = Color(0xFFF4F1E8);
const Color kCard = Color(0xFFFFFFFF);
const Color kSuccess = Color(0xFF27AE60);
const Color kDanger = Color(0xFFE74C3C);
const Color kWarning = Color(0xFFF39C12);
const Color kInfo = Color(0xFF2980B9);
const Color kTextLight = Color(0xFF666666);
const Color kTextMuted = Color(0xFF999999);
const Color kBorder = Color(0xFFE0D9C8);

// ═══════════════════════════════════════════
//  THEME
// ═══════════════════════════════════════════
ThemeData appTheme() {
  return ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(seedColor: kPrimary, primary: kPrimary),
    scaffoldBackgroundColor: kBackground,
    appBarTheme: const AppBarTheme(
      backgroundColor: kPrimary,
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
      iconTheme: IconThemeData(color: Colors.white),
    ),
    cardTheme: CardThemeData(
      color: kCard,
      elevation: 2,
      shadowColor: const Color(0x151A5C2A),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: EdgeInsets.zero,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: kPrimary,
      foregroundColor: Colors.white,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: kCard,
      selectedItemColor: kPrimary,
      unselectedItemColor: kTextMuted,
      type: BottomNavigationBarType.fixed,
      elevation: 12,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: kBorder),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: kBorder),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: kPrimaryLight, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
      labelStyle: const TextStyle(color: kTextLight),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: kPrimary,
        foregroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 48),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
      ),
    ),
    dividerTheme: const DividerThemeData(color: kBorder, space: 1),
  );
}

// ═══════════════════════════════════════════
//  FORMATTERS
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
