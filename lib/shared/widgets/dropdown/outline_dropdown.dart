import 'package:esab/themes/app_text_styles.dart';
import 'package:flutter/material.dart';

class OutlineDropdown extends StatelessWidget {
  final String label;
  final List<DropdownMenuItem<dynamic>>? items;
  final bool showInfo;
  final String? errorText;
  // final dynamic value;
  final ValueChanged<dynamic>? onChanged;

  const OutlineDropdown({
    super.key,
    required this.label,
    // required this.value,
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
              Text(
                label,
                style: AppTextStyles.labelText,
              ),
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
          DropdownButtonFormField(
              items: items,
              onChanged: onChanged,
              // value: value,
              decoration: InputDecoration(
                labelText: label,
                labelStyle: const TextStyle(color: Colors.grey),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.grey, width: 1.5),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.blue, width: 2),
                ),
                errorText: errorText,
                errorStyle: AppTextStyles.errorSmallText,
              )),
        ],
      ),
    );
  }
}
