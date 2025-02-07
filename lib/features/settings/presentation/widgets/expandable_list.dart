import 'package:flutter/material.dart';
import '../../../../themes/app_text_styles.dart';
import '../../../../themes/colors.dart';

class ExpandableListTile extends StatefulWidget {
  final String title;
  final String? expandedLabelText;
  final String expandedContent;
  final VoidCallback? onTap;
  final bool showDivider;
  final bool summaryFormat;

  const ExpandableListTile({
    super.key,
    required this.title,
    this.expandedLabelText,
    required this.expandedContent,
    this.onTap,
    this.showDivider = true,
    this.summaryFormat = true,
  });

  @override
  State<ExpandableListTile> createState() => _ExpandableListTileState();
}

class _ExpandableListTileState extends State<ExpandableListTile> {
  bool _isExpanded = false;

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
    widget.onTap?.call();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InkWell(
          onTap: _toggleExpanded,
          child: SizedBox(
            height: 54,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(widget.title, style: AppTextStyles.secondaryRegularText),
                const SizedBox(width: 8),
                Icon(
                  _isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_right,
                  color: AppColors.secondaryColor,
                ),
              ],
            ),
          ),
        ),
        if (_isExpanded) ...[
          const Divider(
            height: 1,
            thickness: 0.2,
            color: Colors.grey,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 16),
            child: widget.summaryFormat
                ? Text(
              widget.expandedContent,
              style: AppTextStyles.secondaryRegularText
            )
                : Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.expandedLabelText ?? '',
                  style: AppTextStyles.secondaryRegularText
                ),
                Text(
                  widget.expandedContent,
                  style: AppTextStyles.secondaryRegularText
                ),
              ],
            ),
          ),
        ],
        if (widget.showDivider)
          const Divider(
            height: 1,
            thickness: 0.2,
            color: Colors.grey,
          ),
      ],
    );
  }
}
