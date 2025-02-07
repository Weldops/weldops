class HomeState {
  final List<Map<String, dynamic>> devicesList;
  final bool isGridView;
  final int selectedNavigationIndex;

  HomeState({
    this.devicesList = const [],
    this.isGridView = true, // Default to grid view
    this.selectedNavigationIndex = 0,
  });

  HomeState copyWith({
    List<Map<String, dynamic>>? devicesList,
    bool? isGridView,
    int? selectedNavigationIndex,
  }) {
    return HomeState(
      devicesList: devicesList ?? this.devicesList,
      isGridView: isGridView ?? this.isGridView,
      selectedNavigationIndex:
          selectedNavigationIndex ?? this.selectedNavigationIndex,
    );
  }
}
