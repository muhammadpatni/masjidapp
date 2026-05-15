// lib/models/project.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class Project {
  final String    id;
  final String    name;
  final String    description;
  final double    totalBudget;
  final double    amountSpent;
  final String    status;      // Planning | Ongoing | Completed
  final DateTime? startDate;
  final DateTime? endDate;

  Project({
    required this.id,
    required this.name,
    required this.description,
    required this.totalBudget,
    required this.amountSpent,
    required this.status,
    this.startDate,
    this.endDate,
  });

  double get remaining   => totalBudget - amountSpent;
  bool   get isOverBudget => amountSpent > totalBudget;
  int    get progressPct =>
    totalBudget > 0 ? (amountSpent / totalBudget * 100).clamp(0, 100).round() : 0;

  factory Project.fromFirestore(DocumentSnapshot doc) {
    final d = doc.data() as Map<String, dynamic>;
    return Project(
      id:          doc.id,
      name:        d['name']        ?? '',
      description: d['description'] ?? '',
      totalBudget: (d['totalBudget'] ?? 0).toDouble(),
      amountSpent: (d['amountSpent'] ?? 0).toDouble(),
      status:      d['status']      ?? 'Planning',
      startDate:   d['startDate'] != null
          ? (d['startDate'] as Timestamp).toDate() : null,
      endDate:     d['endDate'] != null
          ? (d['endDate'] as Timestamp).toDate() : null,
    );
  }

  Map<String, dynamic> toFirestore() => {
    'name':        name,
    'description': description,
    'totalBudget': totalBudget,
    'amountSpent': amountSpent,
    'status':      status,
    if (startDate != null) 'startDate': Timestamp.fromDate(startDate!),
    if (endDate   != null) 'endDate':   Timestamp.fromDate(endDate!),
  };
}
