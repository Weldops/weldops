import 'package:esab/themes/app_text_styles.dart';
import 'package:esab/themes/colors.dart';
import 'package:flutter/material.dart';

class UnderlineDropdown extends StatelessWidget {
  final String label;
  final List<DropdownMenuItem<dynamic>>? items;
  final bool showInfo;
  final String? errorText;
  final dynamic value;
  final ValueChanged<dynamic>? onChanged;

  const UnderlineDropdown({
    super.key,
    required this.label,
    required this.value,
    required this.items,
    this.showInfo = false,
    this.errorText,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const SizedBox(
                width: 10,
              ),
              if (showInfo)
                const Icon(
                  Icons.info,
                  size: 14,
                )
            ],
          ),
          const SizedBox(
            height: 5,
          ),
          Theme(
            data:Theme.of(context).copyWith(
              canvasColor: AppColors.cardBgColor, // Background color of dropdown items
            ),
            child: DropdownButtonFormField(
                items: items,
                onChanged: onChanged,
                value: value,
                decoration: InputDecoration(
                  labelText: label,
                  labelStyle: AppTextStyles.secondaryTextStyle,
                  enabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: AppColors.secondaryColor),
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: AppColors.secondaryColor),
                  ),
                  errorText: errorText,
                  errorStyle: AppTextStyles.errorSmallText,
                )),
          ),
        ],
      ),
    );
  }
}
