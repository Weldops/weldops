import 'package:esab/themes/app_text_styles.dart';
import 'package:esab/themes/colors.dart';
import 'package:esab/shared/widgets/loaders/custom_circular_loading.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback? onTapCallback; // Callback for button tap
  final String buttonText;
  final Color? backgroundColor;
  final bool? isLoading;
  final double? height;
  const CustomButton(
      {super.key,
      this.onTapCallback,
      required this.buttonText,
      this.backgroundColor,
      this.isLoading,
      this.height});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: height ?? 54,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor != null
              ? AppColors.secondaryColor
              : AppColors.primaryColor,
          elevation: 0,
          side: BorderSide.none,
          padding: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
        ),
        onPressed: onTapCallback,
        child: isLoading == true
            ? const CustomCircularLoading(width: 24, height: 24)
            : Text(
                buttonText,
                textAlign: TextAlign.center,
                style: AppTextStyles.buttonTextStyle,
              ),
      ),
    );
  }
}
