import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/datasource/lens_db.dart';
import '../data/model/lens.dart';

class LensRecordsNotifier extends StateNotifier<AsyncValue<List<LensRecord>>> {
  LensRecordsNotifier() : super(const AsyncValue.loading()) {
    _fetchRecords();
  }

  Future<void> _fetchRecords() async {
    try {
      final records = await getAllLogs();
      state = AsyncValue.data(records);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> updateLensRecord(LensRecord updatedRecord) async {
    try {
      await updateRecord(updatedRecord); // Save the updated record
      _fetchRecords(); // Refresh the list after update
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}

final lensRecordsProvider =
StateNotifierProvider<LensRecordsNotifier, AsyncValue<List<LensRecord>>>(
        (ref) => LensRecordsNotifier());
