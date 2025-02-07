import 'package:flutter/material.dart';

import '../../../../themes/app_text_styles.dart';
import '../../../../themes/colors.dart';

Future<void> showCustomSnackBar(BuildContext context, String message) async {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      margin: const EdgeInsets.only(bottom: 100, left: 16, right: 16),
      backgroundColor: AppColors.secondaryColor,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      content: Row(
        children: [
          Expanded(
            child: Text(
              message,
              style: AppTextStyles.primerySmallText.copyWith(fontWeight: FontWeight.w400),
            ),
          ),
          GestureDetector(
            onTap: () => ScaffoldMessenger.of(context).hideCurrentSnackBar(),
            child: const Icon(Icons.close, color: AppColors.secondaryTextColor, size: 20),
          ),
        ],
      ),
      duration: const Duration(seconds: 2),
    ),
  );
}
