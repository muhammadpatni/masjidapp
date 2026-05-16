// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../constants/app_theme.dart';
// import '../providers/app_provider.dart';
// import '../providers/donation_provider.dart';
// import '../providers/expense_provider.dart';
// import '../providers/project_provider.dart';
// import '../widgets/stat_card.dart';
// import '../widgets/common_widgets.dart';

// class DashboardScreen extends StatelessWidget {
//   const DashboardScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final app = context.watch<AppProvider>();
//     final donations = context.watch<DonationProvider>();
//     final expenses = context.watch<ExpenseProvider>();
//     final projects = context.watch<ProjectProvider>();

//     final month = app.selectedMonth;
//     final donTotal = donations.totalAllTime;
//     final expTotal = expenses.totalAllTime;
//     final projSpent = projects.totalSpent;
//     final balance = donTotal - expTotal - projSpent;
//     final mDonations = donations.totalForMonth(month);
//     final mExpenses = expenses.totalForMonth(month);

//     return Scaffold(
//       appBar: AppBar(
//         title: const Row(
//           children: [
//             Text('☪  ', style: TextStyle(fontSize: 20)),
//             Text('Masjid Dashboard'),
//           ],
//         ),
//       ),
//       body: RefreshIndicator(
//         color: kPrimary,
//         onRefresh: () async {}, // streams auto-refresh
//         child: ListView(
//           padding: const EdgeInsets.all(16),
//           children: [
//             // ── Month navigator ──────────────
//             MonthNavigator(
//               label: app.selectedMonthLabel,
//               onPrev: app.prevMonth,
//               onNext: app.nextMonth,
//             ),

//             // ── Balance Banner ───────────────
//             _BalanceBanner(
//               balance: balance,
//               totalDon: donTotal,
//               totalExp: expTotal,
//               projSpent: projSpent,
//             ),
//             const SizedBox(height: 16),

//             // ── Stat grid ────────────────────
//             const SectionHeader(title: 'Monthly Summary'),
//             const SizedBox(height: 10),
//             _StatsGrid(
//               mDonations: mDonations,
//               mExpenses: mExpenses,
//               activeProjects: projects.active.length,
//               totalProjects: projects.all.length,
//             ),
//             const SizedBox(height: 20),

//             // ── Recent Donations ─────────────
//             SectionHeader(
//               title: 'Recent Donations',
//               action: 'See all →',
//               onAction: () {},
//             ),
//             const SizedBox(height: 8),
//             if (donations.loading)
//               const LoadingWidget()
//             else if (donations.recent.isEmpty)
//               const EmptyState(emoji: '🤲', title: 'No donations yet')
//             else
//               ...donations.recent.map((d) => _DonationTile(d)),

//             const SizedBox(height: 20),

//             // ── Recent Expenses ──────────────
//             SectionHeader(
//               title: 'Recent Expenses',
//               action: 'See all →',
//               onAction: () {},
//             ),
//             const SizedBox(height: 8),
//             if (expenses.loading)
//               const LoadingWidget()
//             else if (expenses.recent.isEmpty)
//               const EmptyState(emoji: '🧾', title: 'No expenses yet')
//             else
//               ...expenses.recent.map((e) => _ExpenseTile(e)),

//             const SizedBox(height: 20),

//             // ── Active Projects ──────────────
//             if (projects.active.isNotEmpty) ...[
//               const SectionHeader(title: '🏗️  Active Projects'),
//               const SizedBox(height: 8),
//               ...projects.active.map((p) => _ProjectTile(p)),
//               const SizedBox(height: 16),
//             ],
//           ],
//         ),
//       ),
//     );
//   }
// }

