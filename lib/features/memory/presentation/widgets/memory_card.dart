import 'package:esab/features/adf_settings/presentation/screens/provider/adf_settings_state_notifier.dart';
import 'package:esab/features/adf_settings/presentation/screens/provider/state/adf_settings_state.dart';
import 'package:esab/features/memory/presentation/widgets/delete_memory_bottom_sheet.dart';
import 'package:esab/shared/util/functions.dart';
import 'package:esab/themes/app_text_styles.dart';
import 'package:esab/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MemoryCard extends ConsumerWidget {
  const MemoryCard(
      {required this.adfSetting,
      required this.adfSettingState,
      required this.isSelected,
      super.key});
  final List adfSetting;
  final AdfSettingsState adfSettingState;
  final bool isSelected;

  Map<String, Object> getModeByType(String modeType) {
    return adfSetting.firstWhere(
          (mode) => mode["modeType"] == modeType,
      orElse: () => <String, Object>{},
    );
  }

  getAvatar() {
    if (adfSettingState.deviceName!.trim().contains(' ')) {
      List array = adfSettingState.deviceName!.trim().split(' ');
      String avatar = '';
      for (String x in array) {
        avatar = avatar + x[0];
      }
      return avatar;
    } else {
      if (adfSettingState.deviceName!.trim() == '') {
        return 'S';
      } else {
        return adfSettingState.deviceName!.trim()[0];
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    delete() async {
      showModalBottomSheet(
          context: context,
          backgroundColor: AppColors.secondaryColor,
          isScrollControlled: true,
          builder: (context) {
            return DeleteMemory(adfSetting: adfSettingState);
          });
    }

    edit() async {
      ref
          .read(adfSettingStateNotifierProvider.notifier)
          .setState(adfSettingState);
      Navigator.pop(context, 'Edit');
    }

    return Container(
      margin: const EdgeInsets.only(left: 10),
      padding: const EdgeInsets.all(10),
      height: MediaQuery.of(context).size.height * 0.3,
      width: MediaQuery.of(context).size.width * 0.46,
      decoration: BoxDecoration(
        color: isSelected ? AppColors.secondaryColor : AppColors.cardBgColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: isSelected
                    ? AppColors.primaryColor
                    : AppColors.primaryBackgroundColor,
                foregroundColor: AppColors.labelColor,
                child: isSelected
                    ? const Icon(
                        Icons.check,
                        color: AppColors.successColor,
                      )
                    : Text(getAvatar()),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      adfSettingState.deviceName ?? "Unknown",
                      style: isSelected
                          ? AppTextStyles.deviceSecondertTitle
                          : AppTextStyles.deviceTitle,
                      overflow: TextOverflow.visible,
                    ),
                    Text(
                      adfSettingState.workingType ?? "Unknown",
                      style: isSelected
                          ? AppTextStyles.primerySmallText
                          : AppTextStyles.secondarySmallText,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          ..._buildWidgets(getModeByType(adfSettingState.workingType ?? "unknown")),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Divider(),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              InkWell(
                onTap: () {
                  edit();
                },
                child: Icon(
                  Icons.edit_document,
                  color: isSelected
                      ? AppColors.primaryBackgroundColor
                      : AppColors.labelColor,
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              InkWell(
                onTap: () {
                  delete();
                },
                child: const Icon(
                  Icons.delete,
                  color: AppColors.errorColor,
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  List<Widget> _buildWidgets(Map data) {
    List<Widget> widgets = [];

    final String modeKey = adfSettingState.workingType?.toLowerCase() == 'cutting' ? 'cutting' : 'welding';

    data.forEach((key, value) {
      if (value is Map) {
        final String fullKey = '${modeKey}_${key.toLowerCase()}Value';
        final valueToDisplay = adfSettingState.values.containsKey(fullKey)
            ? adfSettingState.values[fullKey].toString()
            : 'N/A';

        widgets.add(Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RichText(
                    text: TextSpan(
                        style: isSelected
                            ? AppTextStyles.secondaryBodyText
                            : AppTextStyles.secondaryRegularText,
                        children: [
                      WidgetSpan(
                        alignment: PlaceholderAlignment.middle,
                        child: Image.asset(
                          value["image"],
                          color: isSelected
                              ? AppColors.primaryBackgroundColor
                              : AppColors.labelColor,
                          width: 25,
                        ),
                      ),
                      const WidgetSpan(
                        child: SizedBox(width: 10),
                      ),
                      TextSpan(
                        text: Functions().toCamelCase(key),
                      )
                    ])),
                Text(
                  valueToDisplay,
                  style: isSelected
                      ? AppTextStyles.secondaryBodyText
                      : AppTextStyles.secondaryRegularText,
                )
              ],
            ),
          ),
        ));
      }
    });

    return widgets;
  }
}
