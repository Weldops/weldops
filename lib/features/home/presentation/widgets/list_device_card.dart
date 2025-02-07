import 'package:esab/themes/app_text_styles.dart';
import 'package:esab/themes/colors.dart';
import 'package:esab/utils/common.dart';
import 'package:flutter/material.dart';

class ListDeviceCard extends StatelessWidget {
  final double height;
  final double width;
  final String title;
  final String status;

  const ListDeviceCard(
      {super.key,
      required this.height,
      required this.width,
      required this.title,
      required this.status});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return SizedBox(
      height: height,
      width: width,
      child: Card(
        color: AppColors.cardBgColor,
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              AppImages.helmet1,
              height: 99,
              width: 91,
              fit: BoxFit.contain,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  child: Text(
                    title,
                    style: AppTextStyles.deviceTitle,
                  ),
                ),
                SizedBox(
                  height: screenHeight * 0.005,
                ),
                Flexible(
                  child: Text(
                    status,
                    style: AppTextStyles.secondaryRegularText,
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
