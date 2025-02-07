import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/datasource/lens_db.dart';
import '../data/model/lens.dart';

final lensRecordsProvider = FutureProvider<List<LensRecord>>((ref) async {
  return await getAllLogs();
});

final replacementLogsProvider = FutureProvider.family<List<LensRecord>, int>((ref, id) async {
  return await fetchRecordsById(id);
});

