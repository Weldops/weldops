import 'package:esab/themes/colors.dart';
import 'package:flutter/material.dart';

class CategoryButton extends StatelessWidget {
  final String label;
  final String selectedType;
  final String value;
  final VoidCallback onTap;

  const CategoryButton({
    Key? key,
    required this.label,
    required this.selectedType,
    required this.value,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isSelected = selectedType == value;
    return InkWell(
      onTap: onTap,
      splashColor: AppColors.primaryBackgroundColor,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryColor : AppColors.transparent,
          border: Border.all(
            color: isSelected ? AppColors.primaryColor : AppColors.labelColor,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? AppColors.primaryBackgroundColor : AppColors.labelColor,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
