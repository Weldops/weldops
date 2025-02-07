import 'package:flutter/material.dart';
import '../../../../themes/app_text_styles.dart';
import '../../../../themes/colors.dart';

class HeaderBar extends StatelessWidget {
  final String text;
  final double height;
  final String? image;
  final bool isQuestionCard;
  final String? description;
  final String? highlightText;
  final VoidCallback? onTap;

  const HeaderBar({
    super.key,
    required this.text,
    required this.height,
    this.image,
    this.isQuestionCard = false,
    this.description,
    this.highlightText,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    TextStyle style =
    AppTextStyles.secondarySmallText.copyWith(fontWeight: FontWeight.w400);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      height: height,
      width: double.infinity,
      color: AppColors.gridLineColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          isQuestionCard
              ? Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(text, style: style),
                if (description != null) ...[
                  const SizedBox(height: 10),
                  Text(description!, style: style),
                ],
                if (highlightText != null) ...[
                  const SizedBox(height: 10),
                  InkWell(onTap: onTap,
                    child: Text(highlightText!,
                        style: AppTextStyles.primarySmallText),
                  ),
                ],
              ],
            ),
          )
              : Text(text, style: AppTextStyles.secondarySmallText),
          if (image != null)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Image.asset(image!),
            ),
        ],
      ),
    );
  }
}
