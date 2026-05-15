// lib/services/firestore_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/donation.dart';
import '../models/expense.dart';
import '../models/project.dart';

class FirestoreService {
  final _db = FirebaseFirestore.instance;

  // ── Collections ─────────────────────────────────────
  CollectionReference get _donations => _db.collection('donations');
  CollectionReference get _expenses  => _db.collection('expenses');
  CollectionReference get _projects  => _db.collection('projects');

  // ── Date helpers ─────────────────────────────────────
  Timestamp _monthStart(DateTime m) =>
      Timestamp.fromDate(DateTime(m.year, m.month, 1));
  Timestamp _monthEnd(DateTime m) =>
      Timestamp.fromDate(DateTime(m.year, m.month + 1, 0, 23, 59, 59));

  // ════════════════════════════════════════════════════
  //  DONATIONS
  // ════════════════════════════════════════════════════
  Stream<List<Donation>> donationsStream(DateTime month) {
    return _donations
        .where('date', isGreaterThanOrEqualTo: _monthStart(month))
        .where('date', isLessThanOrEqualTo:    _monthEnd(month))
        .orderBy('date', descending: true)
        .snapshots()
        .map((s) => s.docs.map(Donation.fromFirestore).toList());
  }

  Future<List<Donation>> getRecentDonations({int limit = 5}) async {
    final s = await _donations
        .orderBy('date', descending: true)
        .limit(limit)
        .get();
    return s.docs.map(Donation.fromFirestore).toList();
  }

  Future<void> addDonation(Donation d) =>
      _donations.add(d.toFirestore());

  Future<void> updateDonation(Donation d) =>
      _donations.doc(d.id).update(d.toFirestore());

  Future<void> deleteDonation(String id) =>
      _donations.doc(id).delete();

  // ════════════════════════════════════════════════════
  //  EXPENSES
  // ════════════════════════════════════════════════════
  Stream<List<Expense>> expensesStream(DateTime month, {String? category}) {
    Query q = _expenses
        .where('date', isGreaterThanOrEqualTo: _monthStart(month))
        .where('date', isLessThanOrEqualTo:    _monthEnd(month));
    if (category != null && category.isNotEmpty) {
      q = q.where('category', isEqualTo: category);
    }
    return q
        .orderBy('date', descending: true)
        .snapshots()
        .map((s) => s.docs.map(Expense.fromFirestore).toList());
  }

  Future<List<Expense>> getRecentExpenses({int limit = 5}) async {
    final s = await _expenses
        .orderBy('date', descending: true)
        .limit(limit)
        .get();
    return s.docs.map(Expense.fromFirestore).toList();
  }

  Future<void> addExpense(Expense e) =>
      _expenses.add(e.toFirestore());

  Future<void> updateExpense(Expense e) =>
      _expenses.doc(e.id).update(e.toFirestore());

  Future<void> deleteExpense(String id) =>
      _expenses.doc(id).delete();

  // ════════════════════════════════════════════════════
  //  PROJECTS
  // ════════════════════════════════════════════════════
  Stream<List<Project>> projectsStream({String? status}) {
    Query q = _projects;
    if (status != null && status.isNotEmpty) {
      q = q.where('status', isEqualTo: status);
    }
    return q
        .orderBy('name')
        .snapshots()
        .map((s) => s.docs.map(Project.fromFirestore).toList());
  }

  Future<void> addProject(Project p) =>
      _projects.add(p.toFirestore());

  Future<void> updateProject(Project p) =>
      _projects.doc(p.id).update(p.toFirestore());

  Future<void> deleteProject(String id) =>
      _projects.doc(id).delete();

  // ════════════════════════════════════════════════════
  //  DASHBOARD STATS
  // ════════════════════════════════════════════════════
  Future<Map<String, dynamic>> getDashboardStats(DateTime month) async {
    final allDonations = await _donations.get();
    final allExpenses  = await _expenses.get();
    final allProjects  = await _projects.get();

    final monthDonations = await _donations
        .where('date', isGreaterThanOrEqualTo: _monthStart(month))
        .where('date', isLessThanOrEqualTo:    _monthEnd(month))
        .get();
    final monthExpenses = await _expenses
        .where('date', isGreaterThanOrEqualTo: _monthStart(month))
        .where('date', isLessThanOrEqualTo:    _monthEnd(month))
        .get();

    double totalDonations = 0, totalExpenses = 0,
           monthDon = 0, monthExp = 0, totalProjectSpent = 0;
    int activeProjects = 0, totalProjectsCount = 0;

    for (final d in allDonations.docs) {
      totalDonations += ((d.data() as Map)['amount'] ?? 0).toDouble();
    }
    for (final e in allExpenses.docs) {
      totalExpenses += ((e.data() as Map)['amount'] ?? 0).toDouble();
    }
    for (final d in monthDonations.docs) {
      monthDon += ((d.data() as Map)['amount'] ?? 0).toDouble();
    }
    for (final e in monthExpenses.docs) {
      monthExp += ((e.data() as Map)['amount'] ?? 0).toDouble();
    }
    for (final p in allProjects.docs) {
      final data = p.data() as Map;
      totalProjectSpent += (data['amountSpent'] ?? 0).toDouble();
      totalProjectsCount++;
      if (data['status'] == 'Ongoing') activeProjects++;
    }

    return {
      'totalDonations':    totalDonations,
      'totalExpenses':     totalExpenses,
      'monthlyDonations':  monthDon,
      'monthlyExpenses':   monthExp,
      'currentBalance':    totalDonations - totalExpenses,
      'totalProjectSpent': totalProjectSpent,
      'activeProjects':    activeProjects,
      'totalProjects':     totalProjectsCount,
    };
  }
}
