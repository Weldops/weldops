// ignore_for_file: use_build_context_synchronously

import 'package:esab/features/adf_settings/presentation/screens/provider/adf_settings_state_notifier.dart';
import 'package:esab/features/home/presentation/providers/home_state_notifier_provider.dart';
import 'package:esab/shared/widgets/buttons/custom_button.dart';
import 'package:esab/shared/widgets/inputs/outlined_input.dart';
import 'package:esab/themes/app_text_styles.dart';
import 'package:esab/themes/colors.dart';
import 'package:esab/utils/snackbar_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RenameDevice extends ConsumerStatefulWidget {
  final Map device;

  const RenameDevice({
    super.key,
    required this.device,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _RenameDeviceState();
}

class _RenameDeviceState extends ConsumerState<RenameDevice> {
  TextEditingController nicknameController = TextEditingController();
  final GlobalKey<FormState> _saveFormKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    setState(() {
      nicknameController.text = widget.device['deviceName'];
    });
  }

  update() async {
    try {
      await ref.read(homeStateNotifierProvider.notifier).updateDeviceName(
          widget.device['deviceId'].toString(), nicknameController.text.trim());
      SnackbarUtils.showSnackbar(
          context, AppLocalizations.of(context)!.saveSuccess);
      Navigator.pop(context);
      Navigator.pop(context);
    } catch (e) {
      print(e);
    }
  }

  closeSheet() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> memories =
        ref.watch(homeStateNotifierProvider).devicesList;
    check(String value) {
      bool isExist = false;
      for (Map<String, dynamic> x in memories) {
        if (x['deviceName'] == value.trim()) {
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
                      AppLocalizations.of(context)!.renameHelmet,
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
            Form(
              key: _saveFormKey,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(AppLocalizations.of(context)!.currentTitle),
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
                              text: widget.device['deviceName'],
                            )
                          ]))
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 5),
                    child: Divider(),
                  ),
                  OutlinedInputField(
                      label: AppLocalizations.of(context)!.title,
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
                      if (_saveFormKey.currentState!.validate()) {
                        update();
                      }
                    },
                  ),
                  const SizedBox(
                    height: 10,
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
