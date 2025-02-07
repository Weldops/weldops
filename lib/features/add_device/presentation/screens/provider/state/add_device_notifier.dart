import 'package:esab/features/add_device/presentation/screens/provider/state/add_device_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddDeviceNotifier extends StateNotifier<AddDeviceState> {
  AddDeviceNotifier() : super(AddDeviceState());

  void selectDevice(String deviceId) {
    state = state.copyWith(selectedDeviceId: deviceId);
  }

  void startConnecting() {
    state = state.copyWith(
        isInitial: false,
        isConnecting: true,
        isConnectionSuccess: false,
        isConnectionFailure: false);
  }

  void connectionSuccess() {
    state = state.copyWith(
        isConnecting: false,
        isConnectionSuccess: true,
        isConnectionFailure: false);
  }

  void connectionFailure() {
    state = state.copyWith(
        isConnecting: false,
        isConnectionSuccess: false,
        isConnectionFailure: true);
  }

  void setNickNameError(String error) {
    state = state.copyWith(nicknameError: error);
  }

  void reset() {
    state = AddDeviceState();
  }
}
