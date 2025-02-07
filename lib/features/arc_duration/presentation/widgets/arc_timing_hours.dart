import 'package:esab/themes/app_text_styles.dart';
import 'package:esab/utils/common.dart';
import 'package:flutter/material.dart';

class ArcTimingHours extends StatelessWidget {
  const ArcTimingHours({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        ArcTimingView(
            imagePath: AppImages.weldingArcTimeImg,
            type: 'Welding',
            duration: '4.00 hrs'),
        SizedBox(
          height: 20,
        ),
        ArcTimingView(
            imagePath: AppImages.cuttingArcTimeImg,
            type: 'Cutting',
            duration: '5.0 hrs')
      ],
    );
  }
}

class ArcTimingView extends StatelessWidget {
  final String type;
  final String imagePath;
  final String duration;
  const ArcTimingView(
      {super.key,
      required this.type,
      required this.imagePath,
      required this.duration});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Image.asset(
              imagePath,
              height: 52,
              width: 52,
              fit: BoxFit.contain,
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              type,
              style: AppTextStyles.secondaryMediumText,
            )
          ],
        ),
        Text(
          duration,
          style: AppTextStyles.secondaryMediumText,
        )
      ],
    );
  }
}
