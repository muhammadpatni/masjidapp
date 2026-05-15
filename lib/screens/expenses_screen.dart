import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/app_theme.dart';
import '../models/expense_model.dart';
import '../providers/app_provider.dart';
import '../providers/expense_provider.dart';
import '../widgets/common_widgets.dart';
import '../widgets/form_fields.dart';

const Map<String, Color> _catColors = {
  'Imam Salary':  kPrimary,
  'Staff Salary': kPrimaryLight,
  'Electricity':  kWarning,
  'Water':        kInfo,
  'Gas':          kDanger,
  'Maintenance':  Color(0xFF8E44AD),
  'Other':        Color(0xFF7F8C8D),
};

class ExpensesScreen extends StatefulWidget {
  const ExpensesScreen({super.key});

  @override
  State<ExpensesScreen> createState() => _ExpensesScreenState();
}

class _ExpensesScreenState extends State<ExpensesScreen> {
  String _filterCat = '';

  @override
  Widget build(BuildContext context) {
    final app      = context.watch<AppProvider>();
    final provider = context.watch<ExpenseProvider>();
    final month    = app.selectedMonth;

    var list = provider.forMonth(month);
    if (_filterCat.isNotEmpty) list = list.where((e) => e.category == _filterCat).toList();

    final total     = provider.totalForMonth(month);
    final catTotals = provider.categoryTotals(month);

    return Scaffold(
      appBar: AppBar(
        title: const Text('🧾  Expenses'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(40),
          child: _MonthBar(
            label:  app.selectedMonthLabel,
            total:  total,
            onPrev: app.prevMonth,
            onNext: app.nextMonth,
            isExpense: true,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openForm(context, provider),
        icon:  const Icon(Icons.add),
        label: const Text('Add Expense'),
      ),
      body: provider.loading
          ? const LoadingWidget(message: 'Loading expenses…')
          : ListView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
              children: [
                // Category summary chips
                if (catTotals.isNotEmpty) ...[
                  _CategorySummary(
                    totals:    catTotals,
                    selected:  _filterCat,
                    onSelect:  (c) => setState(() =>
                        _filterCat = _filterCat == c ? '' : c),
                  ),
                  const SizedBox(height: 14),
                ],

                if (list.isEmpty)
                  EmptyState(
                    emoji:      '🧾',
                    title:      'No expenses found',
                    subtitle:   'Tap + to record a salary, bill or expense',
                    onAction:   () => _openForm(context, provider),
                    actionLabel: 'Add Expense',
                  )
                else
                  ...list.map((e) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: _ExpenseCard(
                      expense:  e,
                      onEdit:   () => _openForm(context, provider, existing: e),
                      onDelete: () => _confirmDelete(context, provider, e.id!),
                    ),
                  )),
              ],
            ),
    );
  }

  void _openForm(BuildContext ctx, ExpenseProvider p, {ExpenseModel? existing}) {
    showModalBottomSheet(
      context: ctx,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _ExpenseForm(existing: existing, provider: p),
    );
  }

