import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
    final app       = context.watch<AppProvider>();
    final donations = context.watch<DonationProvider>();
    final expenses  = context.watch<ExpenseProvider>();
    final projects  = context.watch<ProjectProvider>();

    final month      = app.selectedMonth;
    final donTotal   = donations.totalAllTime;
    final expTotal   = expenses.totalAllTime;
    final projSpent  = projects.totalSpent;
    final balance    = donTotal - expTotal - projSpent;
    final mDonations = donations.totalForMonth(month);
    final mExpenses  = expenses.totalForMonth(month);

    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Text('☪  ', style: TextStyle(fontSize: 20)),
            Text('Masjid Dashboard'),
          ],
        ),
      ),
      body: RefreshIndicator(
        color: kPrimary,
        onRefresh: () async {},   // streams auto-refresh
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // ── Month navigator ──────────────
            MonthNavigator(
              label:  app.selectedMonthLabel,
              onPrev: app.prevMonth,
              onNext: app.nextMonth,
            ),

            // ── Balance Banner ───────────────
            _BalanceBanner(
              balance:    balance,
              totalDon:   donTotal,
              totalExp:   expTotal,
              projSpent:  projSpent,
            ),
            const SizedBox(height: 16),

            // ── Stat grid ────────────────────
            const SectionHeader(title: 'Monthly Summary'),
            const SizedBox(height: 10),
            _StatsGrid(
              mDonations: mDonations,
              mExpenses:  mExpenses,
              activeProjects: projects.active.length,
              totalProjects:  projects.all.length,
            ),
            const SizedBox(height: 20),

            // ── Recent Donations ─────────────
            SectionHeader(
              title:    'Recent Donations',
              action:   'See all →',
              onAction: () {},
            ),
            const SizedBox(height: 8),
            if (donations.loading)
              const LoadingWidget()
            else if (donations.recent.isEmpty)
              const EmptyState(emoji: '🤲', title: 'No donations yet')
            else
              ...donations.recent.map((d) => _DonationTile(d)),

            const SizedBox(height: 20),

            // ── Recent Expenses ──────────────
            SectionHeader(
              title:    'Recent Expenses',
              action:   'See all →',
              onAction: () {},
            ),
            const SizedBox(height: 8),
            if (expenses.loading)
              const LoadingWidget()
            else if (expenses.recent.isEmpty)
              const EmptyState(emoji: '🧾', title: 'No expenses yet')
            else
              ...expenses.recent.map((e) => _ExpenseTile(e)),

            const SizedBox(height: 20),

            // ── Active Projects ──────────────
            if (projects.active.isNotEmpty) ...[
              const SectionHeader(title: '🏗️  Active Projects'),
              const SizedBox(height: 8),
              ...projects.active.map((p) => _ProjectTile(p)),
              const SizedBox(height: 16),
            ],
          ],
        ),
      ),
    );
  }
}

// ─── Balance Banner ───────────────────────────
class _BalanceBanner extends StatelessWidget {
  final double balance, totalDon, totalExp, projSpent;
  const _BalanceBanner({
    required this.balance, required this.totalDon,
    required this.totalExp, required this.projSpent,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [kPrimaryDark, kPrimary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: kPrimary.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'CURRENT BALANCE',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 11,
              fontWeight: FontWeight.w600,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 6),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              fmtCurrency(balance),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(height: 14),
          const Divider(color: Colors.white24, height: 1),
          const SizedBox(height: 12),
          // breakdown row
          Row(
            children: [
              _BannerStat('Donations', fmtCurrency(totalDon), kGold),
              const SizedBox(width: 12),
              _BannerStat('Expenses', fmtCurrency(totalExp), Colors.redAccent),
              const SizedBox(width: 12),
              _BannerStat('Projects', fmtCurrency(projSpent), Colors.orangeAccent),
            ],
          ),
        ],
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
          style: const TextStyle(color: Colors.white54, fontSize: 10),
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 2),
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: Text(
            value,
            style: TextStyle(color: color, fontSize: 13, fontWeight: FontWeight.w700),
          ),
        ),
      ],
    ),
  );
}

