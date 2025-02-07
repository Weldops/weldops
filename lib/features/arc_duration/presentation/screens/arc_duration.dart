import 'package:esab/features/arc_duration/presentation/widgets/arc_time_card.dart';
import 'package:esab/features/arc_duration/presentation/widgets/arc_timing_hours.dart';
import 'package:esab/features/arc_duration/presentation/widgets/calendar_select.dart';
import 'package:esab/features/arc_duration/presentation/widgets/custom_bar_chart.dart';
import 'package:esab/themes/app_text_styles.dart';
import 'package:esab/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ArcDuration extends ConsumerWidget {
  const ArcDuration({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.primaryBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.primaryBackgroundColor,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: AppColors.secondaryColor,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Title(
            color: AppColors.secondaryColor,
            child: Column(
              children: [
                Text(
                  AppLocalizations.of(context)!.arcDuration,
                  style: AppTextStyles.appHeaderText,
                ),
              ],
            )),
        actions: [
          IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.more_vert,
                color: AppColors.secondaryColor,
              ))
        ],
      ),
      body: SafeArea(
          child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.02,
                  vertical: screenHeight * 0.04),
              child: Column(children: [
                const Padding(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: CalendarSelect()),
                const SizedBox(
                  height: 20,
                ),
                const Padding(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: ArcTimeCard()),
                const SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.helmetUsage,
                        style: AppTextStyles.secondaryRegularText,
                      ),
                      Row(
                        children: [
                          Container(
                            height: 7,
                            width: 7,
                            decoration: BoxDecoration(
                                color: AppColors.primaryColor,
                                borderRadius: BorderRadius.circular(7)),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            AppLocalizations.of(context)!.goodUsed,
                            style: AppTextStyles.secondaryRegularText,
                          )
                        ],
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                const CustomBarChart(),
                const SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      AppLocalizations.of(context)!.arcTimingHr,
                      style: AppTextStyles.secondaryRegularText,
                      textAlign: TextAlign.left,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                const Padding(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: ArcTimingHours())
              ]))),
    );
  }
}
