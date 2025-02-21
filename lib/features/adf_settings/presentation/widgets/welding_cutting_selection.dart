import 'package:esab/features/adf_settings/presentation/screens/provider/adf_settings_state_notifier.dart';
import 'package:esab/themes/app_text_styles.dart';
import 'package:esab/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WeldingCuttingSelection extends ConsumerStatefulWidget {
  const WeldingCuttingSelection({super.key, required this.modeList});
  final List modeList;

  @override
  ConsumerState<WeldingCuttingSelection> createState() =>
      _WeldingCuttingSelectionState();
}

class _WeldingCuttingSelectionState
    extends ConsumerState<WeldingCuttingSelection> {
  @override
  Widget build(BuildContext context) {
    final adfSettingsState = ref.watch(adfSettingStateNotifierProvider);

    handleSelectWelding(type) {
      ref.read(adfSettingStateNotifierProvider.notifier).setWorkingType(type);
      setState(() {});
    }

    return Center(
      child: Container(
        height: 60,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(5),
          border: Border.all(
            color: AppColors.secondaryColor, // Border color
            width: 1.0,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ...widget.modeList.map(
              (x) {
                return Expanded(
                  child: GestureDetector(
                    onTap: () {
                      handleSelectWelding(x["modeType"]);
                    },
                    child: Container(
                      height: double.infinity,
                      color: (adfSettingsState.workingType)?.toLowerCase() ==
                              x['modeType'].toLowerCase()
                          ? AppColors.primaryColor
                          : Colors.transparent,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            x['image'],
                            width: 24,
                            height: 24,
                            color:
                                (adfSettingsState.workingType!).toLowerCase() ==
                                        x['modeType'].toLowerCase()
                                    ? AppColors.secondaryTextColor
                                    : AppColors.secondaryColor,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            x['modeType'],
                            style:
                                (adfSettingsState.workingType!).toLowerCase() ==
                                        x['modeType'].toLowerCase()
                                    ? AppTextStyles.buttonTextStyle
                                    : AppTextStyles.secondaryMediumText,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
