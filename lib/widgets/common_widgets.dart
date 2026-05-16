// import 'package:flutter/material.dart';
// import '../constants/app_theme.dart';

// // ─── Loading ──────────────────────────────────
// class LoadingWidget extends StatelessWidget {
//   final String? message;
//   const LoadingWidget({super.key, this.message});

//   @override
//   Widget build(BuildContext context) => Center(
//     child: Column(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         const CircularProgressIndicator(color: kPrimary),
//         if (message != null) ...[
//           const SizedBox(height: 12),
//           Text(message!, style: const TextStyle(color: kTextLight)),
//         ],
//       ],
//     ),
//   );
// }

// // ─── Empty State ──────────────────────────────
// class EmptyState extends StatelessWidget {
//   final String emoji;
//   final String title;
//   final String? subtitle;
//   final VoidCallback? onAction;
//   final String? actionLabel;

//   const EmptyState({
//     super.key,
//     required this.emoji,
//     required this.title,
//     this.subtitle,
//     this.onAction,
//     this.actionLabel,
//   });

//   @override
//   Widget build(BuildContext context) => Center(
//     child: Padding(
//       padding: const EdgeInsets.all(32),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Text(emoji, style: const TextStyle(fontSize: 52)),
//           const SizedBox(height: 14),
//           Text(
//             title,
//             style: const TextStyle(
//               fontSize: 16,
//               fontWeight: FontWeight.w600,
//               color: kTextLight,
//             ),
//             textAlign: TextAlign.center,
//           ),
//           if (subtitle != null) ...[
//             const SizedBox(height: 6),
//             Text(
//               subtitle!,
//               style: const TextStyle(fontSize: 13, color: kTextMuted),
//               textAlign: TextAlign.center,
//             ),
//           ],
//           if (onAction != null) ...[
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: onAction,
//               style: ElevatedButton.styleFrom(minimumSize: const Size(160, 44)),
//               child: Text(actionLabel ?? 'Add Now'),
//             ),
//           ],
//         ],
//       ),
//     ),
//   );
// }

// // ─── Section Header ───────────────────────────
// class SectionHeader extends StatelessWidget {
//   final String title;
//   final String? action;
//   final VoidCallback? onAction;

//   const SectionHeader({
//     super.key,
//     required this.title,
//     this.action,
//     this.onAction,
//   });

//   @override
//   Widget build(BuildContext context) => Row(
//     children: [
//       Expanded(
//         child: Text(
//           title,
//           style: const TextStyle(
//             fontSize: 15,
//             fontWeight: FontWeight.w700,
//             color: kPrimaryDark,
//           ),
//           overflow: TextOverflow.ellipsis,
//         ),
//       ),
//       if (action != null)
//         TextButton(
//           onPressed: onAction,
//           style: TextButton.styleFrom(
//             foregroundColor: kPrimary,
//             padding: const EdgeInsets.symmetric(horizontal: 8),
//             minimumSize: Size.zero,
//             tapTargetSize: MaterialTapTargetSize.shrinkWrap,
//           ),
//           child: Text(action!, style: const TextStyle(fontSize: 12)),
//         ),
//     ],
//   );
// }

// // ─── Amount Badge ─────────────────────────────
// class AmountBadge extends StatelessWidget {
//   final String text;
//   final bool isExpense;

//   const AmountBadge(this.text, {super.key, this.isExpense = false});

//   @override
//   Widget build(BuildContext context) => Container(
//     padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
//     decoration: BoxDecoration(
//       color: isExpense ? const Color(0xFFFDECEA) : const Color(0xFFE8F5EC),
//       borderRadius: BorderRadius.circular(20),
//     ),
//     child: FittedBox(
//       fit: BoxFit.scaleDown,
//       child: Text(
//         text,
//         style: TextStyle(
//           fontSize: 12,
//           fontWeight: FontWeight.w700,
//           color: isExpense ? kDanger : kSuccess,
//         ),
//       ),
//     ),
//   );
// }

// // ─── Month Navigator ──────────────────────────
// class MonthNavigator extends StatelessWidget {
//   final String label;
//   final VoidCallback onPrev;
//   final VoidCallback onNext;

//   const MonthNavigator({
//     super.key,
//     required this.label,
//     required this.onPrev,
//     required this.onNext,
//   });

//   @override
//   Widget build(BuildContext context) => Container(
//     margin: const EdgeInsets.only(bottom: 16),
//     padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//     decoration: BoxDecoration(
//       color: kPrimary,
//       borderRadius: BorderRadius.circular(10),
//     ),
//     child: Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         IconButton(
//           onPressed: onPrev,
//           icon: const Icon(Icons.chevron_left, color: Colors.white),
//           padding: EdgeInsets.zero,
//           constraints: const BoxConstraints(),
//         ),
//         Flexible(
//           child: Text(
//             label,
//             style: const TextStyle(
//               color: Colors.white,
//               fontWeight: FontWeight.w600,
//               fontSize: 14,
//             ),
//             overflow: TextOverflow.ellipsis,
//           ),
//         ),
//         IconButton(
//           onPressed: onNext,
//           icon: const Icon(Icons.chevron_right, color: Colors.white),
//           padding: EdgeInsets.zero,
//           constraints: const BoxConstraints(),
//         ),
//       ],
//     ),
//   );
// }

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_theme.dart'; // Isme kGold, kPrimary, wagera defined hain

