import 'package:esab/themes/app_text_styles.dart';
import 'package:esab/themes/colors.dart';
import 'package:flutter/material.dart';

class NavigateText extends StatelessWidget {
  final String questionText;
  final String routeText;
  final VoidCallback onTapCallback;
  const NavigateText(
      {super.key,
      required this.questionText,
      required this.routeText,
      required this.onTapCallback});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          questionText,
          style: AppTextStyles.secondaryMediumText,
        ),
        const SizedBox(
          width: 5,
        ),
        GestureDetector(
          onTap: onTapCallback,
          child: Text(
            routeText,
            style: AppTextStyles.primaryMediumText.copyWith(
              decoration: TextDecoration.underline,
              decorationColor: AppColors.primaryColor,
            ),
          ),
        )
      ],
    );
  }
}
