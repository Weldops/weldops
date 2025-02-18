import 'package:esab/themes/app_text_styles.dart';
import 'package:esab/themes/colors.dart';
import 'package:flutter/material.dart';

class AdfConfigCard extends StatelessWidget {
  final String name;
  final String iconPath;
  final double value;
  final bool isSelected;

  const AdfConfigCard(
      {super.key,
      required this.name,
      required this.iconPath,
      required this.value,
      required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 84,
      child: Card(
        color: isSelected ? AppColors.primaryColor : AppColors.cardBgColor,
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(
                    iconPath,
                    height: 24,
                    width: 24,
                    color: isSelected
                        ? AppColors.secondaryTextColor
                        : AppColors.secondaryColor,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    name,
                    style: isSelected
                        ? AppTextStyles.buttonTextStyle
                        : AppTextStyles.secondaryMediumText,
                  ),
                ],
              ),
              Text(
                name == 'Shade'? value.toDouble().toString():value.toInt().toString(),
                style: isSelected
                    ? AppTextStyles.buttonTextStyle
                    : AppTextStyles.secondaryRegularText,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
