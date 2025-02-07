class LogoutState {
  final bool isLoading;
  final bool isLoggedOut;
  final String? errorMessage;

  const LogoutState({
    this.isLoading = false,
    this.isLoggedOut = false,
    this.errorMessage,
  });

  LogoutState copyWith({
    bool? isLoading,
    bool? isLoggedOut,
    String? errorMessage,
  }) {
    return LogoutState(
      isLoading: isLoading ?? this.isLoading,
      isLoggedOut: isLoggedOut ?? this.isLoggedOut,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  factory LogoutState.initial() {
    return const LogoutState();
  }
}
