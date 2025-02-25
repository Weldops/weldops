import 'package:esab/themes/app_text_styles.dart';
import 'package:esab/themes/colors.dart';
import 'package:flutter/material.dart';

class OutlinedInputField extends StatelessWidget {
  final String label;
  final String? suffixText;
  final TextEditingController controller;
  final bool obscureText;
  final TextInputType inputType;
  final bool showInfo;
  final bool showLable;
  final String? errorText;
  final Widget? suffix;
  final Widget? prefix;
  final ValueChanged<String>? onChanged;
  final FormFieldValidator<String>? validator;

  const OutlinedInputField({
    super.key,
    required this.label,
    required this.controller,
    this.obscureText = false,
    this.showInfo = false,
    this.showLable = true,
    this.inputType = TextInputType.text,
    this.errorText,
    this.onChanged,
    this.validator,
    this.suffixText = '',
    this.suffix,
    this.prefix,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (showLable)
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
          TextFormField(
            controller: controller,
            obscureText: obscureText,
            keyboardType: inputType,
            onChanged: onChanged,
            validator: validator,
            style: const TextStyle(color: AppColors.secondaryTextColor),
            decoration: InputDecoration(
              suffixIcon: suffix,
              prefixIcon: prefix,
              hintText: label,
              suffixText: suffixText,
              hintStyle: const TextStyle(color: AppColors.secondaryTextColor),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.grey, width: 1.5),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide:
                    const BorderSide(color: AppColors.errorColor, width: 1.5),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide:
                    const BorderSide(color: AppColors.errorColor, width: 1.5),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.blue, width: 2),
              ),
              errorText: errorText,
              errorStyle: AppTextStyles.errorSmallText,
            ),
          )
        ],
      ),
    );
  }
}
