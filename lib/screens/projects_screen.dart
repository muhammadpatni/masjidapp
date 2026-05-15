import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/app_theme.dart';
import '../models/project_model.dart';
import '../providers/project_provider.dart';
import '../widgets/common_widgets.dart';
import '../widgets/form_fields.dart';

const Map<String, Color> _statusColors = {
  'Planning':  kInfo,
  'Ongoing':   kWarning,
  'Completed': kSuccess,
};

const Map<String, String> _statusIcons = {
  'Planning':  '📋',
  'Ongoing':   '🔨',
  'Completed': '✅',
};

class ProjectsScreen extends StatefulWidget {
  const ProjectsScreen({super.key});

  @override
  State<ProjectsScreen> createState() => _ProjectsScreenState();
}

class _ProjectsScreenState extends State<ProjectsScreen> {
  String _filterStatus = '';

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProjectProvider>();
    final list     = provider.byStatus(_filterStatus);

    return Scaffold(
      appBar: AppBar(
        title: const Text('🏗️  Projects'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: _SummaryBadge(
              totalBudget: provider.totalBudget,
              totalSpent:  provider.totalSpent,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openForm(context, provider),
        icon:  const Icon(Icons.add),
        label: const Text('New Project'),
      ),
      body: provider.loading
          ? const LoadingWidget(message: 'Loading projects…')
          : Column(
              children: [
                // Status filter tabs
                _StatusFilter(
                  selected: _filterStatus,
                  counts: {
                    '':          provider.all.length,
                    'Planning':  provider.byStatus('Planning').length,
                    'Ongoing':   provider.byStatus('Ongoing').length,
                    'Completed': provider.byStatus('Completed').length,
                  },
                  onSelect: (s) => setState(() => _filterStatus = s),
                ),
                Expanded(
                  child: list.isEmpty
                      ? EmptyState(
                          emoji:       '🏗️',
                          title:       'No projects found',
                          subtitle:    'Add solar panels, construction or any development project',
                          onAction:    () => _openForm(context, provider),
                          actionLabel: 'Add Project',
                        )
                      : ListView.separated(
                          padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
                          itemCount: list.length,
                          separatorBuilder: (_, __) => const SizedBox(height: 12),
                          itemBuilder: (ctx, i) {
                            final p = list[i];
                            return _ProjectCard(
                              project:  p,
                              onEdit:   () => _openForm(ctx, provider, existing: p),
                              onDelete: () => _confirmDelete(ctx, provider, p.id!),
                            );
                          },
                        ),
                ),
              ],
            ),
    );
  }

  void _openForm(BuildContext ctx, ProjectProvider p, {ProjectModel? existing}) {
    showModalBottomSheet(
      context: ctx,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _ProjectForm(existing: existing, provider: p),
    );
  }

  void _confirmDelete(BuildContext ctx, ProjectProvider p, String id) {
    showDialog(
      context: ctx,
      builder: (_) => AlertDialog(
        title: const Text('Delete Project'),
        content: const Text('Are you sure? This cannot be undone.'),
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

// ─── Status Filter Tabs ───────────────────────
class _StatusFilter extends StatelessWidget {
  final String selected;
  final Map<String, int> counts;
  final void Function(String) onSelect;
  const _StatusFilter({required this.selected, required this.counts, required this.onSelect});

  @override
  Widget build(BuildContext context) => Container(
    color: kCard,
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    child: SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _tab('', 'All', counts[''] ?? 0),
          _tab('Planning',  '📋 Planning',  counts['Planning']  ?? 0),
          _tab('Ongoing',   '🔨 Ongoing',   counts['Ongoing']   ?? 0),
          _tab('Completed', '✅ Completed', counts['Completed'] ?? 0),
        ],
      ),
    ),
  );

  Widget _tab(String val, String label, int count) {
    final active = selected == val;
    final color  = val.isEmpty ? kPrimary : (_statusColors[val] ?? kPrimary);
    return GestureDetector(
      onTap: () => onSelect(val),
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: active ? color : color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          '$label ($count)',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: active ? Colors.white : color,
          ),
        ),
      ),
    );
  }
}

