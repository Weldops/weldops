import 'package:esab/features/arc_service/presentation/providers/state/adf_service_notifier.dart';
import 'package:esab/features/arc_service/presentation/providers/state/adf_service_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../db_service.dart';
import '../data/model/lens.dart';

final adfServiceStateNotifierProvider =
    AutoDisposeStateNotifierProvider<AdfServiceNotifier, AdfServiceState>(
        (ref) => AdfServiceNotifier());

final lensRecordsProvider = FutureProvider<List<LensRecord>>((ref) async {
    return await DbService.instance.getAllLogs();
});

// final replacementLogsProvider = FutureProvider.family<List<LensRecord>, int>((ref, id) async {
//     return await DbService.instance.fetchRecordsById(id);
// });