import 'package:esab/bluetooth/domain/use_cases/connect_device_use_case.dart';
import 'package:esab/bluetooth/domain/use_cases/disconnect_device_use_case.dart';
import 'package:esab/bluetooth/domain/use_cases/read_characteristic_use_case.dart';
import 'package:esab/bluetooth/domain/use_cases/write_characteristic_use_case.dart';
import 'package:esab/bluetooth/presentation/provider/state/bluetooth_device_state.dart';
import 'package:esab/di/injector.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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

  read(bool isWrite) async {
    if (!isWrite) {
      await _write.execute(state.writeCharacteristic, [0, 0]);
    }
    final result = await _read.execute(state.readCharacteristic);
    return result;
  }

  write(List<int> value) async {
    final result = await _write.execute(state.writeCharacteristic, value);

    return result;
  }

  // connect(BluetoothDevice device) async {
  //   final result = await _connect.execute(device);
  //   if (
  //   state.device != null && result == 'true') {
  //     await disConnect();
  //   }
  //   return result;
  // }
  //
  // disConnect() async {
  //   final result = await _disConnect.execute(state.device!);
  //   reset();
  //   return result;
  // }

  Future<String> connect(BluetoothDevice device) async {
    if (!mounted) return 'false'; // Prevent action if disposed

    final result = await _connect.execute(device);

    if (mounted && state.device != null && result == 'true') {
      await disConnect();
    }

    return result;
  }

  Future<String> disConnect() async {
    if (!mounted) return 'false'; // Prevent action if disposed

    final result = await _disConnect.execute(state.device!);
    if (mounted) reset();

    return result;
  }


  reset() {
    state = BtDeviceState();
  }
}
