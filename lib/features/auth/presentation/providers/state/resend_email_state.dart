class ResendEmailState {
  final bool isLoading;
  final bool isEmailSent;
  final String? errorMessage;

  ResendEmailState({
    this.isLoading = false,
    this.isEmailSent = false,
    this.errorMessage,
  });

  factory ResendEmailState.initial() {
    return ResendEmailState();
  }

  ResendEmailState copyWith({
    bool? isLoading,
    bool? isEmailSent,
    String? errorMessage,
  }) {
    return ResendEmailState(
      isLoading: isLoading ?? this.isLoading,
      isEmailSent: isEmailSent ?? this.isEmailSent,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
