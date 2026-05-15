import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/donation_model.dart';

class DonationProvider extends ChangeNotifier {
  final _col = FirebaseFirestore.instance.collection('donations');

  List<DonationModel> _all = [];
  bool _loading = true;
  String? _error;
  StreamSubscription<QuerySnapshot>? _sub;

  // ── Getters ───────────────────────────────
  bool   get loading => _loading;
  String? get error  => _error;
  List<DonationModel> get all => _all;

  // Filtered by month
  List<DonationModel> forMonth(String month) =>
      _all.where((d) => d.month == month).toList();

  // Recent 5 (for dashboard)
  List<DonationModel> get recent =>
      (_all.length > 5 ? _all.sublist(0, 5) : List.from(_all));

  // Totals
  double get totalAllTime =>
      _all.fold(0, (s, d) => s + d.amount);

  double totalForMonth(String month) =>
      forMonth(month).fold(0, (s, d) => s + d.amount);

  // ── Init — listen to Firestore stream ─────
  void init() {
    _sub = _col
        .orderBy('date', descending: true)
        .snapshots()
        .listen(
          (snap) {
            _all = snap.docs.map(DonationModel.fromFirestore).toList();
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
  Future<void> add(DonationModel d) async {
    final map = d.toMap()..remove('createdAt');
    await _col.add({...map, 'createdAt': FieldValue.serverTimestamp()});
  }

  Future<void> update(String id, DonationModel d) async {
    final map = d.toMap()..remove('createdAt');
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
