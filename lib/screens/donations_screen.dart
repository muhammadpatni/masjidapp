import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/app_theme.dart';
import '../models/donation_model.dart';
import '../providers/app_provider.dart';
import '../providers/donation_provider.dart';
import '../widgets/common_widgets.dart';
import '../widgets/form_fields.dart';

class DonationsScreen extends StatelessWidget {
  const DonationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app       = context.watch<AppProvider>();
    final provider  = context.watch<DonationProvider>();
    final month     = app.selectedMonth;
    final list      = provider.forMonth(month);
    final total     = provider.totalForMonth(month);

    return Scaffold(
      appBar: AppBar(
        title: const Text('🤲  Donations'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(40),
          child: _MonthBar(
            label:  app.selectedMonthLabel,
            total:  total,
            onPrev: app.prevMonth,
            onNext: app.nextMonth,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openForm(context, provider),
        icon:  const Icon(Icons.add),
        label: const Text('Add Donation'),
      ),
      body: provider.loading
          ? const LoadingWidget(message: 'Loading donations…')
          : list.isEmpty
              ? EmptyState(
                  emoji:    '🤲',
                  title:    'No donations this month',
                  subtitle: 'Tap + to record a donation',
                  onAction: () => _openForm(context, provider),
                  actionLabel: 'Add Donation',
                )
              : ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
                  itemCount: list.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (ctx, i) {
                    final d = list[i];
                    return _DonationCard(
                      donation: d,
                      onEdit:   () => _openForm(ctx, provider, existing: d),
                      onDelete: () => _confirmDelete(ctx, provider, d.id!),
                    );
                  },
                ),
    );
  }

  // ── Bottom Sheet Form ─────────────────────
  void _openForm(
    BuildContext context,
    DonationProvider provider, {
    DonationModel? existing,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _DonationForm(
        existing: existing,
        provider: provider,
      ),
    );
  }

