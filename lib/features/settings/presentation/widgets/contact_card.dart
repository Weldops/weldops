import 'package:flutter/material.dart';

import '../../../../../../themes/app_text_styles.dart';
import '../../../../../../themes/colors.dart';

class ContactCard extends StatelessWidget {
  final String imagePath;
  final String title;
  final String highlightedText;
  final Color borderColor;
  final double height;
  final VoidCallback? onTap;

  const ContactCard({
    super.key,
    required this.imagePath,
    required this.title,
    required this.highlightedText,
    required this.height,
    this.borderColor = AppColors.cardBgColor,
    this.onTap
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: 103,
          width: 172,
          decoration: BoxDecoration(
            color: AppColors.transparent,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: borderColor, width: 2),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 24, width: 24, child: Image.asset(imagePath)),
              SizedBox(height: height),
              Text(
                title,
                textAlign: TextAlign.center,
                style: AppTextStyles.secondarySmallText
                    .copyWith(fontWeight: FontWeight.w300),
              ),
              SizedBox(height: height / 2),
              Text(
                highlightedText,
                style: AppTextStyles.primarySmallText
                    .copyWith(fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
