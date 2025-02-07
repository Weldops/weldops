import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:esab/features/adf_settings/domain/repositories/adf_settings_repository.dart';
import 'package:esab/features/adf_settings/presentation/screens/provider/state/adf_settings_state.dart';
import 'package:esab/features/adf_settings/data/datasource/adf_settings_local_datasource.dart';
import 'package:esab/shared/util/app_exception.dart';

class AdfSettingsRepositoryImpl implements AdfSettingsRepository {
  final AdfSettingsLocalDataSource localDataSource;

  AdfSettingsRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<AppException, bool>> saveAdfSettings(
      String deviceId, AdfSettingsState adfSettings) async {
    try {
      final result = await localDataSource.saveAdfSettings(deviceId, {
        'id': DateTime.now().toIso8601String(),
        'deviceId': deviceId,
        'workingType': adfSettings.workingType,
        'configType': adfSettings.configType,
        'deviceName': adfSettings.deviceName,
        'values': adfSettings.values,
        'isSelected': 0,
      });

      if (result) {
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
  Future<Either<AppException, bool>> deleteAdfSettingsById(String id) async {
    try {
      final result = await localDataSource.deleteAdfSettingsById(id);

      if (result) {
        return Left(AppException(
          'Failed to delete memory',
          message: 'Failed to delete memory',
          statusCode: 0,
        ));
      }
      return Right(result);
    } catch (e) {
      return Left(AppException('Failed to delete memory: $e',
          message: e.toString(), statusCode: 0));
    }
  }

  @override
  Future<Either<AppException, bool>> updateAdfSettingsById(
      String id, Map<String, dynamic> updatedValues, bool isApply) async {
    try {
      final result = await localDataSource.updateAdfSettingsById(
          id, updatedValues, isApply);

      if (result) {
        return Left(AppException(
          'Failed to update memory',
          message: 'Failed to update memory',
          statusCode: 0,
        ));
      }
      return Right(result);
    } catch (e) {
      return Left(AppException('Failed to update memory: $e',
          message: e.toString(), statusCode: 0));
    }
  }

  @override
  Future<Either<AppException, List<AdfSettingsState>>> getAdfSettingsByDeviceId(
      String deviceId) async {
    List<AdfSettingsState> list = [];
    try {
      final result = await localDataSource.getAdfSettingsByDeviceId(deviceId);

      if (result == null) {
        return Left(AppException(
          'Failed to get device',
          message: 'Failed to get device',
          statusCode: 0,
        ));
      }
      for (Map<String, dynamic> x in result) {
        list.add(AdfSettingsState(
            id: x["id"],
            deviceId: x['deviceId'],
            workingType: x['workingType'],
            configType: x['configType'],
            deviceName: x['deviceName'],
            isSelected: x['isSelected'] == 0 ? false : true,
            values: jsonDecode(x['values'])));
      }
      return Right(list);
    } catch (e) {
      return Left(AppException('Failed to get device: $e',
          message: e.toString(), statusCode: 0));
    }
  }
}
