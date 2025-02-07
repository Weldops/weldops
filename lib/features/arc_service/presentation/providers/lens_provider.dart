import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:esab/db_service.dart';
import '../data/model/lens.dart';

// final replacementLogsProvider = FutureProvider.family<List<LensRecord>, int>((ref, id) async {
//   return await DbService.instance.fetchRecordsById(id);
// });


class ReplacementLogsNotifier extends StateNotifier<List<LensRecord>> {
  final int id;

  ReplacementLogsNotifier(this.id) : super([]) {
    fetchLogs();
  }

  Future<void> fetchLogs() async {
    final logs = await DbService.instance.fetchRecordsById(id);
    state = logs; // ✅ Updates state automatically
  }

  Future<void> addLog(LensRecord log) async {
    await DbService.instance.addLog(log);
    fetchLogs(); // ✅ Re-fetch logs after adding a new log
  }
}

final replacementLogsProvider = StateNotifierProvider.family<
    ReplacementLogsNotifier, List<LensRecord>, int>((ref, id) {
  return ReplacementLogsNotifier(id);
});
