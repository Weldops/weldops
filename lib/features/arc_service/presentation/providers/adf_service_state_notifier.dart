import 'package:esab/features/arc_service/presentation/providers/state/adf_service_notifier.dart';
import 'package:esab/features/arc_service/presentation/providers/state/adf_service_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final adfServiceStateNotifierProvider =
    AutoDisposeStateNotifierProvider<AdfServiceNotifier, AdfServiceState>(
        (ref) => AdfServiceNotifier());
