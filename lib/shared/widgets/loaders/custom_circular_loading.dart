import 'package:esab/themes/colors.dart';
import 'package:flutter/material.dart';

class CustomCircularLoading extends StatelessWidget {
  final double width;
  final double height;
  const CustomCircularLoading({
    super.key,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: const CircularProgressIndicator(
        color: AppColors.secondaryColor,
        strokeWidth: 2.0,
      ),
    );
  }
}
