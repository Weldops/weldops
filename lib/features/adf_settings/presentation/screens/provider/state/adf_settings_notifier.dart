import 'dart:convert';

import 'package:esab/bluetooth/presentation/provider/state/bluetooth_device_notifier.dart';
import 'package:esab/di/injector.dart';
import 'package:esab/features/adf_settings/domain/use_cases/delete_adf_memory_use_case.dart';
import 'package:esab/features/adf_settings/domain/use_cases/get_adf_settings_use_case.dart';
import 'package:esab/features/adf_settings/domain/use_cases/save_adf_settings_use_case.dart';
import 'package:esab/features/adf_settings/domain/use_cases/update_adf_memory_use_case.dart';
import 'package:esab/features/adf_settings/presentation/screens/provider/state/adf_settings_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdfSettingsNotifier extends StateNotifier<AdfSettingsState> {
  final GetAdfSettingUseCase _getUseCase = injector.get<GetAdfSettingUseCase>();
  final DeleteAdfMemoryUseCase _deleteUseCase =
      injector.get<DeleteAdfMemoryUseCase>();
  final UpdateAdfMemoryUseCase _updateUseCase =
      injector.get<UpdateAdfMemoryUseCase>();
  final SaveAdfSettingUseCase _saveUseCase =
      injector.get<SaveAdfSettingUseCase>();
  final BluetoothDeviceNotifier _bluetoothDeviceNotifier;
  AdfSettingsNotifier(this._bluetoothDeviceNotifier)
      : super(AdfSettingsState());

  init(String workingType, String configType, Map<String, dynamic> values) {
    state = AdfSettingsState(
        workingType: workingType, configType: configType, values: values);
  }

  AdfSettingsState getSelectedAdfSetting(List<AdfSettingsState> adfSettings) {
    return adfSettings.firstWhere(
      (setting) => setting.isSelected,
      orElse: () =>
          AdfSettingsState(),
    );
  }

  Future<bool> loadAdfSettings(String deviceId) async {
    final result = await _getUseCase.execute(deviceId);
    bool status = false;
    result.fold(
      (exception) {
        print('Error: $exception');
        status = false;
      },
      (settings) {
        state = getSelectedAdfSetting(settings);
        status = getSelectedAdfSetting(settings).id != null;
      },
    );
    return status;
  }

  Future<void> saveAdfSettings(String deviceId) async {
    try {
      await _saveUseCase.execute(deviceId, state);
      loadAdfSettings(deviceId);
    } catch (e) {
      print('error--- $e');
    }
  }

  Future<void> deleteMemorySettings(String id, String deviceId) async {
    try {
      await _deleteUseCase.execute(id);
      loadAdfSettings(deviceId);
    } catch (e) {
      print('error--- $e');
    }
  }

  Future<void> updateMemorySettings() async {
    try {
      await _updateUseCase.execute(
          state.id!,
          {
            'deviceId': state.deviceId,
            'workingType': state.workingType,
            'configType': state.configType,
            'deviceName': state.deviceName,
            'isSelected': 1,
            'values': jsonEncode(state.values),
          },
          false);
      loadAdfSettings(state.deviceId);
    } catch (e) {
      print('error--- $e');
    }
  }

  Future<void> applyMemorySettings(AdfSettingsState adfSettings) async {
    try {
      await _updateUseCase.execute(
          adfSettings.id!,
          {
            'deviceId': adfSettings.deviceId,
            'workingType': adfSettings.workingType,
            'configType': adfSettings.configType,
            'deviceName': adfSettings.deviceName,
            'isSelected': 1,
            'values': jsonEncode(adfSettings.values),
          },
          true);
      loadAdfSettings(adfSettings.deviceId);
    } catch (e) {
      print('error--- $e');
    }
  }

  void setWorkingType(String workingType) async {
    List<int> command = await getValue(null, null, workingType);
    _bluetoothDeviceNotifier.write(command);
    state = AdfSettingsState(
        configType: state.configType,
        deviceId: state.deviceId,
        id: state.id,
        workingType: workingType,
        values: state.values);
  }

  void setDeviceId(String devId) {
    state = state.copyWith(deviceId: devId);
  }

  void setName(String name) {
    state = state.copyWith(deviceName: name);
  }

  void setState(AdfSettingsState adfSettings) {
    state = adfSettings;
  }

  void setConfigType(String configType) {
    state = state.copyWith(configType: configType);
  }


  Future<List<int>> getValue(
    double? newValue,
    String? key,
    String type,
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int weldShade = prefs.getInt("weldShade") ?? 0;
    int cuttingShade = prefs.getInt("cuttingShade") ?? 0;
    List<String> mode = ['welding', 'cutting'];

    int modeIndex = mode.indexOf(type.toLowerCase());
    if (modeIndex == -1) {
      print("Invalid mode type: $type");
      modeIndex = 1; // Default to 1 if invalid
    } else {
      modeIndex += 1; // Convert 0 → 1 (welding) and 1 → 2 (cutting)
    }

    double currentShade = state.values['shadeValue'] ?? 8.0;
    double currentSensitivity = state.values['sensitivityValue'] ?? 3.0;
    double currentDelay = state.values['delayValue'] ?? 3.0;
    /// Update specific value if key is provided
    if (key != null && newValue != null) {
      switch (key.toLowerCase()) {
        case 'shade':
          currentShade = newValue;
          if (modeIndex == 1) {
            weldShade = (newValue * 10).round();
            await prefs.setInt("weldShade", weldShade);
          } else {
            cuttingShade = (newValue * 10).round();
            await prefs.setInt("cuttingShade", cuttingShade);
          }
          break;
        case 'sensitivity':
          currentSensitivity = newValue;
          break;
        case 'delay':
          currentDelay = newValue;
          break;
      }
    }

    List<int> intValueList = [
      weldShade, // Weld Shade
      cuttingShade, // Cutting Shade
      currentSensitivity.round(), // Sensitivity
      currentDelay.round(), // Delay
    ];

    // Construct the full Bluetooth command
    List<int> command = [
      0xEA, 0x01, 0x03, // Header
      cuttingShade == 0 ? 0x01 : 0x02,
      0x00, 0x00, 0x00, 0x00, 0x00, 0x00, // Padding
      modeIndex, // Mode type (welding or cutting)
      ...intValueList, // Weld Shade, Cutting Shade, Sensitivity, Delay
      8, 0, 0, // Additional settings (percentage, memory, setting)
      0xBA, 0xDC // Checksum
    ];
    print("command sending ...${command}");
    return command;
  }

  Future<void> increaseGaugeValue(double value, String key, double max) async {
    try {
      Map<String, double> newGaugeValue = Map.from(state.values);
      double increment = key.toLowerCase() == 'shade' ? 0.5 : 1.0;
      double newValue = value + increment;

      if (newValue <= max) {
        final String modeKey = state.workingType?.toLowerCase() == 'cutting' ? 'cutting' : 'welding';
        final String fullKey = '${modeKey}_${key.toLowerCase()}Value';

        newGaugeValue[fullKey] = newValue;
        state = state.copyWith(values: newGaugeValue);
        List<int> command = await getValue(newValue, key, state.workingType ?? 'welding');
        _bluetoothDeviceNotifier.write(command);
      }
    } catch (e) {
      print('Error in increaseGaugeValue: $e');
    }
  }

  Future<void> decreaseGaugeValue(double value, String key, double min) async {
    try {
      Map<String, double> newGaugeValue = Map.from(state.values);
      double decrement = key.toLowerCase() == 'shade' ? 0.5 : 1.0;
      double newValue = value - decrement;

      if (newValue >= min) {
        final String modeKey = state.workingType?.toLowerCase() == 'cutting' ? 'cutting' : 'welding';
        final String fullKey = '${modeKey}_${key.toLowerCase()}Value';

        newGaugeValue[fullKey] = newValue;
        state = state.copyWith(values: newGaugeValue);
        List<int> command = await getValue(newValue, key, state.workingType ?? 'welding');
        _bluetoothDeviceNotifier.write(command);
      }
    } catch (e) {
      print('Error in decreaseGaugeValue: $e');
    }
  }


}
