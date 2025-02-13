import 'package:esab/features/adf_settings/presentation/screens/provider/adf_settings_state_notifier.dart';
import 'package:esab/features/adf_settings/presentation/screens/provider/state/adf_settings_state.dart';
import 'package:esab/features/adf_settings/presentation/widgets/adf_config_cards.dart';
import 'package:esab/shared/util/functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AdfConfigTypes extends ConsumerWidget {
  const AdfConfigTypes({required this.values, required this.isCuttingMode, super.key});
  final Map values;
  final bool isCuttingMode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final adfSettingsState = ref.watch(adfSettingStateNotifierProvider);

    return Wrap(
      runSpacing: 8.0,
      alignment: WrapAlignment.spaceBetween,
      children: _buildWidgets(values, adfSettingsState, ref),
    );
  }

  List<Widget> _buildWidgets(
      Map data, AdfSettingsState adfSettingsState, WidgetRef ref) {
    List<Widget> widgets = [];

    data.forEach((key, value) {
      if (value is Map) {
        widgets.add(
          LayoutBuilder(
            builder: (context, constraints) {
              double widthFactor = 1.0; // Default to 100% width
              int itemCount = data.length - 2;

              // Adjust width based on item count
              if (itemCount == 2 || itemCount == 4) {
                widthFactor = 0.47;
              } else if (itemCount == 1) {
                widthFactor = 1.0;
              } else {
                widthFactor = 0.33;
              }
              bool isSelected = isCuttingMode
                  ? (key == 'shade')
                  : (adfSettingsState.configType == key);
              return FractionallySizedBox(
                widthFactor: widthFactor,
                child: GestureDetector(
                  onTap: () {
                    ref
                        .read(adfSettingStateNotifierProvider.notifier)
                        .setConfigType(key);
                  },
                  child: AdfConfigCard(
                    name: Functions().toCamelCase(key),
                    iconPath: value['image'],
                    value: adfSettingsState
                            .values['${key.toString().toLowerCase()}Value'] ??
                        values[key.toString().toLowerCase()]['default'],
                    isSelected: isSelected,
                  ),
                ),
              );
            },
          ),
        );
      }
    });

    return widgets;
  }
}
