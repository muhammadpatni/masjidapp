import 'package:cloud_firestore/cloud_firestore.dart';

const List<String> kProjectStatuses = ['Planning', 'Ongoing', 'Completed'];

class ProjectModel {
  final String? id;
  final String name;
  final String description;
  final double totalBudget;
  final double amountSpent;
  final String status;
  final DateTime? startDate;
  final DateTime? endDate;

  const ProjectModel({
    this.id,
    required this.name,
    required this.totalBudget,
    this.description  = '',
    this.amountSpent  = 0,
    this.status       = 'Planning',
    this.startDate,
    this.endDate,
  });

  double get remaining  => totalBudget - amountSpent;
  bool   get isOverBudget => amountSpent > totalBudget;
  double get progressPct =>
      totalBudget > 0 ? (amountSpent / totalBudget).clamp(0.0, 1.0) : 0;

  factory ProjectModel.fromFirestore(DocumentSnapshot doc) {
    final d = doc.data() as Map<String, dynamic>;
    DateTime? parseTs(dynamic v) =>
        v is Timestamp ? v.toDate() : null;
    return ProjectModel(
      id:          doc.id,
      name:        d['name']        ?? '',
      description: d['description'] ?? '',
      totalBudget: (d['totalBudget'] as num?)?.toDouble() ?? 0,
      amountSpent: (d['amountSpent'] as num?)?.toDouble() ?? 0,
      status:      d['status']      ?? 'Planning',
      startDate:   parseTs(d['startDate']),
      endDate:     parseTs(d['endDate']),
    );
  }

  Map<String, dynamic> toMap() => {
    'name':        name,
    'description': description,
    'totalBudget': totalBudget,
    'amountSpent': amountSpent,
    'status':      status,
    if (startDate != null) 'startDate': Timestamp.fromDate(startDate!),
    if (endDate   != null) 'endDate':   Timestamp.fromDate(endDate!),
    'createdAt':   FieldValue.serverTimestamp(),
  };

  ProjectModel copyWith({
    String? name, String? description, double? totalBudget,
    double? amountSpent, String? status,
    DateTime? startDate, DateTime? endDate,
  }) => ProjectModel(
    id:          id,
    name:        name        ?? this.name,
    description: description ?? this.description,
    totalBudget: totalBudget ?? this.totalBudget,
    amountSpent: amountSpent ?? this.amountSpent,
    status:      status      ?? this.status,
    startDate:   startDate   ?? this.startDate,
    endDate:     endDate     ?? this.endDate,
  );
}
