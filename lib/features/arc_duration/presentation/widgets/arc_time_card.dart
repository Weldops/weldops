import 'package:esab/themes/app_text_styles.dart';
import 'package:esab/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ArcTimeCard extends StatelessWidget {
  const ArcTimeCard({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Container(
      height: 83,
      padding: const EdgeInsets.all(10),
      width: screenWidth,
      decoration: BoxDecoration(
          border: Border.all(color: AppColors.cardBgColor),
          borderRadius: BorderRadius.circular(5)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocalizations.of(context)!.avgArcTime,
                style: AppTextStyles.secondaryRegularText,
              ),
              Text(
                AppLocalizations.of(context)!.perWeek,
                style: AppTextStyles.secondaryRegularText,
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(
                Icons.access_time,
                color: AppColors.primaryColor,
              ),
              const SizedBox(
                width: 8,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '8.00',
                    style: AppTextStyles.bodyText,
                  ),
                  Text(
                    AppLocalizations.of(context)!.hoursOfArcTime,
                    style: AppTextStyles.secondaryRegularText,
                  )
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}
