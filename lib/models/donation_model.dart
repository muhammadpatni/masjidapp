import 'package:cloud_firestore/cloud_firestore.dart';

class DonationModel {
  final String? id;
  final String donorName;
  final double amount;
  final DateTime date;
  final String type;   // Cash | Online | Cheque
  final String notes;
  final String month;  // YYYY-MM  (auto-computed)

  DonationModel({
    this.id,
    required this.donorName,
    required this.amount,
    required this.date,
    required this.type,
    this.notes = '',
  }) : month = '${date.year}-${date.month.toString().padLeft(2, '0')}';

  // ── Firestore → Model ──────────────────────
  factory DonationModel.fromFirestore(DocumentSnapshot doc) {
    final d = doc.data() as Map<String, dynamic>;
    final ts = d['date'];
    final DateTime dt =
        ts is Timestamp ? ts.toDate() : DateTime.tryParse(ts ?? '') ?? DateTime.now();
    return DonationModel(
      id:        doc.id,
      donorName: d['donorName'] ?? '',
      amount:    (d['amount'] as num?)?.toDouble() ?? 0,
      date:      dt,
      type:      d['type'] ?? 'Cash',
      notes:     d['notes'] ?? '',
    );
  }

  // ── Model → Firestore ──────────────────────
  Map<String, dynamic> toMap() => {
    'donorName': donorName,
    'amount':    amount,
    'date':      Timestamp.fromDate(date),
    'type':      type,
    'notes':     notes,
    'month':     month,
    'createdAt': FieldValue.serverTimestamp(),
  };

  DonationModel copyWith({
    String? donorName, double? amount, DateTime? date,
    String? type, String? notes,
  }) => DonationModel(
    id:        id,
    donorName: donorName ?? this.donorName,
    amount:    amount    ?? this.amount,
    date:      date      ?? this.date,
    type:      type      ?? this.type,
    notes:     notes     ?? this.notes,
  );
}
