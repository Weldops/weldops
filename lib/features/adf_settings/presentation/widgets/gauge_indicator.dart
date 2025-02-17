import 'dart:convert';

import 'package:esab/bluetooth/presentation/provider/bluetooth_device_state_notifier.dart';
import 'package:esab/features/adf_settings/presentation/screens/provider/adf_settings_state_notifier.dart';
import 'package:esab/themes/app_text_styles.dart';
import 'package:esab/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gauge_indicator/gauge_indicator.dart';

class GaugeIndicator extends ConsumerWidget {
  final dynamic values;
  final bool isCuttingMode;

  const GaugeIndicator({
    super.key,
    required this.values,
    required this.isCuttingMode,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final adfSettingsState = ref.watch(adfSettingStateNotifierProvider);
    final device = ref.watch(bluetoothNotifierProvider);

    // For cutting mode, always use shade configuration
    String configType = isCuttingMode ? 'shade' :
    (adfSettingsState.configType?.toLowerCase() ?? 'shade');
    String type = configType;

    final configValues = values[configType] as Map<String, dynamic>? ?? {};
    if (configValues.isEmpty) {
      return const SizedBox.shrink();
    }

    double minGaugeValue = configValues['min'];
    double maxGaugeValue = configValues['max'];
    double defaultGaugeValue = configValues['default'];

    final screenWidth = MediaQuery.of(context).size.width;

    Future<void> increaseGaugeValue(double value, String key, double max) async {
      if (value < max) {
         // Use the existing notifier method
        ref.read(adfSettingStateNotifierProvider.notifier)
            .increaseGaugeValue(value, key, max);
      }
    }

    Future<void> decreaseGaugeValue(double value, String key, double min) async {
      if (value > min) {
        // Use the existing notifier method
        ref.read(adfSettingStateNotifierProvider.notifier)
            .decreaseGaugeValue(value, key, min);
      }
    }

    List<GaugeSegment> getGaugeSegments(String configType) {
      List<GaugeSegment> segments = [];
      var blocksRange = maxGaugeValue - minGaugeValue;
      double segmentSize = 1;

      for (int i = 0; i < blocksRange; i++) {
        double from = minGaugeValue + (i * segmentSize);
        double to = from + segmentSize;
        segments.add(
          GaugeSegment(
            from: from,
            to: to,
            color: AppColors.cardBgColor,
          ),
        );
      }
      return segments;
    }

    double getAdfSettingValue(String configType) {
        return adfSettingsState.values['ShadeValue'] ??
            defaultGaugeValue ??
            minGaugeValue;
    }

    return Stack(
      alignment: Alignment.center,
      children: [
        AnimatedRadialGauge(
          duration: const Duration(seconds: 0),
          radius: 240,
          value: getAdfSettingValue(type).toDouble(),
          axis: GaugeAxis(
            min: minGaugeValue,
            max: maxGaugeValue,
            degrees: 180,
            style: const GaugeAxisStyle(
              thickness: 40,
              background: Colors.transparent,
              segmentSpacing: 10,
            ),
            pointer: null,
            progressBar: const GaugeProgressBar.basic(
              color: AppColors.primaryColor,
            ),
            segments: getGaugeSegments(type),
          ),
          builder: (context, child, value) => Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  decreaseGaugeValue(
                      getAdfSettingValue(type).toDouble(),
                      type.toLowerCase(),
                      minGaugeValue
                  );
                },
                child: Container(
                  height: 32,
                  width: 32,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.secondaryColor,
                  ),
                  child: const Icon(
                    Icons.remove,
                    color: AppColors.secondaryTextColor,
                    size: 32,
                  ),
                ),
              ),
              SizedBox(width: screenWidth * 0.02),
              Text(
                value.toDouble().toString(),
                style: AppTextStyles.meterValueText,
              ),
              SizedBox(width: screenWidth * 0.02),
              GestureDetector(
                onTap: () {
                  increaseGaugeValue(
                      getAdfSettingValue(type).toDouble(),
                      type.toLowerCase(),
                      maxGaugeValue
                  );
                },
                child: Container(
                  height: 32,
                  width: 32,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primaryColor,
                  ),
                  child: const Icon(
                    Icons.add,
                    color: AppColors.secondaryTextColor,
                    size: 32,
                  ),
                ),
              ),
            ],
          ),
        ),

        // Start and End Text
        Positioned(
          left: 8,
          top: 210,
          child: Text(
            minGaugeValue.toString(),
            style: AppTextStyles.secondaryRegularText,
          ),
        ),
        Positioned(
          right: 8,
          top: 210,
          child: Text(
            maxGaugeValue.toString(),
            style: AppTextStyles.secondaryRegularText,
          ),
        ),
      ],
    );
  }
}
