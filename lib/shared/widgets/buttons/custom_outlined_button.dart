import 'package:esab/themes/app_text_styles.dart';
import 'package:esab/themes/colors.dart';
import 'package:esab/shared/widgets/loaders/custom_circular_loading.dart';
import 'package:flutter/material.dart';

class CustomOutlinedButton extends StatelessWidget {
  final String? imagePath;
  final String text;
  final VoidCallback onPressed;
  final bool? isLoading;
  final Color? borderColor;
  final Color? textColor;
  final Color? imageColor;
  final double? height;
  final double? imageHeight;
  final double? imageWidth;

  const CustomOutlinedButton(
      {super.key,
      this.imagePath,
      required this.text,
      required this.onPressed,
      this.isLoading,
      this.borderColor,
      this.textColor,
      this.imageColor,
      this.height,
      this.imageHeight,
      this.imageWidth});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: height ?? 52,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          side: BorderSide(
            color: borderColor ?? AppColors.secondaryColor,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        child: isLoading == true
            ? const CustomCircularLoading(width: 28, height: 28)
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (imagePath != null)
                    Image.asset(
                      imagePath!,
                      width: imageWidth ?? 32,
                      height: imageHeight ?? 32,
                      color: imageColor,
                    ),
                  const SizedBox(width: 15),
                  Text(
                    text,
                    style: AppTextStyles.secondaryMediumText.copyWith(
                      color: textColor ?? AppColors.secondaryColor,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
