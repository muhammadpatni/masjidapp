import 'package:cloud_firestore/cloud_firestore.dart';

const List<String> kExpenseCategories = [
  'Imam Salary', 'Staff Salary', 'Electricity',
  'Water', 'Gas', 'Maintenance', 'Other',
];

const Map<String, String> kCategoryIcons = {
  'Imam Salary':  '🧕',
  'Staff Salary': '👷',
  'Electricity':  '⚡',
  'Water':        '💧',
  'Gas':          '🔥',
  'Maintenance':  '🔧',
  'Other':        '📌',
};

class ExpenseModel {
  final String? id;
  final String category;
  final String description;
  final double amount;
  final DateTime date;
  final String recipient;  // for salary entries
  final String month;

  ExpenseModel({
    this.id,
    required this.category,
    required this.amount,
    required this.date,
    this.description = '',
    this.recipient   = '',
  }) : month = '${date.year}-${date.month.toString().padLeft(2, '0')}';

  factory ExpenseModel.fromFirestore(DocumentSnapshot doc) {
    final d  = doc.data() as Map<String, dynamic>;
    final ts = d['date'];
    final DateTime dt =
        ts is Timestamp ? ts.toDate() : DateTime.tryParse(ts ?? '') ?? DateTime.now();
    return ExpenseModel(
      id:          doc.id,
      category:    d['category']    ?? 'Other',
      description: d['description'] ?? '',
      amount:      (d['amount'] as num?)?.toDouble() ?? 0,
      date:        dt,
      recipient:   d['recipient']   ?? '',
    );
  }

  Map<String, dynamic> toMap() => {
    'category':    category,
    'description': description,
    'amount':      amount,
    'date':        Timestamp.fromDate(date),
    'recipient':   recipient,
    'month':       month,
    'createdAt':   FieldValue.serverTimestamp(),
  };

  ExpenseModel copyWith({
    String? category, String? description, double? amount,
    DateTime? date, String? recipient,
  }) => ExpenseModel(
    id:          id,
    category:    category    ?? this.category,
    description: description ?? this.description,
    amount:      amount      ?? this.amount,
    date:        date        ?? this.date,
    recipient:   recipient   ?? this.recipient,
  );
}
