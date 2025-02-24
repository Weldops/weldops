import 'package:esab/bluetooth/presentation/provider/bluetooth_device_state_notifier.dart';
import 'package:esab/features/home/presentation/providers/home_state_notifier_provider.dart';
import 'package:esab/shared/widgets/buttons/custom_button.dart';
import 'package:esab/shared/widgets/buttons/custom_outlined_button.dart';
import 'package:esab/themes/app_text_styles.dart';
import 'package:esab/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RemoveDeviceBottomSheet extends ConsumerStatefulWidget {
  final Map device;

  const RemoveDeviceBottomSheet({
    super.key,
    required this.device,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _RemoveDeviceBottomSheetState();
}

class _RemoveDeviceBottomSheetState
    extends ConsumerState<RemoveDeviceBottomSheet> {
  bool isRemoved = false;
  @override
  Widget build(BuildContext context) {
    closeSheet() {
      Navigator.of(context).pop();
    }

    void delete() async {
      try {
        await ref.read(bluetoothNotifierProvider.notifier).disConnect();
        await ref
            .read(homeStateNotifierProvider.notifier)
            .removeDevice((widget.device['deviceId']).toString());
        setState(() {
          isRemoved = true;
        });
      } catch (e) {
        print("Error while removing device: $e");
      }
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
                    const Icon(Icons.delete),
                    Text(
                      AppLocalizations.of(context)!.removeHelmet,
                      style: AppTextStyles.buttonTextStyle,
                    ),
                  ],
                ),
                if (!isRemoved)
                  IconButton(
                      onPressed: closeSheet, icon: const Icon(Icons.close)),
              ],
            ),
            Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                Text(isRemoved
                    ? AppLocalizations.of(context)!.deviceRemovedSuccessMessage1
                    : AppLocalizations.of(context)!.removeHelmetWarning),
                if (widget.device['imageUrl'] != null)
                  SizedBox(
                      height: 150,
                      child: Image.asset(widget.device['imageUrl'])),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(widget.device['deviceName']),
                    const SizedBox(
                      width: 10,
                    ),
                    if (isRemoved)
                      const CircleAvatar(
                        radius: 10,
                        backgroundColor: AppColors.successColor,
                        child: Icon(
                          Icons.check,
                          color: AppColors.secondaryColor,
                          size: 16,
                        ),
                      )
                  ],
                ),
                if (isRemoved)
                  const SizedBox(
                    height: 10,
                  ),
                if (isRemoved)
                  Text(AppLocalizations.of(context)!
                      .deviceRemovedSuccessMessage2),
                const SizedBox(
                  height: 30,
                ),
                if (!isRemoved)
                  Row(
                    children: [
                      Expanded(
                        child: CustomOutlinedButton(
                          borderColor: AppColors.primaryBackgroundColor,
                          textColor: AppColors.primaryBackgroundColor,
                          text: AppLocalizations.of(context)!.cancel,
                          onPressed: closeSheet,
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: CustomButton(
                          buttonText:
                              AppLocalizations.of(context)!.removeHelmet,
                          onTapCallback: () {
                            delete();
                          },
                        ),
                      ),
                    ],
                  ),
                if (isRemoved)
                  CustomButton(
                    buttonText: AppLocalizations.of(context)!.ok,
                    onTapCallback: () {
                      Navigator.pop(context, 'removed');
                    },
                  ),
                const SizedBox(
                  height: 30,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
