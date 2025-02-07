import 'package:dartz/dartz.dart';
import 'package:esab/models/bluetooth_device.dart';
import 'package:esab/shared/util/app_exception.dart';

abstract class HomeRepository {
  Future<void> logout();
  Future<Either<AppException, bool>> addDevice(Device device);
  Future<Either<AppException, List<Map<String, dynamic>>>> getDevices();
  Future<Either<AppException, bool>> removeDevice(String deviceId);
  Future<Either<AppException, bool>> updateDeviceName(
      String deviceId, String newDeviceName);
}
