import 'package:flutter/material.dart';
import '../constants/app_theme.dart';

/// Global app state — selected month for filtering
class AppProvider extends ChangeNotifier {
  String _selectedMonth = currentMonth();

  String get selectedMonth => _selectedMonth;

  String get selectedMonthLabel => monthLabel(_selectedMonth);

  void setMonth(String ym) {
    if (_selectedMonth == ym) return;
    _selectedMonth = ym;
    notifyListeners();
  }

  // Returns previous/next month strings for navigation
  void prevMonth() {
    final p = _selectedMonth.split('-');
    var y = int.parse(p[0]);
    var m = int.parse(p[1]) - 1;
    if (m < 1) { m = 12; y--; }
    _selectedMonth = '$y-${m.toString().padLeft(2, '0')}';
    notifyListeners();
  }

  void nextMonth() {
    final p = _selectedMonth.split('-');
    var y = int.parse(p[0]);
    var m = int.parse(p[1]) + 1;
    if (m > 12) { m = 1; y++; }
    _selectedMonth = '$y-${m.toString().padLeft(2, '0')}';
    notifyListeners();
  }
}
