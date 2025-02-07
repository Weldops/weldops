import 'package:flutter_blue_plus/flutter_blue_plus.dart';

abstract class BluetoothRepository {
  Future<String> connectToDevice(BluetoothDevice device);
  Future<String> disconnectDevice(BluetoothDevice device);
  Future<Object> readCharacteristic(BluetoothCharacteristic? characteristicId);
  Future<String> writeCharacteristic(
      BluetoothCharacteristic? characteristicId, List<int> value);
}