  void _confirmDelete(BuildContext ctx, DonationProvider p, String id) {
    showDialog(
      context: ctx,
      builder: (_) => AlertDialog(
        title: const Text('Delete Donation'),
        content: const Text('Are you sure you want to delete this record?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          TextButton(
            onPressed: () { Navigator.pop(ctx); p.delete(id); },
            style: TextButton.styleFrom(foregroundColor: kDanger),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

// ─── Donation Card ────────────────────────────
class _DonationCard extends StatelessWidget {
  final DonationModel donation;
  final VoidCallback onEdit, onDelete;
  const _DonationCard({required this.donation, required this.onEdit, required this.onDelete});

  static const _typeBg = {
    'Cash':   Color(0xFFE8F5EC),
    'Online': Color(0xFFE8F4FB),
    'Cheque': Color(0xFFFDF8E8),
  };
  static const _typeColor = {
    'Cash':   kSuccess,
    'Online': kInfo,
    'Cheque': kGold,
  };

  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar
              CircleAvatar(
                radius: 20,
                backgroundColor: kPrimarySoft,
                child: Text(
                  donation.donorName.isNotEmpty
                      ? donation.donorName[0].toUpperCase()
                      : '?',
                  style: const TextStyle(
                    color: kPrimary,
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(width: 10),

              // Name + date
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      donation.donorName,
                      style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      fmtDate(donation.date),
                      style: const TextStyle(fontSize: 12, color: kTextMuted),
                    ),
                  ],
                ),
              ),

              // Amount
              Flexible(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    fmtCurrency(donation.amount),
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: kSuccess,
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),
          Row(
            children: [
              // Type badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                decoration: BoxDecoration(
                  color: _typeBg[donation.type] ?? kPrimarySoft,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  donation.type,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: _typeColor[donation.type] ?? kPrimary,
                  ),
                ),
              ),

              if (donation.notes.isNotEmpty) ...[
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    donation.notes,
                    style: const TextStyle(fontSize: 12, color: kTextLight),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              ],

              const Spacer(),
              // Actions
              IconButton(
                onPressed: onEdit,
                icon: const Icon(Icons.edit_outlined, size: 18, color: kPrimary),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              const SizedBox(width: 10),
              IconButton(
                onPressed: onDelete,
                icon: const Icon(Icons.delete_outline, size: 18, color: kDanger),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

// ─── Donation Form (Bottom Sheet) ─────────────
class _DonationForm extends StatefulWidget {
  final DonationModel? existing;
  final DonationProvider provider;
  const _DonationForm({this.existing, required this.provider});

  @override
  State<_DonationForm> createState() => _DonationFormState();
}

class _DonationFormState extends State<_DonationForm> {
  final _formKey    = GlobalKey<FormState>();
  final _nameCtrl   = TextEditingController();
  final _amountCtrl = TextEditingController();
  final _notesCtrl  = TextEditingController();

  String   _type = 'Cash';
  DateTime _date = DateTime.now();
  bool     _saving = false;

  @override
  void initState() {
    super.initState();
    if (widget.existing != null) {
      final e = widget.existing!;
      _nameCtrl.text   = e.donorName;
      _amountCtrl.text = e.amount.toStringAsFixed(0);
      _notesCtrl.text  = e.notes;
      _type = e.type;
      _date = e.date;
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _amountCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.existing != null;
    final bottom = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: EdgeInsets.fromLTRB(20, 16, 20, 20 + bottom),
      child: Form(
        key: _formKey,
        child: ListView(
          shrinkWrap: true,
          children: [
            // Handle
            Center(
              child: Container(
                width: 40, height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: kBorder, borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),

            Text(
              isEdit ? 'Edit Donation' : 'Add Donation',
              style: const TextStyle(
                fontSize: 17, fontWeight: FontWeight.w700, color: kPrimary,
              ),
            ),
            const SizedBox(height: 16),

            AppTextField(
              label:      'Donor Name',
              controller: _nameCtrl,
              required:   true,
            ),
            const SizedBox(height: 12),

            AmountField(controller: _amountCtrl),
            const SizedBox(height: 12),

            AppDropdown<String>(
              label:       'Donation Type',
              value:       _type,
              items:       const ['Cash', 'Online', 'Cheque'],
              displayText: (v) => v,
              onChanged:   (v) => setState(() => _type = v!),
            ),
            const SizedBox(height: 12),

            DatePickerField(
              label:           'Date',
              date:            _date,
              onDateSelected:  (d) => setState(() => _date = d),
              required:        true,
            ),
            const SizedBox(height: 12),

            AppTextField(
              label:      'Notes (Optional)',
              controller: _notesCtrl,
              maxLines:   2,
            ),
            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: _saving ? null : _submit,
              child: _saving
                  ? const SizedBox(
                      height: 20, width: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white, strokeWidth: 2,
                      ),
                    )
                  : Text(isEdit ? 'Update Donation' : 'Add Donation'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    try {
      final model = DonationModel(
        id:        widget.existing?.id,
        donorName: _nameCtrl.text.trim(),
        amount:    double.parse(_amountCtrl.text),
        date:      _date,
        type:      _type,
        notes:     _notesCtrl.text.trim(),
      );
      if (widget.existing != null) {
        await widget.provider.update(widget.existing!.id!, model);
      } else {
        await widget.provider.add(model);
      }
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: kDanger),
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }
}

// ─── Month App Bar ─────────────────────────────
class _MonthBar extends StatelessWidget {
  final String label;
  final double total;
  final VoidCallback onPrev, onNext;
  const _MonthBar({
    required this.label, required this.total,
    required this.onPrev, required this.onNext,
  });

  @override
  Widget build(BuildContext context) => Container(
    color: kPrimaryDark,
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
    child: Row(
      children: [
        IconButton(
          onPressed: onPrev,
          icon: const Icon(Icons.chevron_left, color: Colors.white, size: 20),
          padding: EdgeInsets.zero, constraints: const BoxConstraints(),
        ),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(color: Colors.white70, fontSize: 13),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        IconButton(
          onPressed: onNext,
          icon: const Icon(Icons.chevron_right, color: Colors.white, size: 20),
          padding: EdgeInsets.zero, constraints: const BoxConstraints(),
        ),
        const SizedBox(width: 8),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            fmtCurrency(total),
            style: const TextStyle(
              color: Color(0xFF90EE90),
              fontWeight: FontWeight.w700,
              fontSize: 13,
            ),
          ),
        ),
      ],
    ),
  );
}
