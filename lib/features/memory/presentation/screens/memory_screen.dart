import 'package:esab/features/adf_settings/presentation/screens/provider/adf_settings_state_notifier.dart';
import 'package:esab/features/adf_settings/presentation/screens/provider/state/adf_settings_state.dart';
import 'package:esab/features/memory/presentation/providers/memory_state_notifier.dart';
import 'package:esab/features/memory/presentation/widgets/memory_card.dart';
import 'package:esab/shared/widgets/buttons/custom_button.dart';
import 'package:esab/themes/app_text_styles.dart';
import 'package:esab/themes/colors.dart';
import 'package:esab/utils/snackbar_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MemoryScreen extends ConsumerStatefulWidget {
  const MemoryScreen(
      {required this.device,
      required this.adfSetting,
      required this.currentSetting,
      super.key});
  final Map<String, dynamic> device;
  final List adfSetting;
  final AdfSettingsState currentSetting;

  @override
  ConsumerState<MemoryScreen> createState() => _MemoryScreenState();
}

class _MemoryScreenState extends ConsumerState<MemoryScreen> {
  String selectedMode = "All";
  AdfSettingsState currentSetting = AdfSettingsState();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref
          .read(memoryStateNotifierProvider.notifier)
          .getMemorySettings((widget.device['deviceId']).toString());
    });
    setState(() {
      currentSetting = widget.currentSetting;
    });
  }

  save() async {
    try {
      await ref
          .read(adfSettingStateNotifierProvider.notifier)
          .applyMemorySettings(currentSetting);
      SnackbarUtils.showSnackbar(
          context, AppLocalizations.of(context)!.appliedSuccess);
      Navigator.of(context).pop();
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    List<AdfSettingsState> memories =
        ref.watch(memoryStateNotifierProvider).reversed.toList();
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
            child: Text(
              AppLocalizations.of(context)!.memorySettings,
              style: AppTextStyles.appHeaderText,
            )),
      ),
      body: memories.isNotEmpty
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    AppLocalizations.of(context)!.typeOfMode,
                    style: AppTextStyles.secondaryRegularText,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    children: [
                      InkWell(
                        splashColor: AppColors.primaryBackgroundColor,
                        onTap: () {
                          setState(() {
                            selectedMode = "All";
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 10),
                          margin: const EdgeInsets.only(right: 10),
                          decoration: BoxDecoration(
                              color: selectedMode != "All"
                                  ? AppColors.primaryBackgroundColor
                                  : AppColors.secondaryColor,
                              borderRadius: BorderRadius.circular(20)),
                          child: Text(
                            "All",
                            style: selectedMode == 'All'
                                ? AppTextStyles.buttonTextStyle
                                : AppTextStyles.secondaryRegularText,
                          ),
                        ),
                      ),
                      ...widget.adfSetting.map(
                        (e) {
                          return InkWell(
                            splashColor: AppColors.primaryBackgroundColor,
                            onTap: () {
                              setState(() {
                                selectedMode = e['modeType'];
                              });
                            },
                            child: Container(
                              margin: const EdgeInsets.only(right: 10),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 10),
                              decoration: BoxDecoration(
                                  color: selectedMode != e['modeType']
                                      ? AppColors.primaryBackgroundColor
                                      : AppColors.secondaryColor,
                                  borderRadius: BorderRadius.circular(20)),
                              child: Text(
                                e['modeType'],
                                style: selectedMode == e['modeType']
                                    ? AppTextStyles.buttonTextStyle
                                    : AppTextStyles.secondaryRegularText,
                              ),
                            ),
                          );
                        },
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Expanded(
                    child: SingleChildScrollView(
                  child: Wrap(
                    runSpacing: 10,
                    alignment: WrapAlignment.spaceBetween,
                    children: [
                      ...memories.map(
                        (e) {
                          if (e.workingType == selectedMode ||
                              selectedMode == "All") {
                            return InkWell(
                                onTap: () {
                                  setState(() {
                                    currentSetting = e;
                                  });
                                },
                                child: MemoryCard(
                                  isSelected: e.id == currentSetting.id,
                                  adfSetting: widget.adfSetting,
                                  adfSettingState: e,
                                ));
                          } else {
                            return const SizedBox(
                              width: 0,
                              height: 0,
                            );
                          }
                        },
                      )
                    ],
                  ),
                ))
              ],
            )
          : Center(
              child: Text(
                AppLocalizations.of(context)!.noDataAvailable,
                style: AppTextStyles.secondaryRegularText,
              ),
            ),
      bottomNavigationBar:
          (memories.isNotEmpty && currentSetting != widget.currentSetting)
              ? Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: CustomButton(
                    buttonText:
                        '${AppLocalizations.of(context)!.apply} ${currentSetting.deviceName}',
                    onTapCallback: () {
                      save();
                    },
                  ),
                )
              : const SizedBox(),
    );
  }
}
