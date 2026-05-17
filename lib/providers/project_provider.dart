// import 'dart:async';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import '../models/project_model.dart';

// class ProjectProvider extends ChangeNotifier {
//   final _col = FirebaseFirestore.instance.collection('projects');

//   List<ProjectModel> _all = [];
//   bool _loading = true;
//   String? _error;
//   StreamSubscription<QuerySnapshot>? _sub;

//   // ── Getters ───────────────────────────────
//   bool    get loading => _loading;
//   String? get error   => _error;
//   List<ProjectModel> get all => _all;

//   List<ProjectModel> get active =>
//       _all.where((p) => p.status == 'Ongoing').toList();

//   List<ProjectModel> byStatus(String status) =>
//       status.isEmpty ? _all : _all.where((p) => p.status == status).toList();

//   double get totalBudget =>
//       _all.fold(0, (s, p) => s + p.totalBudget);

//   double get totalSpent =>
//       _all.fold(0, (s, p) => s + p.amountSpent);

//   // ── Init ──────────────────────────────────
//   void init() {
//     _sub = _col
//         .orderBy('createdAt', descending: true)
//         .snapshots()
//         .listen(
//           (snap) {
//             _all = snap.docs.map(ProjectModel.fromFirestore).toList();
//             _loading = false;
//             _error = null;
//             notifyListeners();
//           },
//           onError: (e) {
//             _error = e.toString();
//             _loading = false;
//             notifyListeners();
//           },
//         );
//   }

//   // ── CRUD ──────────────────────────────────
//   Future<void> add(ProjectModel p) async {
//     final map = p.toMap()..remove('createdAt');
//     await _col.add({...map, 'createdAt': FieldValue.serverTimestamp()});
//   }

//   Future<void> update(String id, ProjectModel p) async {
//     final map = p.toMap()..remove('createdAt');
//     await _col.doc(id).update(map);
//   }

//   Future<void> delete(String id) async {
//     await _col.doc(id).delete();
//   }

//   @override
//   void dispose() {
//     _sub?.cancel();
//     super.dispose();
//   }
// }

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../models/project_model.dart';

class ProjectProvider extends ChangeNotifier {
  CollectionReference get _col => FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection('projects');

  List<ProjectModel> _all = [];
  bool _loading = false;
  String? _error;
  StreamSubscription<QuerySnapshot>? _sub;

  // ── Getters ───────────────────────────────
  bool get loading => _loading;
  String? get error => _error;
  List<ProjectModel> get all => _all;

  List<ProjectModel> get active =>
      _all.where((p) => p.status == 'Ongoing').toList();

  List<ProjectModel> byStatus(String status) =>
      status.isEmpty ? _all : _all.where((p) => p.status == status).toList();

  double get totalBudget => _all.fold(0, (s, p) => s + p.totalBudget);

  double get totalSpent => _all.fold(0, (s, p) => s + p.amountSpent);

  // ── Init ──────────────────────────────────
  void init() {
    _sub?.cancel();
    _loading = true;
    notifyListeners();
    _sub = _col
        .orderBy('createdAt', descending: true)
        .snapshots()
        .listen(
          (snap) {
            _all = snap.docs.map(ProjectModel.fromFirestore).toList();
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
  Future<void> add(ProjectModel p) async {
    final map = p.toMap()..remove('createdAt');
    await _col.add({...map, 'createdAt': FieldValue.serverTimestamp()});
  }

  Future<void> update(String id, ProjectModel p) async {
    final map = p.toMap()..remove('createdAt');
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
