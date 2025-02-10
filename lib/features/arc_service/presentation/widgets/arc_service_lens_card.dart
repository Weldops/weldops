import 'package:esab/themes/app_text_styles.dart';
import 'package:esab/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class LensCard extends ConsumerWidget {
  const LensCard(
      {required this.title,
      required this.percentage,
      required this.imageUrl,
      required this.hours,
      this.id,
      super.key});

  final String title;
  final int percentage;
  final String imageUrl;
  final String hours;
  final int? id;

  getColor() {
    if (percentage <= 30) {
      return AppColors.successColor;
    } else if (percentage <= 70) {
      return AppColors.mediumColor;
    } else {
      return AppColors.errorColor;
    }
  }

  getStatement() {
    if (percentage <= 30) {
      return 'In Good Condition';
    } else if (percentage <= 70) {
      return 'In Average Condition';
    } else {
      return 'Replacement Recommended';
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      color: AppColors.cardBgColor,
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: 50,
                      child: Image.asset(
                        imageUrl,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(title, style: AppTextStyles.bodyText),
                  ],
                ),
                PopupMenuButton(
                  iconColor: AppColors.secondaryColor,
                  itemBuilder: (context) {
                    return [
                      PopupMenuItem(
                          onTap: () async {
                            if (context.mounted) {
                               await Navigator.pushNamed(
                                  context, '/serviceLensAdjust',
                                  arguments: {
                                    'id': id,
                                    'title': title,
                                    'percentage': percentage,
                                    'imageUrl': imageUrl,
                                    'hours': hours
                                  });
                            }
                          },
                          child: Row(
                            children: [
                              Container(
                                alignment: Alignment.center,
                                width: 20,
                                height: 20,
                                decoration: BoxDecoration(
                                    color: AppColors.secondaryColor,
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: AppColors.cardBgColor,
                                    )),
                                child: const Icon(
                                  Icons.circle,
                                  color: AppColors.cardBgColor,
                                  size: 8,
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              const Text('Adjust Value'),
                            ],
                          ))
                    ];
                  },
                )
              ],
            ),
            const SizedBox(height: 16),

            // Percentage and Recommendation
            Row(
              children: [
                Text(
                  '$percentage%',
                  style: const TextStyle(
                    color: AppColors.secondaryColor,
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: getColor(),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Stack(
                        children: [
                          const Icon(
                            Icons.water_drop,
                            color: AppColors.secondaryColor,
                            size: 16,
                          ),
                          Positioned(
                            top: 5,
                            left: 3,
                            child: Icon(
                              Icons.percent,
                              color: getColor(),
                              size: 10,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        getStatement(),
                        style: const TextStyle(
                          color: AppColors.secondaryColor,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Predicted Lifespan
            Text(
              'Predicted Lifespan: $hours hours remaining',
              style: const TextStyle(
                color: AppColors.secondaryColor,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 16),

            // Bar Indicator
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 3,
                  child: Container(
                    padding: const EdgeInsets.only(bottom: 10),
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                        border: Border(
                            right:
                                BorderSide(color: AppColors.secondaryColor))),
                    child: const Text(
                      'good (0-30%)',
                      style: TextStyle(
                        color: AppColors.secondaryColor,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: Container(
                    padding: const EdgeInsets.only(bottom: 10),
                    decoration: const BoxDecoration(
                        border: Border(
                            right:
                                BorderSide(color: AppColors.secondaryColor))),
                    alignment: Alignment.center,
                    child: const Text(
                      'medium (31-70%)',
                      style: TextStyle(
                        color: AppColors.secondaryColor,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
                const Expanded(
                  flex: 3,
                  child: Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 10),
                      child: Text(
                        'bad (71-100%)',
                        style: TextStyle(
                          color: AppColors.secondaryColor,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Container(
                    height: 30,
                    decoration: const BoxDecoration(
                      color: AppColors.successColor,
                      border: Border(
                          right: BorderSide(color: AppColors.secondaryColor)),
                      borderRadius:
                          BorderRadius.horizontal(left: Radius.circular(8)),
                    ),
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: Container(
                    decoration: const BoxDecoration(
                        color: AppColors.mediumColor,
                        border: Border(
                            right:
                                BorderSide(color: AppColors.secondaryColor))),
                    height: 30,
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Container(
                    height: 30,
                    decoration: const BoxDecoration(
                      color: AppColors.errorColor,
                      borderRadius:
                          BorderRadius.horizontal(right: Radius.circular(8)),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
