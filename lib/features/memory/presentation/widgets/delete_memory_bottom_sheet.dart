// ignore_for_file: use_build_context_synchronously

import 'package:esab/features/adf_settings/presentation/screens/provider/adf_settings_state_notifier.dart';
import 'package:esab/features/adf_settings/presentation/screens/provider/state/adf_settings_state.dart';
import 'package:esab/features/memory/presentation/providers/memory_state_notifier.dart';
import 'package:esab/shared/widgets/buttons/custom_button.dart';
import 'package:esab/shared/widgets/buttons/custom_outlined_button.dart';
import 'package:esab/themes/app_text_styles.dart';
import 'package:esab/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DeleteMemory extends ConsumerWidget {
  final AdfSettingsState adfSetting;

  const DeleteMemory({super.key, required this.adfSetting});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    closeSheet() {
      Navigator.of(context).pop();
    }

    delete() async {
      await ref
          .read(adfSettingStateNotifierProvider.notifier)
          .deleteMemorySettings(adfSetting.id!, adfSetting.deviceId);
      await ref
          .read(memoryStateNotifierProvider.notifier)
          .getMemorySettings(adfSetting.deviceId);
      closeSheet();
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
                      AppLocalizations.of(context)!.deleteMemory,
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
            Column(
              children: [
                Text(
                  AppLocalizations.of(context)!.deleteWorning,
                  style: AppTextStyles.secondaryBodyText,
                ),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  children: [
                    Expanded(
                      child: CustomOutlinedButton(
                        borderColor: AppColors.primaryBackgroundColor,
                        textColor: AppColors.primaryBackgroundColor,
                        text: AppLocalizations.of(context)!.cancel,
                        onPressed: () {
                          closeSheet();
                        },
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: CustomButton(
                        buttonText: AppLocalizations.of(context)!.deleteMemory,
                        onTapCallback: () {
                          delete();
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
          ],
        ),
      ),
    );
  }
}
