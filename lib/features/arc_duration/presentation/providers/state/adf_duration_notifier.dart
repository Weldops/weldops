import 'package:esab/features/arc_duration/presentation/providers/state/adf_duration_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AdfDurationNotifier extends StateNotifier<AdfDurationState> {
  AdfDurationNotifier() : super(AdfDurationState());

  void setTouchBarIndex(int touchedBarIndex) {
    state = state.copyWith(touchedBarIndex: touchedBarIndex);
  }

  int? get touchedBarIndex => state.touchedBarIndex;
}
