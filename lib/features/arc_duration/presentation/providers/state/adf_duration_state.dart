class AdfDurationState {
  final int? touchedBarIndex;

  AdfDurationState({this.touchedBarIndex});

  AdfDurationState copyWith({int? touchedBarIndex}) {
    return AdfDurationState(
      touchedBarIndex: touchedBarIndex ?? this.touchedBarIndex,
    );
  }
}
