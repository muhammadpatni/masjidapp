// lib/widgets/shared_widgets.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../theme/app_theme.dart';

// ── Currency formatter ──────────────────────────────
String fmtPKR(double n) {
  final f = NumberFormat('#,##0', 'en_US');
  return 'PKR ${f.format(n)}';
}

String fmtDate(DateTime d) => DateFormat('dd MMM yyyy').format(d);

// ── Stat Card ───────────────────────────────────────
class StatCard extends StatelessWidget {
  final String label;
  final String value;
  final String icon;
  final Color  color;
  final String? sub;

  const StatCard({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
    this.sub,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04),
              blurRadius: 8, offset: const Offset(0, 2)),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48, height: 48,
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(icon, style: const TextStyle(fontSize: 22)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: const TextStyle(
                        color: AppColors.textLight, fontSize: 12,
                        fontWeight: FontWeight.w500)),
                const SizedBox(height: 2),
                Text(value,
                    style: TextStyle(
                        color: color, fontSize: 16,
                        fontWeight: FontWeight.w700),
                    maxLines: 1, overflow: TextOverflow.ellipsis),
                if (sub != null)
                  Text(sub!,
                      style: const TextStyle(
                          color: AppColors.textLight, fontSize: 11)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Section Card ────────────────────────────────────
class SectionCard extends StatelessWidget {
  final String title;
  final Widget child;
  final Widget? trailing;

  const SectionCard({
    super.key,
    required this.title,
    required this.child,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
            child: Row(
              children: [
                Expanded(
                  child: Text(title,
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary)),
                ),
                if (trailing != null) trailing!,
              ],
            ),
          ),
          const Divider(height: 1),
          child,
        ],
      ),
    );
  }
}

// ── Badge ────────────────────────────────────────────
class AppBadge extends StatelessWidget {
  final String text;
  final Color  color;
  final Color  bg;

  const AppBadge({
    super.key,
    required this.text,
    required this.color,
    required this.bg,
  });

  factory AppBadge.donationType(String type) {
    switch (type) {
      case 'Cash':   return AppBadge(text: type, color: const Color(0xFF1a5c2a), bg: const Color(0xFFe8f5ec));
      case 'Online': return AppBadge(text: type, color: const Color(0xFF2980b9), bg: const Color(0xFFe8f4fb));
      default:       return AppBadge(text: type, color: const Color(0xFFd4a017), bg: const Color(0xFFFEF9E7));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(text,
          style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w600)),
    );
  }
}

// ── Amount Pill ──────────────────────────────────────
class AmountPill extends StatelessWidget {
  final double amount;
  final bool   isExpense;

  const AmountPill({super.key, required this.amount, this.isExpense = false});

  @override
  Widget build(BuildContext context) {
    final color = isExpense ? AppColors.danger : AppColors.success;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(fmtPKR(amount),
          style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w700)),
    );
  }
}

// ── Loading Widget ───────────────────────────────────
class LoadingWidget extends StatelessWidget {
  final String? message;
  const LoadingWidget({super.key, this.message});

  @override
  Widget build(BuildContext context) => Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const CircularProgressIndicator(color: AppColors.primary),
        if (message != null) ...[
          const SizedBox(height: 12),
          Text(message!, style: const TextStyle(color: AppColors.textLight)),
        ],
      ],
    ),
  );
}

// ── Empty State ──────────────────────────────────────
class EmptyState extends StatelessWidget {
  final String icon;
  final String message;
  final VoidCallback? onAdd;
  final String addLabel;

  const EmptyState({
    super.key,
    required this.icon,
    required this.message,
    this.onAdd,
    this.addLabel = 'Add New',
  });

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(icon, style: const TextStyle(fontSize: 48)),
          const SizedBox(height: 12),
          Text(message,
              style: const TextStyle(color: AppColors.textLight, fontSize: 14),
              textAlign: TextAlign.center),
          if (onAdd != null) ...[
            const SizedBox(height: 16),
            ElevatedButton(onPressed: onAdd, child: Text(addLabel)),
          ],
        ],
      ),
    ),
  );
}

// ── Progress Bar ─────────────────────────────────────
class ProgressBar extends StatelessWidget {
  final int pct;
  final bool overBudget;

  const ProgressBar({super.key, required this.pct, this.overBudget = false});

  @override
  Widget build(BuildContext context) {
    final color = overBudget ? AppColors.danger
        : pct > 75 ? AppColors.warning : AppColors.primary;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Progress',
                style: TextStyle(color: AppColors.textLight, fontSize: 12)),
            Text('$pct%${overBudget ? ' ⚠️' : ''}',
                style: TextStyle(
                    color: overBudget ? AppColors.danger : AppColors.textLight,
                    fontSize: 12, fontWeight: FontWeight.w600)),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: pct / 100,
            backgroundColor: AppColors.border,
            valueColor: AlwaysStoppedAnimation(color),
            minHeight: 7,
          ),
        ),
      ],
    );
  }
}

// ── Form Label ───────────────────────────────────────
class FormLabel extends StatelessWidget {
  final String text;
  const FormLabel(this.text, {super.key});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 6),
    child: Text(text,
        style: const TextStyle(
            fontSize: 13, fontWeight: FontWeight.w600,
            color: AppColors.textPrimary)),
  );
}

// ── Confirm Delete ───────────────────────────────────
Future<bool> confirmDelete(BuildContext ctx, String item) async {
  return await showDialog<bool>(
    context: ctx,
    builder: (_) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Text('Confirm Delete'),
      content: Text('Delete this $item? This cannot be undone.'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx, false),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () => Navigator.pop(ctx, true),
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.danger),
          child: const Text('Delete'),
        ),
      ],
    ),
  ) ?? false;
}

// ── Month Selector ───────────────────────────────────
class MonthSelectorRow extends StatelessWidget {
  final DateTime month;
  final VoidCallback onPrev;
  final VoidCallback onNext;

  const MonthSelectorRow({
    super.key,
    required this.month,
    required this.onPrev,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    final label = DateFormat('MMMM yyyy').format(month);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: onPrev,
            child: const Icon(Icons.chevron_left, color: AppColors.primary),
          ),
          const SizedBox(width: 8),
          Text(label,
              style: const TextStyle(
                  fontWeight: FontWeight.w600, fontSize: 13,
                  color: AppColors.textPrimary)),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: onNext,
            child: const Icon(Icons.chevron_right, color: AppColors.primary),
          ),
        ],
      ),
    );
  }
}
