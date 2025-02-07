import 'package:esab/themes/app_text_styles.dart';
import 'package:esab/themes/colors.dart';
import 'package:esab/utils/common.dart';
import 'package:flutter/material.dart';

class UnderlinedInput extends StatefulWidget {
  final String labelText;
  final bool isPassword;
  final bool readOnly;
  final TextEditingController? controller;
  final String? errorText;
  final Widget? suffix;

  const UnderlinedInput(
      {super.key,
      required this.labelText,
      this.isPassword = false,
      this.controller,
      this.suffix,
      this.readOnly = false,
      this.errorText});

  @override
  UnderlinedInputState createState() => UnderlinedInputState();
}

class UnderlinedInputState extends State<UnderlinedInput> {
  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.isPassword;
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      keyboardType: widget.isPassword
          ? TextInputType.visiblePassword
          : TextInputType.emailAddress,
      cursorColor: AppColors.secondaryColor,
      obscureText: _obscureText,
      style: TextStyle(
        color:  widget.readOnly ? AppColors.labelColor.withOpacity(0.5) : AppColors.secondaryColor,
      ),
      readOnly: widget.readOnly,
      decoration: InputDecoration(
        labelText: widget.labelText,
        errorText: widget.errorText,
        errorStyle: AppTextStyles.errorSmallText,
        labelStyle: const TextStyle(color: AppColors.labelColor),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.secondaryColor),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.secondaryColor),
        ),
        suffixIcon: widget.isPassword
            ? IconButton(
          icon: Image.asset(
            _obscureText ? AppImages.eyeOffIcon : AppImages.eyeIcon,
            width: 24,
            height: 24,
          ),
          onPressed: () {
            _togglePasswordVisibility();
          },
        )
            : widget.suffix,
      ),
    );
  }
}
