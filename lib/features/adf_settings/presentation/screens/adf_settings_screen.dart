import 'dart:async';

import 'package:esab/bluetooth/presentation/provider/bluetooth_device_state_notifier.dart';
import 'package:esab/features/adf_settings/presentation/screens/provider/adf_settings_state_notifier.dart';
import 'package:esab/features/adf_settings/presentation/screens/provider/state/adf_settings_state.dart';
import 'package:esab/features/adf_settings/presentation/widgets/adf_config_types.dart';
import 'package:esab/features/adf_settings/presentation/widgets/adf_feature_types.dart';
import 'package:esab/features/adf_settings/presentation/widgets/gauge_indicator.dart';
import 'package:esab/features/adf_settings/presentation/widgets/remove_bottom_sheet.dart';
import 'package:esab/features/adf_settings/presentation/widgets/rename_bottom_sheet.dart';
import 'package:esab/features/adf_settings/presentation/widgets/save_memory_bottom_sheet.dart';
import 'package:esab/features/adf_settings/presentation/widgets/welding_cutting_selection.dart';
import 'package:esab/features/home/presentation/providers/home_state_notifier_provider.dart';
import 'package:esab/features/memory/presentation/providers/memory_state_notifier.dart';
import 'package:esab/shared/widgets/buttons/custom_button.dart';
import 'package:esab/shared/widgets/buttons/custom_outlined_button.dart';
import 'package:esab/themes/app_text_styles.dart';
import 'package:esab/themes/colors.dart';
import 'package:esab/utils/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AdfSettingsScreen extends ConsumerStatefulWidget {
  const AdfSettingsScreen({super.key, required this.device});
  final Map<String, dynamic> device;

  @override
  ConsumerState<AdfSettingsScreen> createState() => _AdfSettingsScreenState();
}

