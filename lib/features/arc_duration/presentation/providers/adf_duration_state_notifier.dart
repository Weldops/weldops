import 'package:esab/features/arc_duration/presentation/providers/state/adf_duration_notifier.dart';
import 'package:esab/features/arc_duration/presentation/providers/state/adf_duration_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final adfDurationStateNotifierProvider =
    AutoDisposeStateNotifierProvider<AdfDurationNotifier, AdfDurationState>(
        (ref) => AdfDurationNotifier());