  void _confirmDelete(BuildContext ctx, ExpenseProvider p, String id) {
    showDialog(
      context: ctx,
      builder: (_) => AlertDialog(
        title: const Text('Delete Expense'),
        content: const Text('Are you sure?'),
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

// ─── Category Summary Chips ───────────────────
class _CategorySummary extends StatelessWidget {
  final Map<String, double> totals;
  final String selected;
  final void Function(String) onSelect;
  const _CategorySummary({required this.totals, required this.selected, required this.onSelect});

  @override
  Widget build(BuildContext context) => Wrap(
    spacing: 8, runSpacing: 8,
    children: totals.entries.map((entry) {
      final cat   = entry.key;
      final color = _catColors[cat] ?? kTextMuted;
      final active = selected == cat;
      return GestureDetector(
        onTap: () => onSelect(cat),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: active ? color : color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: color.withOpacity(0.3)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${kCategoryIcons[cat] ?? '📌'} $cat',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: active ? Colors.white : color,
                ),
              ),
              const SizedBox(width: 6),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  fmtCurrency(entry.value),
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: active ? Colors.white70 : color.withOpacity(0.8),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }).toList(),
  );
}

// ─── Expense Card ─────────────────────────────
class _ExpenseCard extends StatelessWidget {
  final ExpenseModel expense;
  final VoidCallback onEdit, onDelete;
  const _ExpenseCard({required this.expense, required this.onEdit, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    final color = _catColors[expense.category] ?? kTextMuted;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Category icon
            Container(
              width: 44, height: 44,
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  kCategoryIcons[expense.category] ?? '📌',
                  style: const TextStyle(fontSize: 22),
                ),
              ),
            ),
            const SizedBox(width: 12),

            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          expense.category,
                          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                      const SizedBox(width: 8),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          fmtCurrency(expense.amount),
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: kDanger,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  if (expense.recipient.isNotEmpty)
                    Text(
                      '→ ${expense.recipient}',
                      style: const TextStyle(fontSize: 12, color: kTextLight),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  if (expense.description.isNotEmpty)
                    Text(
                      expense.description,
                      style: const TextStyle(fontSize: 12, color: kTextMuted),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  const SizedBox(height: 4),
                  Text(
                    fmtDate(expense.date),
                    style: const TextStyle(fontSize: 11, color: kTextMuted),
                  ),
                ],
              ),
            ),

            // Actions
            Column(
              children: [
                IconButton(
                  onPressed: onEdit,
                  icon: const Icon(Icons.edit_outlined, size: 18, color: kPrimary),
                  padding: EdgeInsets.zero, constraints: const BoxConstraints(),
                ),
                const SizedBox(height: 8),
                IconButton(
                  onPressed: onDelete,
                  icon: const Icon(Icons.delete_outline, size: 18, color: kDanger),
                  padding: EdgeInsets.zero, constraints: const BoxConstraints(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Expense Form ─────────────────────────────
class _ExpenseForm extends StatefulWidget {
  final ExpenseModel? existing;
  final ExpenseProvider provider;
  const _ExpenseForm({this.existing, required this.provider});

  @override
  State<_ExpenseForm> createState() => _ExpenseFormState();
}

class _ExpenseFormState extends State<_ExpenseForm> {
  final _formKey   = GlobalKey<FormState>();
  final _descCtrl  = TextEditingController();
  final _amtCtrl   = TextEditingController();
  final _recipCtrl = TextEditingController();

  String   _category = 'Imam Salary';
  DateTime _date     = DateTime.now();
  bool     _saving   = false;

  bool get _isSalary =>
      _category == 'Imam Salary' || _category == 'Staff Salary';

  @override
  void initState() {
    super.initState();
    if (widget.existing != null) {
      final e = widget.existing!;
      _category    = e.category;
      _descCtrl.text  = e.description;
      _amtCtrl.text   = e.amount.toStringAsFixed(0);
      _recipCtrl.text = e.recipient;
      _date           = e.date;
    }
  }

  @override
  void dispose() {
    _descCtrl.dispose(); _amtCtrl.dispose(); _recipCtrl.dispose();
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
            Center(
              child: Container(
                width: 40, height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(color: kBorder, borderRadius: BorderRadius.circular(2)),
              ),
            ),
            Text(
              isEdit ? 'Edit Expense' : 'Add Expense',
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: kPrimary),
            ),
            const SizedBox(height: 16),

            AppDropdown<String>(
              label:       'Category',
              value:       _category,
              items:       kExpenseCategories,
              displayText: (v) => '${kCategoryIcons[v] ?? ''} $v',
              onChanged:   (v) => setState(() => _category = v!),
            ),
            const SizedBox(height: 12),

            AmountField(controller: _amtCtrl),
            const SizedBox(height: 12),

            if (_isSalary) ...[
              AppTextField(
                label:      'Recipient Name',
                controller: _recipCtrl,
                hint:       'Imam / Staff member name',
              ),
              const SizedBox(height: 12),
            ],

            AppTextField(
              label:      'Description',
              controller: _descCtrl,
              hint:       _isSalary
                  ? 'e.g. Monthly salary – Ramadan'
                  : 'e.g. LESCO bill October',
              maxLines:   2,
            ),
            const SizedBox(height: 12),

            DatePickerField(
              label:          'Date',
              date:           _date,
              onDateSelected: (d) => setState(() => _date = d),
              required:       true,
            ),
            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: _saving ? null : _submit,
              child: _saving
                  ? const SizedBox(
                      height: 20, width: 20,
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                    )
                  : Text(isEdit ? 'Update Expense' : 'Add Expense'),
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
      final model = ExpenseModel(
        id:          widget.existing?.id,
        category:    _category,
        description: _descCtrl.text.trim(),
        amount:      double.parse(_amtCtrl.text),
        date:        _date,
        recipient:   _recipCtrl.text.trim(),
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

// ─── Month Bar ────────────────────────────────
class _MonthBar extends StatelessWidget {
  final String label;
  final double total;
  final bool isExpense;
  final VoidCallback onPrev, onNext;
  const _MonthBar({
    required this.label, required this.total,
    required this.onPrev, required this.onNext,
    this.isExpense = false,
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
          child: Text(label, style: const TextStyle(color: Colors.white70, fontSize: 13),
            textAlign: TextAlign.center, overflow: TextOverflow.ellipsis),
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
            style: TextStyle(
              color: isExpense ? Colors.redAccent[100] : const Color(0xFF90EE90),
              fontWeight: FontWeight.w700, fontSize: 13,
            ),
          ),
        ),
      ],
    ),
  );
}