// // ─── Balance Banner ───────────────────────────
// class _BalanceBanner extends StatelessWidget {
//   final double balance, totalDon, totalExp, projSpent;
//   const _BalanceBanner({
//     required this.balance,
//     required this.totalDon,
//     required this.totalExp,
//     required this.projSpent,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         gradient: const LinearGradient(
//           colors: [kPrimaryDark, kPrimary],
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//         ),
//         borderRadius: BorderRadius.circular(14),
//         boxShadow: [
//           BoxShadow(
//             color: kPrimary.withOpacity(0.3),
//             blurRadius: 12,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Text(
//             'CURRENT BALANCE',
//             style: TextStyle(
//               color: Colors.white70,
//               fontSize: 11,
//               fontWeight: FontWeight.w600,
//               letterSpacing: 1,
//             ),
//           ),
//           const SizedBox(height: 6),
//           FittedBox(
//             fit: BoxFit.scaleDown,
//             alignment: Alignment.centerLeft,
//             child: Text(
//               fmtCurrency(balance),
//               style: const TextStyle(
//                 color: Colors.white,
//                 fontSize: 28,
//                 fontWeight: FontWeight.w800,
//               ),
//             ),
//           ),
//           const SizedBox(height: 14),
//           const Divider(color: Colors.white24, height: 1),
//           const SizedBox(height: 12),
//           // breakdown row
//           Row(
//             children: [
//               _BannerStat('Donations', fmtCurrency(totalDon), kGold),
//               const SizedBox(width: 12),
//               _BannerStat('Expenses', fmtCurrency(totalExp), Colors.redAccent),
//               const SizedBox(width: 12),
//               _BannerStat(
//                 'Projects',
//                 fmtCurrency(projSpent),
//                 Colors.orangeAccent,
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _BannerStat extends StatelessWidget {
//   final String label, value;
//   final Color color;
//   const _BannerStat(this.label, this.value, this.color);

//   @override
//   Widget build(BuildContext context) => Expanded(
//     child: Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           label,
//           style: const TextStyle(color: Colors.white54, fontSize: 10),
//           overflow: TextOverflow.ellipsis,
//         ),
//         const SizedBox(height: 2),
//         FittedBox(
//           fit: BoxFit.scaleDown,
//           alignment: Alignment.centerLeft,
//           child: Text(
//             value,
//             style: TextStyle(
//               color: color,
//               fontSize: 13,
//               fontWeight: FontWeight.w700,
//             ),
//           ),
//         ),
//       ],
//     ),
//   );
// }

// // ─── Stats Grid ───────────────────────────────
// class _StatsGrid extends StatelessWidget {
//   final double mDonations, mExpenses;
//   final int activeProjects, totalProjects;
//   const _StatsGrid({
//     required this.mDonations,
//     required this.mExpenses,
//     required this.activeProjects,
//     required this.totalProjects,
//   });

//   @override
//   Widget build(BuildContext context) {
//     // Responsive: 2 columns on narrow, 3 on wide
//     return LayoutBuilder(
//       builder: (_, constraints) {
//         final cols = constraints.maxWidth > 500 ? 3 : 2;
//         return GridView.count(
//           shrinkWrap: true,
//           physics: const NeverScrollableScrollPhysics(),
//           crossAxisCount: cols,
//           mainAxisSpacing: 12,
//           crossAxisSpacing: 12,
//           childAspectRatio: 1.05,
//           children: [
//             StatCard(
//               label: 'Monthly Donations',
//               value: fmtCurrency(mDonations),
//               icon: '📥',
//               accentColor: kSuccess,
//               subtitle: 'This month',
//             ),
//             StatCard(
//               label: 'Monthly Expenses',
//               value: fmtCurrency(mExpenses),
//               icon: '📤',
//               accentColor: kDanger,
//               subtitle: 'This month',
//             ),
//             StatCard(
//               label: 'Active Projects',
//               value: '$activeProjects / $totalProjects',
//               icon: '🏗️',
//               accentColor: kInfo,
//               subtitle: 'Ongoing',
//             ),
//           ],
//         );
//       },
//     );
//   }
// }

// // ─── Small Tiles ──────────────────────────────
// class _DonationTile extends StatelessWidget {
//   final dynamic d;
//   const _DonationTile(this.d);

//   @override
//   Widget build(BuildContext context) => Card(
//     margin: const EdgeInsets.only(bottom: 8),
//     child: ListTile(
//       dense: true,
//       leading: CircleAvatar(
//         backgroundColor: kPrimarySoft,
//         child: Text(
//           d.donorName.isNotEmpty ? d.donorName[0].toUpperCase() : '?',
//           style: const TextStyle(color: kPrimary, fontWeight: FontWeight.w700),
//         ),
//       ),
//       title: Text(
//         d.donorName,
//         style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
//         overflow: TextOverflow.ellipsis,
//         maxLines: 1,
//       ),
//       subtitle: Text(
//         '${d.type} • ${fmtDate(d.date)}',
//         style: const TextStyle(fontSize: 12, color: kTextLight),
//         overflow: TextOverflow.ellipsis,
//       ),
//       trailing: AmountBadge(fmtCurrency(d.amount)),
//     ),
//   );
// }

// class _ExpenseTile extends StatelessWidget {
//   final dynamic e;
//   const _ExpenseTile(this.e);

//   @override
//   Widget build(BuildContext context) => Card(
//     margin: const EdgeInsets.only(bottom: 8),
//     child: ListTile(
//       dense: true,
//       leading: CircleAvatar(
//         backgroundColor: const Color(0xFFFDECEA),
//         child: Text(
//           e.category.isNotEmpty ? e.category[0] : '?',
//           style: const TextStyle(color: kDanger, fontWeight: FontWeight.w700),
//         ),
//       ),
//       title: Text(
//         e.category,
//         style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
//         overflow: TextOverflow.ellipsis,
//         maxLines: 1,
//       ),
//       subtitle: Text(
//         e.description.isNotEmpty ? e.description : fmtDate(e.date),
//         style: const TextStyle(fontSize: 12, color: kTextLight),
//         overflow: TextOverflow.ellipsis,
//       ),
//       trailing: AmountBadge(fmtCurrency(e.amount), isExpense: true),
//     ),
//   );
// }

// class _ProjectTile extends StatelessWidget {
//   final dynamic p;
//   const _ProjectTile(this.p);

//   @override
//   Widget build(BuildContext context) => Card(
//     margin: const EdgeInsets.only(bottom: 8),
//     child: Padding(
//       padding: const EdgeInsets.all(14),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Expanded(
//                 child: Text(
//                   p.name,
//                   style: const TextStyle(
//                     fontWeight: FontWeight.w600,
//                     fontSize: 14,
//                   ),
//                   overflow: TextOverflow.ellipsis,
//                   maxLines: 1,
//                 ),
//               ),
//               const SizedBox(width: 8),
//               FittedBox(
//                 fit: BoxFit.scaleDown,
//                 child: Text(
//                   fmtCurrency(p.amountSpent),
//                   style: const TextStyle(
//                     color: kWarning,
//                     fontWeight: FontWeight.w700,
//                     fontSize: 13,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 8),
//           ClipRRect(
//             borderRadius: BorderRadius.circular(4),
//             child: LinearProgressIndicator(
//               value: p.progressPct,
//               minHeight: 6,
//               backgroundColor: kBorder,
//               color: p.isOverBudget ? kDanger : kPrimary,
//             ),
//           ),
//           const SizedBox(height: 4),
//           Row(
//             children: [
//               Flexible(
//                 child: Text(
//                   '${(p.progressPct * 100).toStringAsFixed(0)}% of ${fmtCurrency(p.totalBudget)}',
//                   style: const TextStyle(fontSize: 11, color: kTextMuted),
//                   overflow: TextOverflow.ellipsis,
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     ),
//   );
// }
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:masjidapp/screens/donations_screen.dart';
import 'package:masjidapp/screens/expenses_screen.dart';
import 'package:masjidapp/screens/projects_screen.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_theme.dart';
import '../providers/app_provider.dart';
import '../providers/donation_provider.dart';
import '../providers/expense_provider.dart';
import '../providers/project_provider.dart';
import '../widgets/stat_card.dart';
import '../widgets/common_widgets.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppProvider>();
    final donations = context.watch<DonationProvider>();
    final expenses = context.watch<ExpenseProvider>();
    final projects = context.watch<ProjectProvider>();

    final month = app.selectedMonth;
    final donTotal = donations.totalAllTime;
    final expTotal = expenses.totalAllTime;
    final projSpent = projects.totalSpent;
    final balance = donTotal - expTotal - projSpent;
    final mDonations = donations.totalForMonth(month);
    final mExpenses = expenses.totalForMonth(month);

    return Scaffold(
      backgroundColor: kPrimaryDark, // Enforced premium dark background
      // appBar: AppBar(
      //   backgroundColor: Colors.transparent,
      //   elevation: 0,
      //   surfaceTintColor: Colors.transparent,
      //   title: Row(
      //     children: [
      //       Text('☪ ', style: GoogleFonts.cairo(fontSize: 20, color: kGold)),
      //       Text(
      //         'Masjid Dashboard',
      //         style: GoogleFonts.cairo(
      //           fontWeight: FontWeight.bold,
      //           color: Colors.white,
      //         ),
      //       ),
      //     ],
      //   ),
      // ),
      appBar: AppBar(
        backgroundColor: kPrimaryDark.withOpacity(
          0.75,
        ), // Deep semi-transparent glass look
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        automaticallyImplyLeading: false,

        // Isse text aur icon default left edge se thoda aur right side par push ho jayenge
        titleSpacing: 10,

        // ─── Pure Glassmorphic Premium Background ───────────
        flexibleSpace: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.transparent,
                border: Border(
                  bottom: BorderSide(
                    color: Colors.white.withOpacity(
                      0.04,
                    ), // Barik premium bottom line
                    width: 0.8,
                  ),
                ),
              ),
            ),
          ),
        ),

        // ─── Balanced VIP Branding (Shifted Right) ───────────
        title: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Elegant Sleek Icon Box
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: kGold.withOpacity(0.06),
                borderRadius: BorderRadius.circular(
                  10,
                ), // Sharp rounded corners
                border: Border.fromBorderSide(
                  BorderSide(color: kGold.withOpacity(0.25), width: 1),
                ),
              ),
              child: Icon(
                Icons.account_balance_rounded,
                color: kGold,
                size: 16,
              ),
            ),

            // Yahan humne space badha kar text ko mazeed right side par push kiya hai
            const SizedBox(width: 16),

            // Clean & Professional Text Layout
            Row(
              crossAxisAlignment: CrossAxisAlignment
                  .center, // Text aur icon center line mein rahein
              children: [
                Text(
                  'Masjid App',
                  style: GoogleFonts.cairo(
                    fontWeight:
                        FontWeight.w800, // Balanced Bold (Ajeeb nahi lagega)
                    fontSize: 16,
                    color: Colors.white,
                    letterSpacing: 0.4,
                  ),
                ),

                // Dono text ke beech space taake alag aur classy lage
                const SizedBox(width: 8),

                // Separator line jo dono text ko divide karegi (VIP Look)
                Container(
                  width: 1,
                  height: 12,
                  color: Colors.white.withOpacity(0.15),
                ),

                const SizedBox(width: 8),

                Text(
                  'Dashboard',
                  style: GoogleFonts.cairo(
                    fontWeight: FontWeight.w500,
                    fontSize: 13,
                    color: kGold, // Clean visible gold color
                    letterSpacing: 0.4,
                  ),
                ),
              ],
            ),
          ],
        ),

        actions: const [SizedBox(width: 16)],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: const Alignment(-0.6, -0.7),
            radius: 1.2,
            colors: [kPrimary.withOpacity(0.15), kPrimaryDark],
          ),
        ),
        child: RefreshIndicator(
          color: kGold,
          backgroundColor: kPrimaryDark,
          onRefresh: () async {},
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            children: [
              // ── Month navigator ──────────────
              MonthNavigator(
                label: app.selectedMonthLabel,
                onPrev: app.prevMonth,
                onNext: app.nextMonth,
              ),
              const SizedBox(height: 14),

              // ── Balance Banner ───────────────
              _BalanceBanner(
                balance: balance,
                totalDon: donTotal,
                totalExp: expTotal,
                projSpent: projSpent,
              ),
              const SizedBox(height: 22),

              // ── Stat grid ────────────────────
              SectionHeader(
                title: 'Monthly Summary',
                action: '',
                onAction: () {},
                titleStyle: GoogleFonts.cairo(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                actionStyle: const TextStyle(color: Colors.transparent),
              ),

              _StatsGrid(
                mDonations: mDonations,
                mExpenses: mExpenses,
                activeProjects: projects.active.length,
                totalProjects: projects.all.length,
              ),

              // ── Recent Donations ─────────────
              SectionHeader(
                title: 'Recent Donations',
                action: 'See all →',
                onAction: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const DonationsScreen()),
                  );
                },
                titleStyle: GoogleFonts.cairo(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                actionStyle: GoogleFonts.cairo(color: kGold, fontSize: 13),
              ),
              const SizedBox(height: 8),
              if (donations.loading)
                const LoadingWidget()
              else if (donations.recent.isEmpty)
                const EmptyState(emoji: '🤲', title: 'No donations yet')
              else
                ...donations.recent.map((d) => _DonationTile(d)),

              const SizedBox(height: 22),

              // ── Recent Expenses ──────────────
              SectionHeader(
                title: 'Recent Expenses',
                action: 'See all →',
                onAction: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ExpensesScreen()),
                  );
                },
                titleStyle: GoogleFonts.cairo(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                actionStyle: GoogleFonts.cairo(color: kGold, fontSize: 13),
              ),
              const SizedBox(height: 8),
              if (expenses.loading)
                const LoadingWidget()
              else if (expenses.recent.isEmpty)
                const EmptyState(emoji: '🧾', title: 'No expenses yet')
              else
                ...expenses.recent.map(
                  (e) => _ExpenseTile(e),
                ), // FIX: Passed 'e' here

              const SizedBox(height: 22),

              // ── Active Projects ──────────────
              if (projects.active.isNotEmpty) ...[
                SectionHeader(
                  title: '🏗️   Active Projects',
                  action: '',
                  onAction: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ProjectsScreen()),
                    );
                  },
                  titleStyle: GoogleFonts.cairo(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  actionStyle: const TextStyle(color: Colors.transparent),
                ),
                const SizedBox(height: 8),
                ...projects.active.map((p) => _ProjectTile(p)),
                const SizedBox(height: 16),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Balance Banner ───────────────────────────
