import 'package:flutter/services.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

import '../../domain/repositories/bluetooth_repository.dart';

class BluetoothRepositoryImpl implements BluetoothRepository {
  BluetoothRepositoryImpl();

  @override
  Future<String> connectToDevice(BluetoothDevice device) async {
    try {
      await device.connect();
      return 'true';
    } catch (e) {
      if (e is FlutterBluePlusException) {
        return e.description!;
      } else if (e is PlatformException) {
        return e.message!;
      }
      return e.toString();
    }
  }

  @override
  Future<String> disconnectDevice(BluetoothDevice device) async {
    try {
      await device.connect();
      return 'true';
    } catch (e) {
      if (e is FlutterBluePlusException) {
        return e.description!;
      } else if (e is PlatformException) {
        return e.message!;
      }
      return e.toString();
    }
  }

  @override
  Future<Object> readCharacteristic(
      BluetoothCharacteristic? characteristic) async {
    try {
      final result = await characteristic?.read();
      return result!;
    } catch (e) {
      if (e is FlutterBluePlusException) {
        return e.description!;
      } else if (e is PlatformException) {
        return e.message!;
      }
      return e.toString();
    }
  }

  @override
  Future<String> writeCharacteristic(
      BluetoothCharacteristic? characteristic, List<int> value) async {
    try {
      await characteristic?.write(value);
      return 'true';
    } catch (e) {
      if (e is FlutterBluePlusException) {
        return e.description!;
      } else if (e is PlatformException) {
        return e.message!;
      }
      return e.toString();
    }
  }

  Future<BluetoothDevice?> _findDeviceById(String id) async {
    //return (await FlutterBluePlus.connectedDevices).firstWhereOrNull((d) => d.id.toString() == id);
    return null;
  }

  Future<BluetoothCharacteristic?> _findCharacteristic(
      BluetoothDevice device, String id) async {
    final services = await device.discoverServices();
    for (var service in services) {
      for (var characteristic in service.characteristics) {
        if (characteristic.uuid.toString() == id) {
          return characteristic;
        }
      }
    }
    return null;
  }
}
