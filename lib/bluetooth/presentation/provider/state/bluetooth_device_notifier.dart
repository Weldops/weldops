import 'package:esab/bluetooth/domain/use_cases/connect_device_use_case.dart';
import 'package:esab/bluetooth/domain/use_cases/disconnect_device_use_case.dart';
import 'package:esab/bluetooth/domain/use_cases/read_characteristic_use_case.dart';
import 'package:esab/bluetooth/domain/use_cases/write_characteristic_use_case.dart';
import 'package:esab/bluetooth/presentation/provider/state/bluetooth_device_state.dart';
import 'package:esab/di/injector.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BluetoothDeviceNotifier extends StateNotifier<BtDeviceState> {
  BluetoothDeviceNotifier() : super(BtDeviceState());
  final ConnectDeviceUseCase _connect = injector.get<ConnectDeviceUseCase>();
  final DisconnectDeviceUseCase _disConnect =
      injector.get<DisconnectDeviceUseCase>();
  final ReadCharacteristicUseCase _read =
      injector.get<ReadCharacteristicUseCase>();
  final WriteCharacteristicUseCase _write =
      injector.get<WriteCharacteristicUseCase>();


  setDevice(BluetoothDevice device, BluetoothCharacteristic? readChar,
      BluetoothCharacteristic? writeChar) async {
    state = BtDeviceState(
        device: device,
        readCharacteristic: readChar,
        writeCharacteristic: writeChar);
  }

  Future<void> read() async {
    if (state.readCharacteristic == null) {
      print("❌ Read characteristic is null, cannot read.");
      return;
    }

    try {
      await state.readCharacteristic!.setNotifyValue(true);
      state.readCharacteristic!.onValueReceived.listen((List<int> value) {
        print("📥 Received Data: $value");
      });
    } catch (e) {
      print("❌ Error setting up notifications: $e");
    }
  }

  Future<void> write(List<int> value) async {
    if (state.writeCharacteristic == null) {
      print("❌ Write characteristic is null, cannot send data.");
      return;
    }

    try {
      await state.writeCharacteristic!.write(value, withoutResponse: true);
      print("✅ Sent Data: $value");
    } catch (e) {
      print("❌ Error writing data: $e");
    }
  }

  Future<String> connect(BluetoothDevice device) async {
    if (!mounted) return 'false'; // Prevent action if disposed

    final result = await _connect.execute(device);

    if (mounted && state.device != null && result == 'true') {
      await disConnect();
    }

    return result;
  }

  Future<String> disConnect() async {
    if (!mounted) return 'false';
    final result = await _disConnect.execute(state.device!);
    state.device?.disconnect();
    if (mounted) {
      reset();
    }

    return result;
  }

  void reset() {
    state = BtDeviceState();
  }

}
