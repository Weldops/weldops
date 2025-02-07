import 'dart:convert';

import 'package:esab/db_service.dart';
import 'package:sqflite/sqflite.dart';
import 'adf_settings_local_datasource.dart';

class AdfSettingsLocalDataSourceImpl implements AdfSettingsLocalDataSource {
  static const _adfSettingsTableName = 'adf_settings';

  @override
  Future<bool> saveAdfSettings(
      String deviceId, Map<String, dynamic> adfSettings) async {
    try {
      final db = await DbService.instance.database;
      await db.insert(
        _adfSettingsTableName,
        {
          'id': adfSettings['id'],
          'deviceId': deviceId,
          'workingType': adfSettings['workingType'],
          'configType': adfSettings['configType'],
          'deviceName': adfSettings['deviceName'],
          'isSelected': adfSettings['isSelected'],
          'values': jsonEncode(adfSettings['values']),
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> deleteAdfSettingsById(String id) async {
    try {
      final db = await DbService.instance.database;
      final rowsDeleted = await db.delete(
        _adfSettingsTableName,
        where: 'id = ?',
        whereArgs: [id],
      );
      return rowsDeleted > 0;
    } catch (e) {
      print('Error deleting ADF settings by ID: $e');
      return false;
    }
  }

  @override
  Future<bool> updateAdfSettingsById(
      String id, Map<String, dynamic> updatedValues, bool isApply) async {
    try {
      final db = await DbService.instance.database;

      if (isApply) {
        await db.update(
          _adfSettingsTableName,
          {'isSelected': 0},
          where: 'deviceId = ?',
          whereArgs: [updatedValues['deviceId']],
        );
      }

      final rowsUpdated = await db.update(
        _adfSettingsTableName,
        updatedValues,
        where: 'id = ?',
        whereArgs: [id],
      );

      return rowsUpdated > 0;
    } catch (e) {
      print('Error updating ADF settings by ID: $e');
      return false;
    }
  }

  @override
  Future<List<Map<String, dynamic>>?> getAdfSettingsByDeviceId(
      String deviceId) async {
    final db = await DbService.instance.database;
    final result = await db.query(
      _adfSettingsTableName,
      where: 'deviceId = ?',
      whereArgs: [deviceId],
    );
    if (result.isNotEmpty) {
      return result;
    }
    return null;
  }
}
