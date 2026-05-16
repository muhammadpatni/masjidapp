// import 'package:flutter/material.dart';
// import '../constants/app_theme.dart';

// class StatCard extends StatelessWidget {
//   final String label;
//   final String value;
//   final String icon;
//   final Color accentColor;
//   final String? subtitle;

//   const StatCard({
//     super.key,
//     required this.label,
//     required this.value,
//     required this.icon,
//     required this.accentColor,
//     this.subtitle,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       child: Container(
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(12),
//           border: Border(left: BorderSide(color: accentColor, width: 3.5)),
//         ),
//         padding: const EdgeInsets.all(14),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           mainAxisSize: MainAxisSize.min, // ← don't stretch vertically
//           children: [
//             // Icon bubble
//             Container(
//               width: 40,
//               height: 40,
//               decoration: BoxDecoration(
//                 color: accentColor.withOpacity(0.12),
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               child: Center(
//                 child: Text(icon, style: const TextStyle(fontSize: 20)),
//               ),
//             ),
//             const SizedBox(height: 10),

//             // Label — never overflows
//             Text(
//               label.toUpperCase(),
//               style: const TextStyle(
//                 fontSize: 10,
//                 fontWeight: FontWeight.w700,
//                 color: kTextLight,
//                 letterSpacing: 0.5,
//               ),
//               maxLines: 1,
//               overflow: TextOverflow.ellipsis,
//             ),
//             const SizedBox(height: 4),

//             // Value — scales down if font size is large
//             FittedBox(
//               fit: BoxFit.scaleDown,
//               alignment: Alignment.centerLeft,
//               child: Text(
//                 value,
//                 style: TextStyle(
//                   fontSize: 17,
//                   fontWeight: FontWeight.w800,
//                   color: accentColor,
//                   height: 1.2,
//                 ),
//               ),
//             ),

//             if (subtitle != null) ...[
//               const SizedBox(height: 3),
//               Text(
//                 subtitle!,
//                 style: const TextStyle(fontSize: 11, color: kTextMuted),
//                 maxLines: 2,
//                 overflow: TextOverflow.ellipsis,
//               ),
//             ],
//           ],
//         ),
//       ),
//     );
//   }
// }

// import 'dart:ui';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import '../constants/app_theme.dart';

// class StatCard extends StatelessWidget {
//   final String label;
//   final String value;
//   final String icon;
//   final Color accentColor;
//   final String? subtitle;

//   const StatCard({
//     super.key,
//     required this.label,
//     required this.value,
//     required this.icon,
//     required this.accentColor,
//     this.subtitle,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return ClipRRect(
//       borderRadius: BorderRadius.circular(16),
//       child: BackdropFilter(
//         filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
//         child: Container(
//           decoration: BoxDecoration(
//             color: Colors.white.withOpacity(0.04),
//             borderRadius: BorderRadius.circular(16),
//             border: Border(
//               left: BorderSide(color: accentColor, width: 4),
//               top: BorderSide(color: Colors.white.withOpacity(0.05)),
//               right: BorderSide(color: Colors.white.withOpacity(0.05)),
//               bottom: BorderSide(color: Colors.white.withOpacity(0.05)),
//             ),
//           ),
//           padding: const EdgeInsets.all(14),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               // Icon bubble
//               Container(
//                 width: 42,
//                 height: 42,
//                 decoration: BoxDecoration(
//                   color: accentColor.withOpacity(0.12),
//                   borderRadius: BorderRadius.circular(12),
//                   border: Border.all(
//                     color: accentColor.withOpacity(0.2),
//                     width: 1,
//                   ),
//                 ),
//                 child: Center(
//                   child: Text(icon, style: const TextStyle(fontSize: 22)),
//                 ),
//               ),
//               const SizedBox(height: 10),

//               // Label
//               Text(
//                 label.toUpperCase(),
//                 style: GoogleFonts.cairo(
//                   fontSize: 10,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.white70,
//                   letterSpacing: 0.6,
//                 ),
//                 maxLines: 2,
//                 overflow: TextOverflow.ellipsis,
//               ),
//               const SizedBox(height: 4),

//               // Value — always visible on dark bg
//               FittedBox(
//                 fit: BoxFit.scaleDown,
//                 alignment: Alignment.centerLeft,
//                 child: Text(
//                   value,
//                   style: GoogleFonts.cairo(
//                     fontSize: 16,
//                     fontWeight: FontWeight.w900,
//                     color: accentColor,
//                     height: 1.2,
//                   ),
//                 ),
//               ),

//               if (subtitle != null) ...[
//                 const SizedBox(height: 4),
//                 Text(
//                   subtitle!,
//                   style: GoogleFonts.cairo(
//                     fontSize: 11,
//                     color: Colors.white54,
//                     height: 1.2,
//                   ),
//                   maxLines: 2,
//                   overflow: TextOverflow.ellipsis,
//                 ),
//               ],
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StatCard extends StatelessWidget {
  final String label;
  final String value;
  final String icon;
  final Color accentColor;
  final String subtitle;

  const StatCard({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    required this.accentColor,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(
          0.03,
        ), // Same premium glass look as your banner
        borderRadius: BorderRadius.circular(16),
        border: Border.fromBorderSide(
          BorderSide(color: Colors.white.withOpacity(0.04)),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment:
            MainAxisAlignment.spaceBetween, // Ensures distribution
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  label,
                  style: GoogleFonts.cairo(
                    color: Colors.white60,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(icon, style: const TextStyle(fontSize: 16)),
            ],
          ),
          const SizedBox(height: 8),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              style: GoogleFonts.cairo(
                color: accentColor, // Proper visibility green/red/blue
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: GoogleFonts.cairo(color: Colors.white38, fontSize: 10),
          ),
        ],
      ),
    );
  }
}
