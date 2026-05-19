import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_theme.dart';

// ─── Text field ───────────────────────────────
class AppTextField extends StatelessWidget {
  final String label;
  final String? hint;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final int maxLines;
  final String? Function(String?)? validator;
  final bool required;

  const AppTextField({
    super.key,
    required this.label,
    required this.controller,
    this.hint,
    this.keyboardType = TextInputType.text,
    this.inputFormatters,
    this.maxLines = 1,
    this.validator,
    this.required = false,
  });

  @override
  Widget build(BuildContext context) => TextFormField(
    controller: controller,
    keyboardType: keyboardType,
    inputFormatters: inputFormatters,
    maxLines: maxLines,
    style: GoogleFonts.cairo(
      fontSize: 14,
      color: Colors.white,
    ), // Premium text input
    validator:
        validator ??
        (required
            ? (v) =>
                  (v == null || v.trim().isEmpty) ? '$label is required' : null
            : null),
    decoration: InputDecoration(
      labelText: label + (required ? ' *' : ''),
      labelStyle: GoogleFonts.cairo(color: Colors.white70),
      hintText: hint,
      hintStyle: GoogleFonts.cairo(color: Colors.white38),
    ),
  );
}

// ─── Amount field ─────────────────────────────
class AmountField extends StatelessWidget {
  final TextEditingController controller;
  final String label;

  const AmountField({
    super.key,
    required this.controller,
    this.label = 'Amount (PKR)',
  });

  @override
  Widget build(BuildContext context) => TextFormField(
    controller: controller,
    keyboardType: const TextInputType.numberWithOptions(decimal: true),
    style: GoogleFonts.cairo(
      fontSize: 15,
      fontWeight: FontWeight.bold,
      color: kGold, // Giving currency entry a distinct gold touch
    ),
    inputFormatters: [
      FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
    ],
    validator: (v) {
      if (v == null || v.isEmpty) return '$label is required';
      if (double.tryParse(v) == null) return 'Enter a valid number';
      // if (double.parse(v) <= 0) return 'Amount must be greater than 0';
      return null;
    },
    decoration: InputDecoration(
      labelText: '$label *',
      labelStyle: GoogleFonts.cairo(color: Colors.white70),
      prefixText: 'PKR ',
      prefixStyle: GoogleFonts.cairo(
        fontWeight: FontWeight.bold,
        color: kGold, // Metallic gold currency tag
      ),
    ),
  );
}

// ─── Dropdown field ───────────────────────────
class AppDropdown<T> extends StatelessWidget {
  final String label;
  final T value;
  final List<T> items;
  final String Function(T) displayText;
  final void Function(T?) onChanged;

  const AppDropdown({
    super.key,
    required this.label,
    required this.value,
    required this.items,
    required this.displayText,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) => DropdownButtonFormField<T>(
    initialValue: value,
    onChanged: onChanged,
    isExpanded: true,
    dropdownColor: kPrimaryDark, // Dark background inside dropdown menu list
    icon: const Icon(
      Icons.keyboard_arrow_down,
      color: kGold,
    ), // Sleeker gold icon
    style: GoogleFonts.cairo(fontSize: 14, color: Colors.white),
    decoration: InputDecoration(
      labelText: label,
      labelStyle: GoogleFonts.cairo(color: Colors.white70),
    ),
    items: items
        .map(
          (item) => DropdownMenuItem<T>(
            value: item,
            child: Text(
              displayText(item),
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.cairo(),
            ),
          ),
        )
        .toList(),
  );
}

// ─── Date picker field ────────────────────────
class DatePickerField extends StatelessWidget {
  final String label;
  final DateTime date;
  final void Function(DateTime) onDateSelected;
  final bool required;

  const DatePickerField({
    super.key,
    required this.label,
    required this.date,
    required this.onDateSelected,
    this.required = false,
  });

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: () async {
      final picked = await showDatePicker(
        context: context,
        initialDate: date,
        firstDate: DateTime(2020),
        lastDate: DateTime(2030),
        builder: (ctx, child) => Theme(
          data: Theme.of(ctx).copyWith(
            // Transforming the Date Picker dialog to match Islamic Gold Theme
            colorScheme: const ColorScheme.dark(
              primary: kGold, // Header circle & selected day glow
              onPrimary: kPrimaryDark, // Text color inside selected day circle
              surface: kPrimaryDark, // Background of dialog box
              onSurface: Colors.white, // Normal text days
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: kGold, // Action buttons label color
                textStyle: GoogleFonts.cairo(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          child: child!,
        ),
      );
      if (picked != null) onDateSelected(picked);
    },
    child: InputDecorator(
      decoration: InputDecoration(
        labelText: label + (required ? ' *' : ''),
        labelStyle: GoogleFonts.cairo(color: Colors.white70),
        suffixIcon: const Icon(
          Icons.calendar_today_rounded,
          size: 18,
          color: kGold,
        ), // Golden elegant calendar icon
      ),
      child: Text(
        '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}',
        style: GoogleFonts.cairo(fontSize: 14, color: Colors.white),
      ),
    ),
  );
}

// ─── Form Section Label ───────────────────────
class FormSectionLabel extends StatelessWidget {
  final String text;
  const FormSectionLabel(this.text, {super.key});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: 12, bottom: 6),
    child: Text(
      text,
      style: GoogleFonts.cairo(
        fontSize: 13,
        fontWeight: FontWeight.bold,
        color: kGold, // Form section titles look stunning in gold accents
        letterSpacing: 0.5,
      ),
    ),
  );
}
