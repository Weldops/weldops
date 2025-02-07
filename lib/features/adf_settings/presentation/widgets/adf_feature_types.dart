import 'package:esab/themes/app_text_styles.dart';
import 'package:esab/themes/colors.dart';
import 'package:esab/utils/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AdfFeatureTypes extends StatelessWidget {
  const AdfFeatureTypes({required this.device, super.key});
  final Map<String, dynamic> device;

  @override
  Widget build(BuildContext context) {
    navigateToArcDuration() {
      Navigator.pushNamed(context, '/arcDuration');
    }

    navigateToService(device) async {
      Navigator.pushNamed(context, '/adfService',
          arguments: {'device': device});
    }

    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: navigateToArcDuration,
            child: AdfFeatureCard(
              name: AppLocalizations.of(context)!.arcTiming,
              feature: '55 mins',
              iconPath: AppImages.arcTimingImg,
              value: 13.0,
            ),
          ),
        ),
        Expanded(
          child: InkWell(
            onTap: () {
              navigateToService(device);
            },
            child: AdfFeatureCard(
              name: AppLocalizations.of(context)!.service,
              feature: 'View Log',
              iconPath: AppImages.serviceImg,
              value: 5.0,
            ),
          ),
        ),
      ],
    );
  }
}

class AdfFeatureCard extends StatelessWidget {
  final String name;
  final String feature;
  final String iconPath;
  final double value;

  const AdfFeatureCard({
    super.key,
    required this.name,
    required this.feature,
    required this.iconPath,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      child: Card(
        color: AppColors.cardBgColor,
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 10, left: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start, // Align at the top
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: AppColors.imageBgColor,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Image.asset(
                    iconPath,
                    height: 24,
                    width: 24,
                  ),
                ),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            style: AppTextStyles.deviceStatus,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            feature,
                            style: AppTextStyles.appSecondaryHeaderText,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.chevron_right_rounded,
                      color: AppColors.secondaryColor,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
