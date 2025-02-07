// ignore_for_file: use_build_context_synchronously

import 'package:esab/features/adf_settings/presentation/screens/provider/adf_settings_state_notifier.dart';
import 'package:esab/features/adf_settings/presentation/screens/provider/state/adf_settings_state.dart';
import 'package:esab/features/memory/presentation/providers/memory_state_notifier.dart';
import 'package:esab/shared/widgets/buttons/custom_button.dart';
import 'package:esab/shared/widgets/buttons/custom_outlined_button.dart';
import 'package:esab/shared/widgets/inputs/outlined_input.dart';
import 'package:esab/themes/app_text_styles.dart';
import 'package:esab/themes/colors.dart';
import 'package:esab/utils/snackbar_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SaveMemory extends ConsumerStatefulWidget {
  final Map device;
  final String name;
  final String adfSettingAction;

  const SaveMemory({
    super.key,
    required this.device,
    required this.name,
    required this.adfSettingAction,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SaveMemoryState();
}

class _SaveMemoryState extends ConsumerState<SaveMemory> {
  TextEditingController nicknameController = TextEditingController();
  final GlobalKey<FormState> _saveFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _chooseFormKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref
          .read(memoryStateNotifierProvider.notifier)
          .getMemorySettings((widget.device['deviceId']).toString());
    });
    setState(() {
      nicknameController.text = widget.name;
    });
  }

  save() async {
    try {
      await ref
          .read(adfSettingStateNotifierProvider.notifier)
          .saveAdfSettings((widget.device['deviceId']).toString());

      SnackbarUtils.showSnackbar(
          context, AppLocalizations.of(context)!.saveSuccess);
      Navigator.pop(context, true);
    } catch (e) {
      print(e);
    }
  }

  update() async {
    try {
      await ref
          .read(adfSettingStateNotifierProvider.notifier)
          .updateMemorySettings();
      SnackbarUtils.showSnackbar(
          context, AppLocalizations.of(context)!.saveSuccess);
      Navigator.pop(context, true);
    } catch (e) {
      print(e);
    }
  }

  closeSheet() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    List<AdfSettingsState> memories =
        ref.watch(memoryStateNotifierProvider).reversed.toList();
    check(String value) {
      bool isExist = false;
      for (AdfSettingsState x in memories) {
        if (x.deviceName == value.trim()) {
          isExist = true;
        }
      }
      return isExist;
    }

    return Padding(
      padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          top: 20,
          left: 10,
          right: 10),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.save),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      AppLocalizations.of(context)!.saveMemorySetting,
                      style: AppTextStyles.buttonTextStyle,
                    ),
                  ],
                ),
                IconButton(
                    onPressed: () {
                      closeSheet();
                    },
                    icon: const Icon(Icons.close)),
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            if (widget.adfSettingAction == 'save' ||
                widget.adfSettingAction == 'edit')
              Form(
                key: _saveFormKey,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(AppLocalizations.of(context)!.currentMemory),
                        RichText(
                            text: TextSpan(
                                style: AppTextStyles.secondaryBodyText,
                                children: [
                              const WidgetSpan(
                                alignment: PlaceholderAlignment.middle,
                                child: CircleAvatar(
                                  radius: 5,
                                  backgroundColor: AppColors.primaryColor,
                                ),
                              ),
                              const WidgetSpan(
                                child: SizedBox(width: 10),
                              ),
                              TextSpan(
                                text: widget.name,
                              )
                            ]))
                      ],
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 5),
                      child: Divider(),
                    ),
                    OutlinedInputField(
                        label: AppLocalizations.of(context)!.setName,
                        controller: nicknameController,
                        onChanged: (value) {
                          ref
                              .read(adfSettingStateNotifierProvider.notifier)
                              .setName(nicknameController.text);
                        },
                        validator: (value) {
                          if (value != null && value != '') {
                            if (check(value)) {
                              return AppLocalizations.of(context)!.nameExist;
                            }
                            return null;
                          }
                          return AppLocalizations.of(context)!.enterName;
                        }),
                    const SizedBox(
                      height: 30,
                    ),
                    CustomButton(
                      buttonText: AppLocalizations.of(context)!.save,
                      onTapCallback: () {
                        if (widget.adfSettingAction == 'edit') {
                          update();
                        } else {
                          if (_saveFormKey.currentState!.validate()) {
                            save();
                          }
                        }
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
            if (widget.adfSettingAction == 'choose')
              Form(
                key: _chooseFormKey,
                child: Column(
                  children: [
                    Text(
                      AppLocalizations.of(context)!.overrideWorning,
                      style: AppTextStyles.secondaryBodyText,
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    OutlinedInputField(
                      label: AppLocalizations.of(context)!.setName,
                      controller: nicknameController,
                      onChanged: (value) {
                        ref
                            .read(adfSettingStateNotifierProvider.notifier)
                            .setName(nicknameController.text);
                      },
                      validator: (value) {
                        if (value != null && value != '') {
                          if (check(value)) {
                            return AppLocalizations.of(context)!.nameExist;
                          }
                          return null;
                        }
                        return AppLocalizations.of(context)!.enterName;
                      },
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: CustomButton(
                            buttonText:
                                AppLocalizations.of(context)!.overrideMemory,
                            onTapCallback: () {
                              update();
                            },
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: CustomOutlinedButton(
                            borderColor: AppColors.primaryBackgroundColor,
                            textColor: AppColors.primaryBackgroundColor,
                            text: AppLocalizations.of(context)!.createNewMemory,
                            onPressed: () {
                              if (_chooseFormKey.currentState!.validate()) {
                                save();
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
