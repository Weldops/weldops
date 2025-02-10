import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasource/lens_db.dart';
import '../../data/model/lens.dart';


final replacementLogProvider = StateNotifierProvider.family<ReplacementLogNotifier, AsyncValue<List<LensRecord>>, int>(
      (ref, id) {
    return ReplacementLogNotifier(id: id);
  },
);


class ReplacementLogNotifier extends StateNotifier<AsyncValue<List<LensRecord>>> {
  final int id;

  ReplacementLogNotifier({ required this.id})
      : super(const AsyncValue.loading()) {
    fetchLogs(id: id);
  }

  Future<void> fetchLogs({required int id}) async {
    try {
      final logs = await fetchRecordsById(id);
      state = AsyncValue.data(logs);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> addLogEntry(LensRecord record) async {
    try {
      await addLog(record);
      fetchLogs(id: record.id!);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
}
