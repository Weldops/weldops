import 'dart:convert';

import 'package:esab/bluetooth/presentation/provider/state/bluetooth_device_notifier.dart';
import 'package:esab/di/injector.dart';
import 'package:esab/features/adf_settings/domain/use_cases/delete_adf_memory_use_case.dart';
import 'package:esab/features/adf_settings/domain/use_cases/get_adf_settings_use_case.dart';
import 'package:esab/features/adf_settings/domain/use_cases/save_adf_settings_use_case.dart';
import 'package:esab/features/adf_settings/domain/use_cases/update_adf_memory_use_case.dart';
import 'package:esab/features/adf_settings/presentation/screens/provider/state/adf_settings_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
          AdfSettingsState(), // Return null if no matching element is found
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
    await _bluetoothDeviceNotifier.write(getValue(null, null, workingType));
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

  void increaseGaugeValue(double value, String key, double max) {
    Map<String, double> newGaugeValue = Map.from(state.values);
    newGaugeValue['${key}Value'] = (value + 1).toDouble();
    if (newGaugeValue['${key}Value']! > max) {
      newGaugeValue['${key}Value'] = max;
    } else {
      _bluetoothDeviceNotifier.write(
          getValue(newGaugeValue['${key}Value']!, key, state.workingType!));
    }

    state = state.copyWith(values: newGaugeValue);
  }

  List<int> getValue(
    double? newValue,
    String? key,
    String type,
  ) {
    List mode = ['welding', 'cutting'];
    List<String> keys = ['shade', 'sensitivity', 'delay'];
    int modeIndex = mode.indexOf(type.toLowerCase());
    List valueList = state.values.values.toList();
    if (key != null) {
      valueList[keys.indexOf(key)] = newValue;
    }
    List<int> intValueList =
        valueList.map((value) => (value as double).toInt()).toList();
    return [1, 4, modeIndex, ...intValueList];
  }

  void decreaseGaugeValue(double value, String key, double min) {
    Map<String, double> newGaugeValue = Map.from(state.values);
    newGaugeValue['${key}Value'] = value - 1;
    if (newGaugeValue['${key}Value']! < min) {
      newGaugeValue['${key}Value'] = min;
    } else {
      _bluetoothDeviceNotifier.write(
          getValue(newGaugeValue['${key}Value']!, key, state.workingType!));
    }

    state = state.copyWith(values: newGaugeValue);
  }
}