// ─── Project Card ─────────────────────────────
class _ProjectCard extends StatelessWidget {
  final ProjectModel project;
  final VoidCallback onEdit, onDelete;
  const _ProjectCard({required this.project, required this.onEdit, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    final color   = _statusColors[project.status] ?? kPrimary;
    final icon    = _statusIcons[project.status]  ?? '📋';
    final pct     = project.progressPct;
    final isOver  = project.isOverBudget;

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: color.withOpacity(0.3)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title row
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    project.name,
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '$icon ${project.status}',
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: color),
                  ),
                ),
              ],
            ),

            if (project.description.isNotEmpty) ...[
              const SizedBox(height: 6),
              Text(
                project.description,
                style: const TextStyle(fontSize: 12.5, color: kTextLight),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],

            const SizedBox(height: 14),

            // Budget row
            Row(
              children: [
                _BudgetStat('Budget', fmtCurrency(project.totalBudget), kInfo),
                const SizedBox(width: 8),
                _BudgetStat('Spent',  fmtCurrency(project.amountSpent), isOver ? kDanger : kWarning),
                const SizedBox(width: 8),
                _BudgetStat('Left', fmtCurrency(project.remaining), isOver ? kDanger : kSuccess),
              ],
            ),

            const SizedBox(height: 12),

            // Progress bar
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Progress', style: TextStyle(fontSize: 11, color: kTextLight)),
                          Text(
                            '${(pct * 100).toStringAsFixed(0)}%${isOver ? ' ⚠ Over budget' : ''}',
                            style: TextStyle(
                              fontSize: 11,
                              color: isOver ? kDanger : kTextLight,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: pct,
                          minHeight: 8,
                          backgroundColor: kBorder,
                          valueColor: AlwaysStoppedAnimation(
                            isOver ? kDanger : pct > 0.75 ? kWarning : kPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // Dates
            if (project.startDate != null || project.endDate != null) ...[
              const SizedBox(height: 8),
              Wrap(
                spacing: 12,
                children: [
                  if (project.startDate != null)
                    Text('📅 ${fmtDate(project.startDate!)}',
                        style: const TextStyle(fontSize: 11, color: kTextMuted)),
                  if (project.endDate != null)
                    Text('🏁 ${fmtDate(project.endDate!)}',
                        style: const TextStyle(fontSize: 11, color: kTextMuted)),
                ],
              ),
            ],

            const SizedBox(height: 10),
            const Divider(height: 1),
            const SizedBox(height: 8),

            // Actions
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton.icon(
                  onPressed: onEdit,
                  icon: const Icon(Icons.edit_outlined, size: 15),
                  label: const Text('Edit'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: kPrimary,
                    side: const BorderSide(color: kPrimary),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
                const SizedBox(width: 8),
                OutlinedButton.icon(
                  onPressed: onDelete,
                  icon: const Icon(Icons.delete_outline, size: 15),
                  label: const Text('Delete'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: kDanger,
                    side: const BorderSide(color: kDanger),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _BudgetStat extends StatelessWidget {
  final String label, value;
  final Color color;
  const _BudgetStat(this.label, this.value, this.color);

  @override
  Widget build(BuildContext context) => Expanded(
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 10, color: kTextMuted)),
          const SizedBox(height: 3),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              value,
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: color),
            ),
          ),
        ],
      ),
    ),
  );
}

// ─── Summary Badge ────────────────────────────
class _SummaryBadge extends StatelessWidget {
  final double totalBudget, totalSpent;
  const _SummaryBadge({required this.totalBudget, required this.totalSpent});

  @override
  Widget build(BuildContext context) => Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.end,
    children: [
      FittedBox(
        child: Text(
          fmtCurrency(totalSpent),
          style: const TextStyle(color: Colors.orangeAccent, fontSize: 13, fontWeight: FontWeight.w700),
        ),
      ),
      FittedBox(
        child: Text(
          'of ${fmtCurrency(totalBudget)}',
          style: const TextStyle(color: Colors.white60, fontSize: 10),
        ),
      ),
    ],
  );
}

// ─── Project Form ─────────────────────────────
class _ProjectForm extends StatefulWidget {
  final ProjectModel? existing;
  final ProjectProvider provider;
  const _ProjectForm({this.existing, required this.provider});

  @override
  State<_ProjectForm> createState() => _ProjectFormState();
}

class _ProjectFormState extends State<_ProjectForm> {
  final _formKey    = GlobalKey<FormState>();
  final _nameCtrl   = TextEditingController();
  final _descCtrl   = TextEditingController();
  final _budgetCtrl = TextEditingController();
  final _spentCtrl  = TextEditingController();

  String    _status    = 'Planning';
  DateTime? _startDate;
  DateTime? _endDate;
  bool      _saving    = false;

  @override
  void initState() {
    super.initState();
    if (widget.existing != null) {
      final p = widget.existing!;
      _nameCtrl.text   = p.name;
      _descCtrl.text   = p.description;
      _budgetCtrl.text = p.totalBudget.toStringAsFixed(0);
      _spentCtrl.text  = p.amountSpent.toStringAsFixed(0);
      _status          = p.status;
      _startDate       = p.startDate;
      _endDate         = p.endDate;
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose(); _descCtrl.dispose();
    _budgetCtrl.dispose(); _spentCtrl.dispose();
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
              isEdit ? 'Edit Project' : 'New Project',
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: kPrimary),
            ),
            const SizedBox(height: 16),

            AppTextField(label: 'Project Name', controller: _nameCtrl, required: true,
                hint: 'e.g. Solar Panel Installation'),
            const SizedBox(height: 12),

            AppTextField(label: 'Description', controller: _descCtrl, maxLines: 2,
                hint: 'Brief description of the project'),
            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(child: AmountField(controller: _budgetCtrl, label: 'Total Budget')),
                const SizedBox(width: 10),
                Expanded(child: AmountField(controller: _spentCtrl, label: 'Amount Spent')),
              ],
            ),
            const SizedBox(height: 12),

            AppDropdown<String>(
              label: 'Status', value: _status,
              items: kProjectStatuses,
              displayText: (v) => '${_statusIcons[v] ?? ''} $v',
              onChanged: (v) => setState(() => _status = v!),
            ),
            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: DatePickerField(
                    label:          'Start Date',
                    date:           _startDate ?? DateTime.now(),
                    onDateSelected: (d) => setState(() => _startDate = d),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: DatePickerField(
                    label:          'End Date',
                    date:           _endDate ?? DateTime.now(),
                    onDateSelected: (d) => setState(() => _endDate = d),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: _saving ? null : _submit,
              child: _saving
                  ? const SizedBox(height: 20, width: 20,
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                  : Text(isEdit ? 'Update Project' : 'Add Project'),
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
      final model = ProjectModel(
        id:          widget.existing?.id,
        name:        _nameCtrl.text.trim(),
        description: _descCtrl.text.trim(),
        totalBudget: double.parse(_budgetCtrl.text),
        amountSpent: double.tryParse(_spentCtrl.text) ?? 0,
        status:      _status,
        startDate:   _startDate,
        endDate:     _endDate,
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