class _BalanceBanner extends StatelessWidget {
  final double balance, totalDon, totalExp, projSpent;
  const _BalanceBanner({
    required this.balance,
    required this.totalDon,
    required this.totalExp,
    required this.projSpent,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.03),
            borderRadius: BorderRadius.circular(18),
            border: Border.fromBorderSide(
              // FIX: Prevents borderRadius uniform error
              BorderSide(color: Colors.white.withOpacity(0.08), width: 1.2),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'CURRENT BALANCE',
                style: GoogleFonts.cairo(
                  color: Colors.white60,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 4),
              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text(
                  fmtCurrency(balance),
                  style: GoogleFonts.cairo(
                    color: kGold,
                    fontSize: 30,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Container(height: 1, color: Colors.white.withOpacity(0.08)),
              const SizedBox(height: 14),
              Row(
                children: [
                  _BannerStat(
                    'Donations',
                    fmtCurrency(totalDon),
                    const Color(0xFF2ECC71),
                  ),
                  const SizedBox(width: 12),
                  _BannerStat(
                    'Expenses',
                    fmtCurrency(totalExp),
                    const Color(0xFFFF6B6B),
                  ),
                  const SizedBox(width: 12),
                  _BannerStat(
                    'Projects',
                    fmtCurrency(projSpent),
                    const Color(0xFFF39C12),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BannerStat extends StatelessWidget {
  final String label, value;
  final Color color;
  const _BannerStat(this.label, this.value, this.color);

  @override
  Widget build(BuildContext context) => Expanded(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.cairo(
            color: Colors.white38,
            fontSize: 11,
            height: 1.1,
          ),
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 2),
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: Text(
            value,
            style: GoogleFonts.cairo(
              color: color,
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    ),
  );
}

// ─── Stats Grid ───────────────────────────────
// class _StatsGrid extends StatelessWidget {
//   final double mDonations, mExpenses;
//   final int activeProjects, totalProjects;
//   const _StatsGrid({
//     required this.mDonations,
//     required this.mExpenses,
//     required this.activeProjects,
//     required this.totalProjects,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final double width = MediaQuery.of(context).size.width;
//     final int cols = width > 500 ? 3 : 2;

//     return GridView.count(
//       shrinkWrap: true,
//       physics: const NeverScrollableScrollPhysics(),
//       crossAxisCount: cols,
//       mainAxisSpacing: 12,
//       crossAxisSpacing: 12,
//       childAspectRatio: cols == 3 ? 1.3 : 1.25,
//       children: [
//         StatCard(
//           label: 'Monthly Donations',
//           value: fmtCurrency(mDonations),
//           icon: '📥',
//           accentColor: const Color(0xFF2ECC71),
//           subtitle: 'This month',
//         ),
//         StatCard(
//           label: 'Monthly Expenses',
//           value: fmtCurrency(mExpenses),
//           icon: '📤',
//           accentColor: const Color(0xFFFF6B6B),
//           subtitle: 'This month',
//         ),
//         StatCard(
//           label: 'Active Projects',
//           value: '$activeProjects / $totalProjects',
//           icon: '🏗️',
//           accentColor: const Color(0xFF3498DB),
//           subtitle: 'Ongoing',
//         ),
//       ],
//     );
//   }
// }

// ─── Stats Grid ───────────────────────────────
class _StatsGrid extends StatelessWidget {
  final double mDonations, mExpenses;
  final int activeProjects, totalProjects;
  const _StatsGrid({
    required this.mDonations,
    required this.mExpenses,
    required this.activeProjects,
    required this.totalProjects,
  });

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    // Mobile screen par cards ko stretch hone ke liye aspect ratio adjust kiya
    final int cols = width > 500 ? 3 : 2;
    final double aspectRatio = cols == 3 ? 1.3 : 1.1;

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: cols,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: aspectRatio,
      children: [
        StatCard(
          label: 'Monthly Donations',
          value: fmtCurrency(mDonations),
          icon: '📥',
          accentColor: const Color(0xFF2ECC71),
          subtitle: 'This month',
        ),
        StatCard(
          label: 'Monthly Expenses',
          value: fmtCurrency(mExpenses),
          icon: '📤',
          accentColor: const Color(0xFFFF6B6B),
          subtitle: 'This month',
        ),
        StatCard(
          label: 'Active Projects',
          value: '$activeProjects / $totalProjects',
          icon: '🏗️',
          accentColor: const Color(0xFF3498DB),
          subtitle: 'Ongoing',
        ),
      ],
    );
  }
}

// Custom Tiles Components
class _DonationTile extends StatelessWidget {
  final dynamic d;
  const _DonationTile(this.d);

  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.only(bottom: 8),
    decoration: BoxDecoration(
      color: Colors.white.withOpacity(0.03),
      borderRadius: BorderRadius.circular(14),
      border: Border.fromBorderSide(
        BorderSide(color: Colors.white.withOpacity(0.04)),
      ),
    ),
    child: ListTile(
      dense: true,
      leading: CircleAvatar(
        backgroundColor: kGold.withOpacity(0.12),
        child: Text(
          d.donorName.isNotEmpty ? d.donorName[0].toUpperCase() : '?',
          style: GoogleFonts.cairo(color: kGold, fontWeight: FontWeight.bold),
        ),
      ),
      title: Text(
        d.donorName,
        style: GoogleFonts.cairo(
          fontWeight: FontWeight.bold,
          fontSize: 14,
          color: Colors.white,
        ),
      ),
      subtitle: Text(
        '${d.type} • ${fmtDate(d.date)}',
        style: GoogleFonts.cairo(fontSize: 11, color: Colors.white38),
      ),
      trailing: AmountBadge(fmtCurrency(d.amount)),
    ),
  );
}

class _ExpenseTile extends StatelessWidget {
  final dynamic e; // FIX: Made it normal final instead of late final
  const _ExpenseTile(this.e); // FIX: Added regular constructor

  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.only(bottom: 8),
    decoration: BoxDecoration(
      color: Colors.white.withOpacity(0.03),
      borderRadius: BorderRadius.circular(14),
      border: Border.fromBorderSide(
        BorderSide(color: Colors.white.withOpacity(0.04)),
      ),
    ),
    child: ListTile(
      dense: true,
      leading: CircleAvatar(
        backgroundColor: const Color(0xFFFF6B6B).withOpacity(0.12),
        child: Text(
          e.category.isNotEmpty ? e.category[0].toUpperCase() : '?',
          style: GoogleFonts.cairo(
            color: const Color(0xFFFF6B6B),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      title: Text(
        e.category,
        style: GoogleFonts.cairo(
          fontWeight: FontWeight.bold,
          fontSize: 14,
          color: Colors.white,
        ),
      ),
      subtitle: Text(
        e.description.isNotEmpty ? e.description : fmtDate(e.date),
        style: GoogleFonts.cairo(fontSize: 11, color: Colors.white38),
      ),
      trailing: AmountBadge(fmtCurrency(e.amount), isExpense: true),
    ),
  );
}

class _ProjectTile extends StatelessWidget {
  final dynamic p;
  const _ProjectTile(this.p);

  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.only(bottom: 10),
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: Colors.white.withOpacity(0.03),
      borderRadius: BorderRadius.circular(16),
      border: Border.fromBorderSide(
        BorderSide(color: Colors.white.withOpacity(0.04)),
      ),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                p.name,
                style: GoogleFonts.cairo(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Colors.white,
                ),
              ),
            ),
            Text(
              fmtCurrency(p.amountSpent),
              style: GoogleFonts.cairo(
                color: const Color(0xFFF39C12),
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: LinearProgressIndicator(
            value: p.progressPct,
            minHeight: 6,
            backgroundColor: Colors.white.withOpacity(0.06),
            color: p.isOverBudget ? const Color(0xFFFF6B6B) : kGold,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          '${(p.progressPct * 100).toStringAsFixed(0)}% of ${fmtCurrency(p.totalBudget)}',
          style: GoogleFonts.cairo(fontSize: 11, color: Colors.white38),
        ),
      ],
    ),
  );
}
