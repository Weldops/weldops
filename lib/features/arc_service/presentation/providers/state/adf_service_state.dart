class AdfServiceState {
  final int? touchedBarIndex;

  AdfServiceState({this.touchedBarIndex});

  AdfServiceState copyWith({int? touchedBarIndex}) {
    return AdfServiceState(
      touchedBarIndex: touchedBarIndex ?? this.touchedBarIndex,
    );
  }
}
