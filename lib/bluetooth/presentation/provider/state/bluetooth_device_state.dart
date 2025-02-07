import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class BtDeviceState {
  final BluetoothCharacteristic? readCharacteristic;
  final BluetoothCharacteristic? writeCharacteristic;
  final BluetoothDevice? device;

  BtDeviceState({
    this.readCharacteristic,
    this.writeCharacteristic,
    this.device,
  });
}