// ─── Stats Grid ───────────────────────────────
class _StatsGrid extends StatelessWidget {
  final double mDonations, mExpenses;
  final int activeProjects, totalProjects;
  const _StatsGrid({
    required this.mDonations, required this.mExpenses,
    required this.activeProjects, required this.totalProjects,
  });

  @override
  Widget build(BuildContext context) {
    // Responsive: 2 columns on narrow, 3 on wide
    return LayoutBuilder(
      builder: (_, constraints) {
        final cols = constraints.maxWidth > 500 ? 3 : 2;
        return GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: cols,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1.05,
          children: [
            StatCard(
              label:       'Monthly Donations',
              value:       fmtCurrency(mDonations),
              icon:        '📥',
              accentColor: kSuccess,
              subtitle:    'This month',
            ),
            StatCard(
              label:       'Monthly Expenses',
              value:       fmtCurrency(mExpenses),
              icon:        '📤',
              accentColor: kDanger,
              subtitle:    'This month',
            ),
            StatCard(
              label:       'Active Projects',
              value:       '$activeProjects / $totalProjects',
              icon:        '🏗️',
              accentColor: kInfo,
              subtitle:    'Ongoing',
            ),
          ],
        );
      },
    );
  }
}

// ─── Small Tiles ──────────────────────────────
class _DonationTile extends StatelessWidget {
  final dynamic d;
  const _DonationTile(this.d);

  @override
  Widget build(BuildContext context) => Card(
    margin: const EdgeInsets.only(bottom: 8),
    child: ListTile(
      dense: true,
      leading: CircleAvatar(
        backgroundColor: kPrimarySoft,
        child: Text(
          d.donorName.isNotEmpty ? d.donorName[0].toUpperCase() : '?',
          style: const TextStyle(color: kPrimary, fontWeight: FontWeight.w700),
        ),
      ),
      title: Text(
        d.donorName,
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      ),
      subtitle: Text(
        '${d.type} • ${fmtDate(d.date)}',
        style: const TextStyle(fontSize: 12, color: kTextLight),
        overflow: TextOverflow.ellipsis,
      ),
      trailing: AmountBadge(fmtCurrency(d.amount)),
    ),
  );
}

class _ExpenseTile extends StatelessWidget {
  final dynamic e;
  const _ExpenseTile(this.e);

  @override
  Widget build(BuildContext context) => Card(
    margin: const EdgeInsets.only(bottom: 8),
    child: ListTile(
      dense: true,
      leading: CircleAvatar(
        backgroundColor: const Color(0xFFFDECEA),
        child: Text(
          e.category.isNotEmpty ? e.category[0] : '?',
          style: const TextStyle(color: kDanger, fontWeight: FontWeight.w700),
        ),
      ),
      title: Text(
        e.category,
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      ),
      subtitle: Text(
        e.description.isNotEmpty ? e.description : fmtDate(e.date),
        style: const TextStyle(fontSize: 12, color: kTextLight),
        overflow: TextOverflow.ellipsis,
      ),
      trailing: AmountBadge(fmtCurrency(e.amount), isExpense: true),
    ),
  );
}

class _ProjectTile extends StatelessWidget {
  final dynamic p;
  const _ProjectTile(this.p);

  @override
  Widget build(BuildContext context) => Card(
    margin: const EdgeInsets.only(bottom: 8),
    child: Padding(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  p.name,
                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
              const SizedBox(width: 8),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  fmtCurrency(p.amountSpent),
                  style: const TextStyle(color: kWarning, fontWeight: FontWeight.w700, fontSize: 13),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: p.progressPct,
              minHeight: 6,
              backgroundColor: kBorder,
              color: p.isOverBudget ? kDanger : kPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Flexible(
                child: Text(
                  '${(p.progressPct * 100).toStringAsFixed(0)}% of ${fmtCurrency(p.totalBudget)}',
                  style: const TextStyle(fontSize: 11, color: kTextMuted),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
