import 'package:esab/features/arc_duration/presentation/providers/adf_duration_state_notifier.dart';
import 'package:esab/themes/app_text_styles.dart';
import 'package:esab/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CustomBarChart extends ConsumerWidget {
  const CustomBarChart({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final List<double> toYValues = [9, 12.0, 20, 9.0, 7.5, 5, 8.0];
    final touchedBarIndex = ref.watch(adfDurationStateNotifierProvider
        .select((state) => state.touchedBarIndex));
    Widget bottomTitles(double value, TitleMeta meta) {
      String text;
      switch (value.toInt()) {
        case 0:
          text = 'Mon';
          break;
        case 1:
          text = 'Tue';
          break;
        case 2:
          text = 'Wed';
          break;
        case 3:
          text = 'Thu';
          break;
        case 4:
          text = 'Fri';
          break;
        case 5:
          text = 'Sat';
          break;
        case 6:
          text = 'Sun';
          break;
        default:
          text = '';
          break;
      }
      final isTouched = value.toInt() == touchedBarIndex;
      return SideTitleWidget(
        axisSide: meta.axisSide,
        child: isTouched
            ? Container(
                width: 40,
                height: 16,
                decoration: BoxDecoration(
                  color: AppColors.primaryColor,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: FittedBox(
                  child: Text(
                    text,
                    style: AppTextStyles.secondaryTextStyle,
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            : Text(text, style: AppTextStyles.secondarySmallText),
      );
    }

    Widget leftTitles(double value, TitleMeta meta) {
      const style = AppTextStyles.secondarySmallText;
      return SideTitleWidget(
        axisSide: meta.axisSide,
        child: Text(
          value.toInt().toString(),
          style: style,
        ),
      );
    }

    return SizedBox(
      width: screenWidth,
      height: screenHeight * 0.3,
      child: Padding(
        padding: const EdgeInsets.only(top: 16),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final barsSpace = 4.0 * constraints.maxWidth / 10;
            final barsWidth = 8.0 * constraints.maxWidth / 90;
            return BarChart(
              BarChartData(
                alignment: BarChartAlignment.center,
                barTouchData: BarTouchData(
                    touchCallback: (event, response) {
                      if (event.isInterestedForInteractions &&
                          response?.spot != null) {
                        ref
                            .read(adfDurationStateNotifierProvider.notifier)
                            .setTouchBarIndex(
                                response!.spot!.touchedBarGroupIndex);
                      }
                    },
                    touchTooltipData: BarTouchTooltipData(
                      tooltipRoundedRadius: 30,
                      getTooltipColor: (BarChartGroupData group) {
                        return AppColors.secondaryColor;
                      },
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        return BarTooltipItem(
                          '${rod.toY.toInt()} hrs',
                          AppTextStyles.secondaryTextStyle,
                          children: [const TextSpan()],
                        );
                      },
                      tooltipMargin: 8,
                      tooltipPadding: const EdgeInsets.only(
                          left: 20, right: 20, top: 10, bottom: 6),
                    )),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 28,
                      getTitlesWidget: bottomTitles,
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        getTitlesWidget: leftTitles,
                        interval: 4),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                gridData: FlGridData(
                  show: true,
                  drawHorizontalLine: true,
                  checkToShowHorizontalLine: (value) {
                    return true;
                  },
                  getDrawingHorizontalLine: (value) => const FlLine(
                    color: AppColors.gridLineColor,
                    strokeWidth: 1,
                    dashArray: [4, 4],
                  ),
                  drawVerticalLine: false,
                ),
                borderData: FlBorderData(
                  show: true,
                  border: const Border(
                    top: BorderSide.none,
                    bottom: BorderSide(
                      color: AppColors.gridLineColor,
                      width: 2,
                    ),
                    left: BorderSide.none,
                    right: BorderSide.none,
                  ),
                ),
                groupsSpace: barsSpace,
                barGroups: List.generate(
                  7,
                  (index) => BarChartGroupData(
                    x: index,
                    barsSpace: 4,
                    barRods: [
                      BarChartRodData(
                        toY: toYValues[index],
                        borderRadius: BorderRadius.zero,
                        width: barsWidth,
                        gradient: LinearGradient(
                          colors: touchedBarIndex == index
                              ? [
                                  AppColors.barLinearTouchedGradient1,
                                  AppColors.barLinearTouchedGradient2
                                ]
                              : [
                                  AppColors.barLinearGradient1,
                                  AppColors.barLinearGradient2
                                ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ],
                  ),
                ),
                minY: 0,
                maxY: 24,
              ),
            );
          },
        ),
      ),
    );
  }
}
