//
//
//
//
// // Lens tracking methods
// Future<void> initializeLensTracking(String deviceId) async {
//   final db = await database;
//   final now = DateTime.now().toIso8601String();
//
//   // Check if lens data already exists for this device
//   final existing = await db.query(
//     'lens_tracking',
//     where: 'deviceId = ?',
//     whereArgs: [deviceId],
//   );
//
//   if (existing.isEmpty) {
//     // Initialize with default values for both lenses
//     final defaultLenses = [
//       {
//         'deviceId': deviceId,
//         'lensType': 'Outer Lens Cover',
//         'percentage': 80,
//         'hours': '20',
//         'imageUrl': 'assets/images/outer_lens.png',
//         'lastUpdated': now,
//       },
//       {
//         'deviceId': deviceId,
//         'lensType': 'Inner Lens Cover',
//         'percentage': 10,
//         'hours': '180',
//         'imageUrl': 'assets/images/inner_lens.png',
//         'lastUpdated': now,
//       },
//     ];
//
//     for (var lens in defaultLenses) {
//       await db.insert('lens_tracking', lens);
//     }
//   }
// }
//
// Future<List<Map<String, dynamic>>> getLensData(String deviceId) async {
//   final db = await database;
//   return db.query(
//     'lens_tracking',
//     where: 'deviceId = ?',
//     whereArgs: [deviceId],
//   );
// }
//
// Future<void> updateLensData(
//     String deviceId,
//     String lensType,
//     int percentage,
//     String hours,
//     ) async {
//   final db = await database;
//   final now = DateTime.now().toIso8601String();
//
//   await db.update(
//     'lens_tracking',
//     {
//       'percentage': percentage,
//       'hours': hours,
//       'lastUpdated': now,
//     },
//     where: 'deviceId = ? AND lensType = ?',
//     whereArgs: [deviceId, lensType],
//   );
// }
// }