// ─── Loading ──────────────────────────────────
class LoadingWidget extends StatelessWidget {
  final String? message;
  const LoadingWidget({super.key, this.message});

  @override
  Widget build(BuildContext context) => Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Elegant Metallic Gold Loader
        const CircularProgressIndicator(color: kGold),
        if (message != null) ...[
          const SizedBox(height: 14),
          Text(
            message!,
            style: GoogleFonts.cairo(
              color: kTextLight,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ],
    ),
  );
}

// ─── Empty State ──────────────────────────────
class EmptyState extends StatelessWidget {
  final String emoji;
  final String title;
  final String? subtitle;
  final VoidCallback? onAction;
  final String? actionLabel;

  const EmptyState({
    super.key,
    required this.emoji,
    required this.title,
    this.subtitle,
    this.onAction,
    this.actionLabel,
  });

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(32),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.04), // Soft glass container
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: kBorder, width: 1),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Cleaned up the emoji vibe with subtle glow background
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: kGold.withOpacity(0.08),
                    shape: BoxShape.circle,
                  ),
                  child: Text(emoji, style: const TextStyle(fontSize: 48)),
                ),
                const SizedBox(height: 16),
                Text(
                  title,
                  style: GoogleFonts.cairo(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 6),
                  Text(
                    subtitle!,
                    style: GoogleFonts.cairo(fontSize: 13, color: kTextLight),
                    textAlign: TextAlign.center,
                  ),
                ],
                if (onAction != null) ...[
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: onAction,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(160, 46),
                      backgroundColor: kGold,
                      foregroundColor: kPrimaryDark,
                    ),
                    child: Text(
                      actionLabel ?? 'Add Now',
                      style: GoogleFonts.cairo(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

// ─── Section Header ───────────────────────────
class SectionHeader extends StatelessWidget {
  final String title;
  final String? action;
  final VoidCallback? onAction;

  const SectionHeader({
    super.key,
    required this.title,
    this.action,
    this.onAction,
    required TextStyle titleStyle,
    required TextStyle actionStyle,
  });

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Expanded(
        child: Text(
          title,
          style: GoogleFonts.cairo(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: kGold, // Gold highlights for headings
            letterSpacing: 0.3,
          ),
          overflow: TextOverflow.ellipsis,
        ),
      ),
      if (action != null)
        TextButton(
          onPressed: onAction,
          style: TextButton.styleFrom(
            foregroundColor: kGold.withOpacity(0.9),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text(
            action!,
            style: GoogleFonts.cairo(fontSize: 13, fontWeight: FontWeight.w600),
          ),
        ),
    ],
  );
}

// ─── Amount Badge ─────────────────────────────
class AmountBadge extends StatelessWidget {
  final String text;
  final bool isExpense;

  const AmountBadge(this.text, {super.key, this.isExpense = false});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    decoration: BoxDecoration(
      // Smooth glowing effect instead of solid boxes
      color: isExpense ? kDanger.withOpacity(0.12) : kSuccess.withOpacity(0.15),
      borderRadius: BorderRadius.circular(30),
      border: Border.all(
        color: isExpense ? kDanger.withOpacity(0.3) : kSuccess.withOpacity(0.4),
        width: 1,
      ),
    ),
    child: FittedBox(
      fit: BoxFit.scaleDown,
      child: Text(
        text,
        style: GoogleFonts.cairo(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: isExpense ? const Color(0xFFFF6B6B) : const Color(0xFF2ECC71),
        ),
      ),
    ),
  );
}

// ─── Month Navigator ──────────────────────────
class MonthNavigator extends StatelessWidget {
  final String label;
  final VoidCallback onPrev;
  final VoidCallback onNext;

  const MonthNavigator({
    super.key,
    required this.label,
    required this.onPrev,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) => ClipRRect(
    borderRadius: BorderRadius.circular(14),
    child: BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.06), // Frosted glass nav bar
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: kBorder, width: 1.2),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: onPrev,
              icon: const Icon(Icons.chevron_left, color: kGold, size: 26),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
            Flexible(
              child: Text(
                label,
                style: GoogleFonts.cairo(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  letterSpacing: 0.5,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            IconButton(
              onPressed: onNext,
              icon: const Icon(Icons.chevron_right, color: kGold, size: 26),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ],
        ),
      ),
    ),
  );
}
