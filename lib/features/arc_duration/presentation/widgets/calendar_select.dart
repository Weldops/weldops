import 'package:esab/themes/app_text_styles.dart';
import 'package:esab/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';

import 'custom_calender.dart';

class CalendarSelect extends StatefulWidget {
  const CalendarSelect({super.key});

  @override
  State<CalendarSelect> createState() => _CalendarSelectState();
}

class _CalendarSelectState extends State<CalendarSelect> {
  final List<String> options = ['Week', 'Month', 'Year', 'Custom'];
  String selected = 'Week';
  DateTimeRange? dateRange;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(AppLocalizations.of(context)!.calender, style: AppTextStyles.bodyText),
        _buildDropdown(context),
      ],
    );
  }

  Widget _buildDropdown(BuildContext context) {
    return Container(
      height: 40,
      width: MediaQuery.of(context).size.width * 0.4,
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.primaryColor, width: 1),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: DropdownButtonFormField<String>(
        value: selected,
        decoration: const InputDecoration(border: InputBorder.none),
        items: options.map((value) => DropdownMenuItem(value: value, child: Text(value, style: AppTextStyles.secondaryBodyText))).toList(),
        selectedItemBuilder: (_) => options.map((value) => Text(_displayValue(value), style: AppTextStyles.secondaryMediumText)).toList(),
        onChanged: _onOptionChanged,
      ),
    );
  }

  String _displayValue(String value) {
    return (value == 'Custom' && dateRange != null)
        ? '${DateFormat('MM/dd').format(dateRange!.start)} - ${DateFormat('MM/dd').format(dateRange!.end)}'
        : value;
  }

  void _onOptionChanged(String? newValue) {
    if (newValue == null) return;
    setState(() => selected = newValue);
    if (newValue == 'Custom') _showCustomDatePicker();
  }

   void _showCustomDatePicker() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        child: CustomCalendarBottomSheet(
          onApply: (start, end) => setState(() => dateRange = DateTimeRange(start: start, end: end)),
        ),
      ),
    );
  }
}
