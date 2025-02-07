import 'package:esab/themes/app_text_styles.dart';
import 'package:esab/themes/colors.dart';
import 'package:flutter/material.dart';

class SettingsRow extends StatefulWidget {
  const SettingsRow(
      {required this.icon,
      required this.title,
      required this.onTap,
      this.isSwitch = false,
      super.key});
  final IconData icon;
  final String title;
  final bool isSwitch;
  final void Function() onTap;

  @override
  State<SettingsRow> createState() => _SettingsRowState();
}

class _SettingsRowState extends State<SettingsRow> {
  bool val = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                widget.icon,
                color: AppColors.labelColor,
              ),
              const SizedBox(
                width: 10,
              ),
              Text(
                widget.title,
                style: AppTextStyles.bodyText,
              )
            ],
          ),
          if (!widget.isSwitch)
            InkWell(
              onTap: widget.onTap,
              child: const Icon(
                Icons.arrow_forward,
                color: AppColors.labelColor,
              ),
            ),
          if (widget.isSwitch)
            Switch(
              activeTrackColor: AppColors.primaryColor,
              activeColor: AppColors.primaryBackgroundColor,
              value: val,
              onChanged: (value) {
                val = value;
                setState(() {});
              },
            )
        ],
      ),
    );
  }
}
