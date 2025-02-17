import 'package:esab/bluetooth/presentation/provider/bluetooth_device_state_notifier.dart';
import 'package:esab/features/add_device/presentation/screens/provider/add_device_state_notifier.dart';
import 'package:esab/features/home/presentation/providers/home_state_notifier_provider.dart';
import 'package:esab/models/bluetooth_device.dart';
import 'package:esab/shared/widgets/buttons/custom_button.dart';
import 'package:esab/shared/widgets/inputs/outlined_input.dart';
import 'package:esab/themes/app_text_styles.dart';
import 'package:esab/utils/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PairBottomSheet extends ConsumerStatefulWidget {
  final BluetoothDevice device;

  const PairBottomSheet({
    super.key,
    required this.device,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _PairBottomSheetState();
}

class _PairBottomSheetState extends ConsumerState<PairBottomSheet> {
  TextEditingController nicknameController = TextEditingController();
  TextEditingController pairingCodeController = TextEditingController();
  @override
  void initState() {
    super.initState();
    setState(() {
      nicknameController.text = widget.device.platformName;
    });
  }

  @override
  Widget build(BuildContext context) {
    final addDeviceState = ref.watch(addDeviceStateNotifierProvider);

    connectToHelmet() async {
      ref.read(addDeviceStateNotifierProvider.notifier).connectionSuccess();

      if (nicknameController.text.isEmpty) {
        ref
            .read(addDeviceStateNotifierProvider.notifier)
            .setNickNameError(AppLocalizations.of(context)!.enterNickName);
        return;
      }
      ref.read(addDeviceStateNotifierProvider.notifier).startConnecting();

      try {
        final result = await ref
            .read(bluetoothNotifierProvider.notifier)
            .connect(widget.device);

        if (result == 'true') {
          await Future.delayed(Duration(seconds: 2));

          List<BluetoothService> services = await widget.device.discoverServices();
          BluetoothService? targetService;
          BluetoothCharacteristic? readChar;
          BluetoothCharacteristic? writeChar;

          for (BluetoothService s in services) {
            print("211122111211 services${s.toString()}");
            final serviceUuid = s.uuid.toString().toLowerCase();

            if (serviceUuid.endsWith("ae30")) {
              targetService = s;
              for (BluetoothCharacteristic x in s.characteristics) {
                final uuid = x.uuid.toString().toLowerCase();
                print("211122111211${uuid.toString()}");
                if (uuid.endsWith("ae02")) {
                  readChar = x;
                }
                if (uuid.endsWith("ae01")) {
                  writeChar = x;
                }
              }
            }
          }

          if (targetService != null && readChar != null && writeChar != null) {
            if (mounted) {
               ref
                  .read(bluetoothNotifierProvider.notifier)
                  .setDevice(widget.device, readChar, writeChar);

                }
            ref.read(homeStateNotifierProvider.notifier).addDevice(Device(
                deviceId: widget.device.remoteId.str,
                deviceModel: widget.device.platformName,
                deviceName: widget.device.platformName,
                displayName: nicknameController.text.trim(),
                macAddress: widget.device.remoteId.str,
                imageUrl: 'assets/images/helmet_image.png',
                createdAt: DateTime.now(),
                data: 'data'));

            ref.read(addDeviceStateNotifierProvider.notifier).connectionSuccess();

          } else {
            print("Failed to find ae30 service or required characteristics");
            ref.read(addDeviceStateNotifierProvider.notifier).connectionFailure();
          }
        } else {
          print("Else in connectToHelmet:");
          ref.read(addDeviceStateNotifierProvider.notifier).connectionFailure();
        }
      } catch (e) {
        print('Error in connectToHelmet: $e');
        ref.read(addDeviceStateNotifierProvider.notifier).connectionFailure();
      }
    }

    getSheetHeading() {
      if (addDeviceState.isInitial) {
        return AppLocalizations.of(context)!.pairWithHelmet;
      } else if (addDeviceState.isConnecting) {
        return AppLocalizations.of(context)!.connectingHelmet;
      } else if (addDeviceState.isConnectionSuccess) {
        return AppLocalizations.of(context)!.connectionSucces;
      } else if (addDeviceState.isConnectionFailure) {
        return AppLocalizations.of(context)!.connectionError;
      }
      return AppLocalizations.of(context)!.pairWithHelmet;
    }

    closeSheet() {
      Navigator.of(context).pop();
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
                    Image.asset('assets/images/helmet_image.png',
                        width: 40, height: 40),
                    Text(
                      getSheetHeading(),
                      style: AppTextStyles.buttonTextStyle,
                    ),
                  ],
                ),
                IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.close)),
              ],
            ),
            if (addDeviceState.isInitial)
              Column(
                children: [
                  const SizedBox(
                    height: 30,
                  ),
                  OutlinedInputField(
                    label: AppLocalizations.of(context)!.nickname,
                    controller: nicknameController,
                    errorText: addDeviceState.nicknameError.isNotEmpty
                        ? addDeviceState.nicknameError
                        : null,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  OutlinedInputField(
                    label: AppLocalizations.of(context)!.enterPairingCode,
                    controller: pairingCodeController,
                    showInfo: true,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  CustomButton(
                    buttonText: AppLocalizations.of(context)!.connectHelmet,
                    onTapCallback: connectToHelmet,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              )
            else if (addDeviceState.isConnecting)
              Column(
                children: [
                  const SizedBox(
                    height: 30,
                  ),
                  Image.asset(AppImages.deviceConnecting, height: 75),
                  const SizedBox(
                    height: 30,
                  ),
                  Text(
                    AppLocalizations.of(context)!.connectionWait,
                    style: AppTextStyles.labelText,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                ],
              )
            else if (addDeviceState.isConnectionSuccess)
              Column(
                children: [
                  const SizedBox(
                    height: 30,
                  ),
                  Image.asset(AppImages.helmet1, height: 160),
                   Text(
                    widget.device.advName,
                    style: AppTextStyles.secondaryTextStyle,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Text(
                    AppLocalizations.of(context)!.deviceConnectionSuccess,
                    style: AppTextStyles.labelText,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  CustomButton(
                    buttonText: AppLocalizations.of(context)!.ok,
                    onTapCallback: closeSheet,
                  ),
                ],
              )
            else if (addDeviceState.isConnectionFailure)
              Column(
                children: [
                  const SizedBox(
                    height: 30,
                  ),
                  Image.asset(AppImages.connectionError, height: 160),
                  const SizedBox(
                    height: 30,
                  ),
                  Text(
                    AppLocalizations.of(context)!.connotConnectHelmet,
                    style: AppTextStyles.labelText,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.ensureHelmetOn,
                        style: AppTextStyles.labelText,
                        textAlign: TextAlign.start,
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        AppLocalizations.of(context)!.ensureBluetoothOn,
                        style: AppTextStyles.labelText,
                        textAlign: TextAlign.start,
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        AppLocalizations.of(context)!.ensureBluetoothRange,
                        style: AppTextStyles.labelText,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  CustomButton(
                    buttonText: 'Ok',
                    onTapCallback: closeSheet,
                  ),
                ],
              )
          ],
        ),
      ),
    );
  }
}
