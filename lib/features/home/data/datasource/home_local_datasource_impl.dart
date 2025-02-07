import 'package:esab/db_service.dart';
import 'package:esab/models/bluetooth_device.dart';
import 'package:sqflite/sqflite.dart';
import 'home_local_datasource.dart';

class HomeLocalDataSourceImpl implements HomeLocalDataSource {
  static const _tableName = 'devices';

  @override
  Future<bool> addDevice(Device device) async {
    try {
      final db = await DbService.instance.database;

      await db.insert(
        _tableName,
        device.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      return true;
    } catch (e) {
      print('Error adding device: $e');
      return false;
    }
  }

  @override
  Future<bool> updateDeviceName(String deviceId, String newDeviceName) async {
    try {
      final db = await DbService.instance.database;

      // Perform the update
      int count = await db.update(
        _tableName,
        {'deviceName': newDeviceName},
        where: 'deviceId = ?',
        whereArgs: [deviceId],
      );

      // Check if any rows were updated
      return count > 0;
    } catch (e) {
      print('Error updating device name: $e');
      return false;
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getDevices() async {
    final db = await DbService.instance.database;
    return db.query(_tableName);
  }

  @override
  Future<bool> removeDevice(String deviceId) async {
    final db = await DbService.instance.database;
    final batch = db.batch();

    try {
      batch.delete(
        'adf_settings',
        where: 'deviceId = ?',
        whereArgs: [deviceId],
      );

      batch.delete(
        _tableName,
        where: 'deviceId = ?',
        whereArgs: [deviceId],
      );

      await batch.commit();
      return true;
    } catch (e) {
      print('Error removing device and related settings: $e');
      return false;
    }
  }
}
