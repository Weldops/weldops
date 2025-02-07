import 'package:dartz/dartz.dart';
import 'package:esab/features/home/data/datasource/home_local_datasource.dart';
import 'package:esab/features/home/data/datasource/home_remote_datasource.dart';
import 'package:esab/features/home/domain/repositories/home_repository.dart';
import 'package:esab/models/bluetooth_device.dart';
import 'package:esab/shared/util/app_exception.dart';

class HomeRepositoryImpl extends HomeRepository {
  final HomeRemoteDataSource homeRemoteDataSource;
  final HomeLocalDataSource homeLocalDataSource;

  HomeRepositoryImpl(
      {required this.homeRemoteDataSource, required this.homeLocalDataSource});

  @override
  Future<Either<AppException, bool>> logout() async {
    try {
      final success = await homeRemoteDataSource.logout();

      if (!success) {
        return Left(AppException(
          'Failed to log out',
          message: 'Unable to log out. Please try again later.',
          statusCode: 400,
        ));
      }

      return Right(success);
    } catch (e) {
      return Left(AppException(
        'Logout failed: $e',
        message: e.toString(),
        statusCode: 500,
      ));
    }
  }

  @override
  Future<Either<AppException, bool>> addDevice(Device device) async {
    try {
      final result = await homeLocalDataSource.addDevice(device);

      if (result) {
        return Left(AppException(
          'Failed to add device',
          message: 'Failed to add device',
          statusCode: 0,
        ));
      }
      return Right(result);
    } catch (e) {
      return Left(AppException('Failed to add device: $e',
          message: e.toString(), statusCode: 0));
    }
  }

  @override
  Future<Either<AppException, bool>> updateDeviceName(
      String deviceId, String newDeviceName) async {
    try {
      final result =
          await homeLocalDataSource.updateDeviceName(deviceId, newDeviceName);

      if (result) {
        return Left(AppException(
          'Failed to update name',
          message: 'Failed to update name',
          statusCode: 0,
        ));
      }
      return Right(result);
    } catch (e) {
      return Left(AppException('Failed to update name: $e',
          message: e.toString(), statusCode: 0));
    }
  }

  @override
  Future<Either<AppException, List<Map<String, dynamic>>>> getDevices() async {
    try {
      final result = await homeLocalDataSource.getDevices();

      if (result == null) {
        return Left(AppException(
          'Failed to get device',
          message: 'Failed to get device',
          statusCode: 0,
        ));
      }
      return Right(result);
    } catch (e) {
      return Left(AppException('Failed to get device: $e',
          message: e.toString(), statusCode: 0));
    }
  }

  @override
  Future<Either<AppException, bool>> removeDevice(String deviceId) async {
    try {
      final result = await homeLocalDataSource.removeDevice(deviceId);

      if (result) {
        return Left(AppException(
          'Failed to delete device',
          message: 'Failed to delete device',
          statusCode: 0,
        ));
      }
      return Right(result);
    } catch (e) {
      return Left(AppException('Failed to delete device: $e',
          message: e.toString(), statusCode: 0));
    }
  }
}
