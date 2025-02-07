import 'package:esab/features/arc_service/presentation/providers/state/adf_service_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AdfServiceNotifier extends StateNotifier<AdfServiceState> {
  AdfServiceNotifier() : super(AdfServiceState());

  void setTouchBarIndex(int touchedBarIndex) {
    state = state.copyWith(touchedBarIndex: touchedBarIndex);
  }

  int? get touchedBarIndex => state.touchedBarIndex;
}
