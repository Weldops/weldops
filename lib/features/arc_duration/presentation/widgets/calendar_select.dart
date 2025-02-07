import 'package:esab/themes/app_text_styles.dart';
import 'package:esab/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CalendarSelect extends StatelessWidget {
  const CalendarSelect({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> chartViewOptions = ['Week', 'Month', 'Year', 'Custom'];
    final screenWidth = MediaQuery
        .of(context)
        .size
        .width;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          AppLocalizations.of(context)!.calender,
          style: AppTextStyles.bodyText,
        ),
        Container(
          height: 40,
          width: screenWidth * 0.4,
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.primaryColor, width: 1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: DropdownButtonFormField<String>(
              onChanged: (String? newValue) {},
              decoration: const InputDecoration(
                border: InputBorder.none,
              ),
              value: 'Week',
              alignment: Alignment.centerLeft,
              items: chartViewOptions
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    style: AppTextStyles.secondaryBodyText,
                  ),
                );
              }).toList(),
              selectedItemBuilder: (BuildContext context) {
                return chartViewOptions.map<Widget>((String value) {
                  return Text(
                    value,
                    style: AppTextStyles.secondaryMediumText,
                  );
                }).toList();
              },
            ),
          ),
        ),
      ],
    );
  }
}