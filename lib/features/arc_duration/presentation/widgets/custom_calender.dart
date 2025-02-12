import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../themes/app_text_styles.dart';
import '../../../../themes/colors.dart';

class CustomCalendarBottomSheet extends StatefulWidget {
  final Function(DateTime startDate, DateTime endDate)? onApply;

  const CustomCalendarBottomSheet({super.key,  this.onApply}) ;

  @override
  State<CustomCalendarBottomSheet> createState() => _CustomCalendarBottomSheetState();
}

class _CustomCalendarBottomSheetState extends State<CustomCalendarBottomSheet> {
  late DateTime startDate, endDate, currentMonth;

  @override
  void initState() {
    super.initState();
    endDate = DateTime.now();
    startDate = endDate.subtract(const Duration(days: 7));
    currentMonth = DateTime.now();
  }

  void _updateMonth(int offset) {
    setState(() => currentMonth = DateTime(currentMonth.year, currentMonth.month + offset));
  }

  void _resetDates() {
    setState(() {
      endDate = DateTime.now();
      startDate = endDate.subtract(const Duration(days: 7));
      currentMonth = endDate;
    });
  }

  void _applyDates() {
    widget.onApply?.call(startDate, endDate);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.secondaryColor,
      height: MediaQuery.of(context).size.height * 0.605,
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildDateSelector(),
          const SizedBox(height: 20),
          _buildCalendar(),
          const Spacer(),
          Row(
            children: [
              Expanded(child: _buildButton('Reset', AppColors.buttonBgColor, _resetDates)),
              const SizedBox(width: 16),
              Expanded(child: _buildButton('Apply', AppColors.primaryColor, _applyDates)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDateSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Custom Date Range', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
            IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildDateColumn('Start', startDate),
            _buildDateColumn('End', endDate),
          ],
        ),
      ],
    );
  }

  Widget _buildDateColumn(String label, DateTime date) {
    return Column(
      children: [
        Text(label, style: const TextStyle(color: Colors.grey)),
        Row(
          children: [
            const Icon(Icons.calendar_month, size: 20),
            const SizedBox(width: 8),
            Text(DateFormat('EEE, MMM d').format(date), style: const TextStyle(fontWeight: FontWeight.w500)),
          ],
        ),
      ],
    );
  }

  Widget _buildCalendar() {
    return Column(
      children: [
        Text(
          DateFormat('yyyy').format(currentMonth),
          style: AppTextStyles.buttonTextStyle
              .copyWith(fontWeight: FontWeight.w400),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(icon: const Icon(Icons.chevron_left), onPressed: () => _updateMonth(-1)),
            Text(DateFormat('MMMM').format(currentMonth), style: AppTextStyles.buttonTextStyle),
            IconButton(icon: const Icon(Icons.chevron_right), onPressed: () => _updateMonth(1)),
          ],
        ),
        _buildDaysGrid(),
      ],
    );
  }

  Widget _buildDaysGrid() {
    int daysInMonth = DateTime(currentMonth.year, currentMonth.month + 1, 0).day;
    int startWeekday = DateTime(currentMonth.year, currentMonth.month, 1).weekday % 7;
    DateTime today = DateTime.now();
    bool isTodayInMonth = today.year == currentMonth.year && today.month == currentMonth.month;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7, childAspectRatio: 1.5,),
      itemCount: daysInMonth + startWeekday,
      itemBuilder: (context, index) {
        if (index < startWeekday) return const SizedBox.shrink();

        final day = index - startWeekday + 1;
        final date = DateTime(currentMonth.year, currentMonth.month, day);
        final isToday = isTodayInMonth && date.day == today.day;
        final isEndDate = date.isAtSameMomentAs(endDate);
        final isStartDate = date.isAtSameMomentAs(startDate);
        final isInRange = date.isAfter(startDate) && date.isBefore(endDate);
        final isFirstColumn = index % 7 == 0;
        final isLastColumn = index % 7 == 6;

        return GestureDetector(
          onTap: () {
            setState(() {
              if (date.isBefore(endDate)) {
                startDate = date;
              } else {
                endDate = date;
              }
            });
          },
          child: Container(
          decoration: BoxDecoration(
                color: isStartDate || isEndDate || isInRange
                  ? Colors.yellow.withOpacity(0.6)
                  : null,
              borderRadius: BorderRadius.horizontal(
                left: (isStartDate && isFirstColumn)
                    ? const Radius.circular(16)
                    : Radius.zero,
                right: (isEndDate && isLastColumn)
                    ? const Radius.circular(16)
                    : Radius.zero,
              ),
            ),

        child: Center(
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isToday ? AppColors.primaryColor : null,
                ),
                child: Text(
                  textAlign: TextAlign.center,
                  '$day',
                  style: AppTextStyles.primerySmallText
                      .copyWith(fontWeight: FontWeight.w400),
                ),
              ),
          ),)
        );
      },
    );
  }

  Widget _buildButton(String text, Color color, VoidCallback onTap) {
    return Container(
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(12)),
      child: TextButton(
        onPressed: onTap,
        style: TextButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
        child: Text(text, style: AppTextStyles.primerySmallText),
      ),
    );
  }
}