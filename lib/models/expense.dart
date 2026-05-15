// lib/models/expense.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class Expense {
  final String   id;
  final String   category;
  final String   description;
  final double   amount;
  final DateTime date;
  final String   recipient;

  Expense({
    required this.id,
    required this.category,
    required this.description,
    required this.amount,
    required this.date,
    this.recipient = '',
  });

  factory Expense.fromFirestore(DocumentSnapshot doc) {
    final d = doc.data() as Map<String, dynamic>;
    return Expense(
      id:          doc.id,
      category:    d['category']    ?? 'Other',
      description: d['description'] ?? '',
      amount:      (d['amount']     ?? 0).toDouble(),
      date:        (d['date'] as Timestamp).toDate(),
      recipient:   d['recipient']   ?? '',
    );
  }

  Map<String, dynamic> toFirestore() => {
    'category':    category,
    'description': description,
    'amount':      amount,
    'date':        Timestamp.fromDate(date),
    'recipient':   recipient,
  };

  static const List<String> categories = [
    'Imam Salary', 'Staff Salary', 'Electricity',
    'Water', 'Gas', 'Maintenance', 'Other',
  ];

  static const Map<String, String> categoryIcons = {
    'Imam Salary' : '🧕',
    'Staff Salary': '👷',
    'Electricity' : '⚡',
    'Water'       : '💧',
    'Gas'         : '🔥',
    'Maintenance' : '🔧',
    'Other'       : '📌',
  };
}