class _AdfSettingsScreenState extends ConsumerState<AdfSettingsScreen> {
  Map<String, dynamic> helmet = {};
  List adfSettings = [];
  List<String> keys = ['shade', 'sensitivity', 'delay'];
  bool first = true;
  String action = 'save';
  Timer? _timer;
  @override
  void initState() {
    super.initState();
    init();
    ref.read(adfSettingStateNotifierProvider.notifier).setWorkingType('welding');

    startFetchingValues();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  init() async {
    Future.microtask(() async {
      final result = await ref
          .read(adfSettingStateNotifierProvider.notifier)
          .loadAdfSettings((widget.device['deviceId']).toString());
      if (result) {
        fetchHelmetData(false);
      } else {
        fetchHelmetData(true);
      }
    });
    Future.microtask(() async {
      await ref
          .read(memoryStateNotifierProvider.notifier)
          .getMemorySettings((widget.device['deviceId']).toString());
    });
  }


  Future<void> fetchHelmetData(type) async {
    final deviceState = ref.watch(bluetoothNotifierProvider);
    if (deviceState.device == null) {
      print("❌ Device is not connected");
      return;
    }

    print("🔗 Device is connected. Setting up notifications...");
    try {
      final state = ref.watch(bluetoothNotifierProvider);
      if (state.readCharacteristic != null) {
        print("✅ Enabling notifications for ${state.readCharacteristic?.serviceUuid}");
        await state.readCharacteristic!.setNotifyValue(true);

        state.readCharacteristic!.onValueReceived.listen((value) {
          print("7878Received Data from Helmet: $value");
          if (mounted) {
            setState(() {
              Map<String, dynamic> helmetJson = convertBluetoothDataToJson(value);
              helmet = helmetJson;
              adfSettings = helmetJson['adfSettings'];
              print("Updated Welding Shade: ${adfSettings[0]['shade']['default']}");
              print("Updated Cutting Shade: ${adfSettings[1]['shade']['default']}");            });
          }
        });
      } else {
        print("❌ Read characteristic not found");
      }
    } catch (e) {
      print("❌ Error setting up characteristic notifications: $e");
    }
  }


  Map<String, dynamic> convertBluetoothDataToJson(List<int> data) {
    print("121121212121${data.toString()}");
    bool isWeldingFirst = data[10] == 1;

    String firstMode = isWeldingFirst ? "Welding" : "Cutting";
    String secondMode = isWeldingFirst ? "Cutting" : "Welding";
// Separate welding and cutting shade values
    double weldingShade = data[11].toDouble() / 10;
    double cuttingShade = data[12].toDouble() / 10;
    print("121121212121${isWeldingFirst}");
    print("121121212121  1st mode${firstMode}");
    print("121121212121 2nd mode ${secondMode}");
    return {
      "modelId": widget.device['deviceId'],
      "modelName": widget.device['deviceName'],
      "imageUrl": "assets/images/helmet_image.png",
      "adfSettings": [
        {
          "modeType": "Welding",
          "image": "assets/images/welding_img.png",
          "shade": {
            "image": "assets/images/shade_img.png",
            "min": 5.0,
            "max": 13.0,
            "default": weldingShade
          },
          "sensitivity": {
            "image": "assets/images/sensitivity_img.png",
            "min": 0.0,
            "max": 5.0,
            "default": data[13].toDouble()
          },
          "delay": {
            "image": "assets/images/delay_img.png",
            "min": 0.0,
            "max": 5.0,
            "default": data[14].toDouble()
          }
        },
        {
          "modeType": "Cutting",
          "image": "assets/images/cutting_img.png",
          "shade": {
            "image": "assets/images/shade_img.png",
            "min": 5.0,
            "max": 13.0,
            "default": cuttingShade
          }
        }
      ]
    };
  }

  void startFetchingValues() {
    _timer = Timer.periodic(const Duration(seconds: 4), (timer) async {
      init();
    });
  }

  getDefaultValue() {
    Map<String, dynamic> values = {};
    adfSettings[0].forEach((key, value) {
      if (value is Map) {
        values['${key}Value'] = value["default"];
      }
    });
    return values;
  }

  getIndex(adfSettingsState, result) {
    int index = 99;
    if (adfSettingsState.values.isNotEmpty) {
      List valueList = adfSettingsState.values.values.toList();
      List vList = [
        result[6].toDouble(),
        result[7].toDouble(),
        result[8].toDouble()
      ];

      if (valueList.length == vList.length) {
        for (int i = 0; i < valueList.length; i++) {
          if (valueList[i] != vList[i]) {
            index = i;
            break;
          }
        }
      } else {
        print('The lists have different lengths and cannot be compared.');
      }
    }
    return index;
  }

  getDeviceValue(settings, result) {
    Map<String, dynamic> values = {};
    settings[result[5]].forEach((key, value) {
      if (value is Map) {
        double keyValue;
        if (result[keys.indexOf(key) + 6] > value["max"]) {
          keyValue = value["max"];
        } else if (result[keys.indexOf(key) + 6] < value["min"]) {
          keyValue = value["min"];
        } else {
          keyValue = result[keys.indexOf(key) + 6].toDouble();
        }
        values['${key}Value'] = keyValue;
      }
    });
    return values;
  }

  String getFirstKeyWithObject(Map<String, dynamic> data) {
    for (var key in data.keys) {
      if (data[key] is Map) {
        return key;
      }
    }
    return "";
  }

  String getStatue(BluetoothDevice? device) {
    String status = 'Disconnected';
    if (device?.remoteId.str == widget.device['deviceId']) {
      status = device!.isConnected
          ? AppLocalizations.of(context)!.connected
          : 'Disconnected';
    } else {
      status = 'Disconnected';
    }
    return status;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final bluetoothDevice = ref.watch(bluetoothNotifierProvider);
    final status = getStatue(bluetoothDevice.device);

    final adfSettingsState = ref.watch(adfSettingStateNotifierProvider);
    List<AdfSettingsState> memories =
    ref.watch(memoryStateNotifierProvider).reversed.toList();
    print("adfSettings: $adfSettings");
    print("workingType: ${adfSettingsState.workingType}");
    removeDevice() async {
      showModalBottomSheet(
          context: context,
          backgroundColor: AppColors.secondaryColor,
          isDismissible: false,
          isScrollControlled: true,
          builder: (context) {
            return RemoveDeviceBottomSheet(device: widget.device);
          }).then(
        (value) {
          if (value == 'removed') {
            Navigator.pop(context);
          }
        },
      );
      await ref
          .read(homeStateNotifierProvider.notifier)
          .removeDevice((widget.device['deviceId']).toString());
    }

    renameDevice() async {
      showModalBottomSheet(
          context: context,
          backgroundColor: AppColors.secondaryColor,
          isScrollControlled: true,
          builder: (context) {
            return RenameDevice(device: widget.device);
          });
    }

    save() async {
      showModalBottomSheet(
          context: context,
          backgroundColor: AppColors.secondaryColor,
          isScrollControlled: true,
          builder: (context) {
            return SaveMemory(
              adfSettingAction: adfSettingsState.isSelected ? 'choose' : action,
              device: widget.device,
              name: adfSettingsState.deviceName ?? '',
            );
          }).then(
        (value) {
          if (value == null) {
            ref
                .read(adfSettingStateNotifierProvider.notifier)
                .setName(adfSettingsState.deviceName ?? '');
          } else {
            init();
          }
        },
      );
    }

    final List<Map<String, dynamic>> popupMenuItems = [
      {
        'title': AppLocalizations.of(context)!.rename,
        'icon': const Icon(Icons.edit),
        'onTap': () => renameDevice(),
      },
      {
        'title': AppLocalizations.of(context)!.remove,
        'icon': const Icon(Icons.delete),
        'onTap': () => removeDevice(),
      }
    ];

    moveToMemoryPage() async {
      final result = await Navigator.of(context).pushNamed(
        '/memorySetting',
        arguments: {
          'device': widget.device,
          'adfSetting': adfSettings,
          'currentSetting': adfSettingsState
        },
      );
      if (result != null) {
        setState(() {
          action = 'edit';
        });
      } else {
        init();
      }
    }

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
          child: Column(
            children: [
              Text(
                widget.device['deviceName'],
                style: AppTextStyles.appHeaderText,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: 8,
                    width: 8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: status == AppLocalizations.of(context)!.connected
                          ? Colors.green
                          : Colors.red,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    status,
                    style: AppTextStyles.deviceStatus,
                  )
                ],
              )
            ],
          ),
        ),
        actions: [
          PopupMenuButton(
            position: PopupMenuPosition.under,
            style: const ButtonStyle(
                iconColor: WidgetStatePropertyAll(AppColors.labelColor)),
            itemBuilder: (context) => [
              ...popupMenuItems.map(
                (e) => PopupMenuItem(
                    onTap: e['onTap'],
                    child: Row(
                      children: [
                        e['icon'],
                        const SizedBox(
                          width: 10,
                        ),
                        Text(e['title'])
                      ],
                    )),
              )
            ],
          )
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.06, vertical: screenHeight * 0.04),
          child: adfSettingsState.workingType != null
              ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              WeldingCuttingSelection(
                modeList: adfSettings,
              ),
              if (helmet['adfSettings'] != null)
                ...adfSettings.map((x) {
                  if (adfSettingsState.workingType!.toLowerCase() ==
                      x['modeType'].toLowerCase()) {
                    bool isCuttingMode = x['modeType'].toLowerCase() == 'cutting';
                    return Column(
                      children: [
                        GaugeIndicator(
                          values: x,
                          isCuttingMode: isCuttingMode,
                        ),
                        AdfConfigTypes(
                          values: x,
                          isCuttingMode: isCuttingMode,
                        ),
                      ],
                    );
                  } else {
                    return const SizedBox(
                      width: 0,
                      height: 0,
                    );
                  }
                }),
              const SizedBox(
                height: 10,
              ),
              const Divider(
                color: AppColors.cardBgColor,
                thickness: 1,
                indent: 16,
                endIndent: 16,
              ),
              const SizedBox(
                height: 10,
              ),
              AdfFeatureTypes(
                device: widget.device,
              )
            ],
          )
              : const SizedBox(),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: CustomOutlinedButton(
                text: (adfSettingsState.isSelected && memories.isNotEmpty)
                    ? adfSettingsState.deviceName!
                    : AppLocalizations.of(context)!.memory,
                imagePath: AppImages.memoryImg,
                onPressed: () {
                  if (memories.isNotEmpty) moveToMemoryPage();
                },
                borderColor: memories.isNotEmpty
                    ? AppColors.primaryColor
                    : AppColors.gridLineColor,
                textColor: memories.isNotEmpty
                    ? AppColors.primaryColor
                    : AppColors.gridLineColor,
                imageColor: memories.isNotEmpty
                    ? AppColors.primaryColor
                    : AppColors.gridLineColor,
                height: 64,
                imageHeight: 18,
                imageWidth: 18,
              ),
            ),
            const SizedBox(
              width: 15,
            ),
            Expanded(
              child: CustomButton(
                buttonText: AppLocalizations.of(context)!.saveSetting,
                onTapCallback: () async {
                  save();
                },
                backgroundColor: AppColors.secondaryColor,
                height: 64,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
