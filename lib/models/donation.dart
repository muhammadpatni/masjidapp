// lib/models/donation.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class Donation {
  final String id;
  final String donorName;
  final double amount;
  final DateTime date;
  final String type; // Cash | Online | Cheque
  final String notes;

  Donation({
    required this.id,
    required this.donorName,
    required this.amount,
    required this.date,
    required this.type,
    this.notes = '',
  });

  factory Donation.fromFirestore(DocumentSnapshot doc) {
    final d = doc.data() as Map<String, dynamic>;
    return Donation(
      id: doc.id,
      donorName: d['donorName'] ?? '',
      amount: (d['amount'] ?? 0).toDouble(),
      date: (d['date'] as Timestamp).toDate(),
      type: d['type'] ?? 'Cash',
      notes: d['notes'] ?? '',
    );
  }

  Map<String, dynamic> toFirestore() => {
    'donorName': donorName,
    'amount': amount,
    'date': Timestamp.fromDate(date),
    'type': type,
    'notes': notes,
  };

  Donation copyWith({
    String? donorName,
    double? amount,
    DateTime? date,
    String? type,
    String? notes,
  }) => Donation(
    id: id,
    donorName: donorName ?? this.donorName,
    amount: amount ?? this.amount,
    date: date ?? this.date,
    type: type ?? this.type,
    notes: notes ?? this.notes,
  );
}
