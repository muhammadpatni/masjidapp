// lib/widgets/shared_widgets.dart
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

// ── Currency formatter (Logic strictly untouched) ──────────────────────────────
String fmtPKR(double n) {
  final f = NumberFormat('#,##0', 'en_US');
  return 'PKR ${f.format(n)}';
}

String fmtDate(DateTime d) => DateFormat('dd MMM yyyy').format(d);

// ── Stat Card (Redesigned with Premium Glassmorphism) ───────────────────────────────
class StatCard extends StatelessWidget {
  final String label;
  final String value;
  final String icon;
  final Color color;
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
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surface, // Uses your transparent glass surface
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppColors.border, width: 1.2),
          ),
          child: Row(
            children: [
              // Beautiful Glowing Back-bubble for the Icon/Emoji
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: color.withOpacity(0.25), width: 1),
                ),
                child: Center(
                  child: Text(icon, style: const TextStyle(fontSize: 24)),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: GoogleFonts.cairo(
                        color: AppColors.textLight,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      value,
                      style: GoogleFonts.cairo(
                        color: AppColors.gold, // Changed to elegant gold accent
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        height: 1.3,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (sub != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        sub!,
                        style: GoogleFonts.cairo(
                          color: AppColors.textLight.withOpacity(0.6),
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Section Card (Elegant Container for Inner Widgets) ────────────────────────────
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
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.border, width: 1.2),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: GoogleFonts.cairo(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: AppColors
                              .gold, // Section titles pop beautifully in Gold
                          letterSpacing: 0.3,
                        ),
                      ),
                    ),
                    ?trailing,
                  ],
                ),
              ),
              const Divider(height: 1, thickness: 1),
              child,
            ],
          ),
        ),
      ),
    );
  }
}

// ── Badge (Glow & Outlined Style for Lists) ────────────────────────────────────────────
class AppBadge extends StatelessWidget {
  final String text;
  final Color color;
  final Color bg;

  const AppBadge({
    super.key,
    required this.text,
    required this.color,
    required this.bg,
  });

  factory AppBadge.donationType(String type) {
    switch (type) {
      case 'Cash':
        return const AppBadge(
          text: 'Cash',
          color: Color(0xFF2ECC71), // Vibrant Green
          bg: Color(0x1F2ECC71), // Low Opacity Tint
        );
      case 'Online':
        return const AppBadge(
          text: 'Online',
          color: Color(0xFF3498DB), // Sky Blue
          bg: Color(0x1F3498DB),
        );
      default:
        return const AppBadge(
          text: 'Other',
          color: Color(0xFFD4AF37), // Pure Islamic Gold
          bg: Color(0x1FD4AF37),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3), width: 1),
      ),
      child: Text(
        text,
        style: GoogleFonts.cairo(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

// ── Amount Pill (Glowing Amount Highlights) ──────────────────────────────────────
class AmountPill extends StatelessWidget {
  final double amount;
  final bool isExpense;

  const AmountPill({super.key, required this.amount, this.isExpense = false});

  @override
  Widget build(BuildContext context) {
    final color = isExpense ? AppColors.danger : AppColors.success;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3), width: 1),
      ),
      child: Text(
        fmtPKR(amount),
        style: GoogleFonts.cairo(
          color: isExpense ? const Color(0xFFFF6B6B) : const Color(0xFF2ECC71),
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
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
        const CircularProgressIndicator(color: AppColors.gold),
        if (message != null) ...[
          const SizedBox(height: 14),
          Text(
            message!,
            style: GoogleFonts.cairo(color: AppColors.textLight, fontSize: 13),
          ),
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
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.gold.withOpacity(0.06),
              shape: BoxShape.circle,
            ),
            child: Text(icon, style: const TextStyle(fontSize: 48)),
          ),
          const SizedBox(height: 14),
          Text(
            message,
            style: GoogleFonts.cairo(color: AppColors.textLight, fontSize: 14),
            textAlign: TextAlign.center,
          ),
          if (onAdd != null) ...[
            const SizedBox(height: 18),
            ElevatedButton(
              onPressed: onAdd,
              child: Text(
                addLabel,
                style: GoogleFonts.cairo(fontWeight: FontWeight.bold),
              ),
            ),
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
    final color = overBudget
        ? AppColors.danger
        : pct > 75
        ? AppColors.warning
        : const Color(0xFF2ECC71); // Clean Islamic Green for normal progress

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Progress',
              style: GoogleFonts.cairo(
                color: AppColors.textLight,
                fontSize: 13,
              ),
            ),
            Text(
              '$pct%${overBudget ? ' ⚠️' : ''}',
              style: GoogleFonts.cairo(
                color: overBudget ? AppColors.danger : AppColors.gold,
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: LinearProgressIndicator(
            value: pct / 100,
            backgroundColor: Colors.white.withOpacity(0.08),
            valueColor: AlwaysStoppedAnimation(color),
            minHeight: 8,
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
    child: Text(
      text,
      style: GoogleFonts.cairo(
        fontSize: 13,
        fontWeight: FontWeight.bold,
        color: AppColors.gold, // Matches premium gold sub-titles
      ),
    ),
  );
}

// ── Confirm Delete (Beautiful Dark Dialog) ───────────────────────────────────
Future<bool> confirmDelete(BuildContext ctx, String item) async {
  return await showDialog<bool>(
        context: ctx,
        builder: (_) => BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: AlertDialog(
            backgroundColor: AppColors.navBg, // High deep dark backdrop surface
            surfaceTintColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: BorderSide(color: AppColors.border, width: 1),
            ),
            title: Text(
              'Confirm Delete',
              style: GoogleFonts.cairo(
                color: AppColors.gold,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: Text(
              'Delete this $item? This cannot be undone.',
              style: GoogleFonts.cairo(color: Colors.white70, fontSize: 14),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: Text(
                  'Cancel',
                  style: GoogleFonts.cairo(
                    color: AppColors.textLight,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(ctx, true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.danger,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(90, 38),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  'Delete',
                  style: GoogleFonts.cairo(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ) ??
      false;
}

// ── Month Selector (Transparent Inline Navigator) ───────────────────────────────────
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
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.04), // Glass background element
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border, width: 1),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: onPrev,
                child: const Icon(
                  Icons.chevron_left,
                  color: AppColors.gold,
                  size: 22,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                label,
                style: GoogleFonts.cairo(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: onNext,
                child: const Icon(
                  Icons.chevron_right,
                  color: AppColors.gold,
                  size: 22,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
