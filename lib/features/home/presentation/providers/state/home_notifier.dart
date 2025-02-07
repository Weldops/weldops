import 'package:esab/di/injector.dart';
import 'package:esab/features/home/domain/use_cases/add_device_use_case.dart';
import 'package:esab/features/home/domain/use_cases/get_device_use_case.dart';
import 'package:esab/features/home/domain/use_cases/remove_device_use_case.dart';
import 'package:esab/features/home/domain/use_cases/update_name_use_case.dart';
import 'package:esab/models/bluetooth_device.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'home_state.dart';

class HomeNotifier extends StateNotifier<HomeState> {
  final GetDeviceUseCase _getUseCase = injector.get<GetDeviceUseCase>();
  final AddDeviceUseCase _addUseCase = injector.get<AddDeviceUseCase>();
  final UpdateNameUseCase _updateUseCase = injector.get<UpdateNameUseCase>();
  final RemoveDeviceUseCase _removeUseCase =
      injector.get<RemoveDeviceUseCase>();

  HomeNotifier() : super(HomeState(devicesList: [], isGridView: true)) {
    _loadDevices();
  }

  Future<void> _loadDevices() async {
    final result = await _getUseCase.execute();
    result.fold(
      (error) {
        print("Failed to load devices: ${error.message}");
      },
      (devices) {
        state = state.copyWith(devicesList: devices.reversed.toList());
      },
    );
  }

  Future<void> addDevice(Device device) async {
    await _addUseCase.execute(device: device);
    await _loadDevices();
  }

  Future<void> removeDevice(String deviceId) async {
    await _removeUseCase.execute(device: deviceId);
    await _loadDevices();
  }

  Future<void> updateDeviceName(String deviceId, String deviceName) async {
    await _updateUseCase.execute(deviceId: deviceId, newDeviceName: deviceName);
    await _loadDevices();
  }

  void toggleViewMode() {
    state = state.copyWith(isGridView: !state.isGridView);
  }

  void updateSelectedIndex(int newIndex) {
    state = state.copyWith(selectedNavigationIndex: newIndex);
  }
}
