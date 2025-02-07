import 'package:esab/db_service.dart';

import '../model/lens.dart';

final dbServiceInstance = DbService.instance;
Future<int> insertRecord(LensRecord record) async {
  final db = await dbServiceInstance.database;
  return await db.insert('lens_records', record.toMap());
}

Future<List<LensRecord>> getAllLogs() async {
  final db = await dbServiceInstance.database;
  final List<Map<String, dynamic>> maps = await db.query('lens_records');
  return List.generate(maps.length, (i) => LensRecord.fromMap(maps[i]));
}


Future<int> updateRecord(LensRecord record) async {
  final db = await dbServiceInstance.database;
  return await db.update(
    'lens_records',
    record.toMap(),
    where: 'id = ?',
    whereArgs: [record.id],
  );
}

Future<List<LensRecord>> fetchRecordsById(int id) async {
  final db = await dbServiceInstance.database;
  final result = await db.query(
    'lens_replacement',
    where: 'lens_record_id = ?',
    whereArgs: [id],
    orderBy: 'lastUpdated DESC',
  );
  return result.map((map) => LensRecord.fromMap(map)).toList();
}

Future<int> addLog(LensRecord record) async {
  final db = await dbServiceInstance.database;
  final logEntry = {
    'lens_record_id': record.id,
    'title': record.title,
    'imageUrl': record.imageUrl,
    'percentage': record.percentage,
    'hours': record.hours,
    'lastUpdated': record.lastUpdated.toIso8601String(),
    'comments': record.comments,
  };
  return await db.insert('lens_replacement', logEntry);
}