import 'package:esab/themes/app_text_styles.dart';
import 'package:flutter/material.dart';

class AuthHeading extends StatelessWidget {
  final String text;

  const AuthHeading({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: AppTextStyles.authHeading,
    );
  }
}
