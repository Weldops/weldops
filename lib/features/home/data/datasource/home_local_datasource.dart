import 'package:esab/models/bluetooth_device.dart';

abstract class HomeLocalDataSource {
  Future<bool> addDevice(Device device);
  Future<List<Map<String, dynamic>>> getDevices();
  Future<bool> removeDevice(String deviceId);
  Future<bool> updateDeviceName(String deviceId, String newDeviceName);
}
