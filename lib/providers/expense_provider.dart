import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/expense_model.dart';

class ExpenseProvider extends ChangeNotifier {
  final _col = FirebaseFirestore.instance.collection('expenses');

  List<ExpenseModel> _all = [];
  bool _loading = true;
  String? _error;
  StreamSubscription<QuerySnapshot>? _sub;

  // ── Getters ───────────────────────────────
  bool    get loading => _loading;
  String? get error   => _error;
  List<ExpenseModel> get all => _all;

  List<ExpenseModel> forMonth(String month) =>
      _all.where((e) => e.month == month).toList();

  List<ExpenseModel> get recent =>
      (_all.length > 5 ? _all.sublist(0, 5) : List.from(_all));

  double get totalAllTime =>
      _all.fold(0, (s, e) => s + e.amount);

  double totalForMonth(String month) =>
      forMonth(month).fold(0, (s, e) => s + e.amount);

  /// Per-category total for a given month
  Map<String, double> categoryTotals(String month) {
    final map = <String, double>{};
    for (final e in forMonth(month)) {
      map[e.category] = (map[e.category] ?? 0) + e.amount;
    }
    return map;
  }

  // ── Init ──────────────────────────────────
  void init() {
    _sub = _col
        .orderBy('date', descending: true)
        .snapshots()
        .listen(
          (snap) {
            _all = snap.docs.map(ExpenseModel.fromFirestore).toList();
            _loading = false;
            _error = null;
            notifyListeners();
          },
          onError: (e) {
            _error = e.toString();
            _loading = false;
            notifyListeners();
          },
        );
  }

  // ── CRUD ──────────────────────────────────
  Future<void> add(ExpenseModel e) async {
    final map = e.toMap()..remove('createdAt');
    await _col.add({...map, 'createdAt': FieldValue.serverTimestamp()});
  }

  Future<void> update(String id, ExpenseModel e) async {
    final map = e.toMap()..remove('createdAt');
    await _col.doc(id).update(map);
  }

  Future<void> delete(String id) async {
    await _col.doc(id).delete();
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}
