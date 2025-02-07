class AddDeviceState {
  final bool isInitial;
  final bool isConnecting;
  final bool isConnectionSuccess;
  final bool isConnectionFailure;
  final String? selectedDeviceId;
  final String nicknameError;

  AddDeviceState(
      {this.isInitial = true,
      this.isConnecting = false,
      this.isConnectionSuccess = false,
      this.isConnectionFailure = false,
      this.selectedDeviceId,
      this.nicknameError = ''});

  AddDeviceState copyWith(
      {bool? isInitial,
      bool? isConnecting,
      bool? isConnectionSuccess,
      bool? isConnectionFailure,
      String? selectedDeviceId,
      String? nicknameError}) {
    return AddDeviceState(
        isInitial: isInitial ?? this.isInitial,
        isConnecting: isConnecting ?? this.isConnecting,
        isConnectionSuccess: isConnectionSuccess ?? this.isConnectionSuccess,
        isConnectionFailure: isConnectionFailure ?? this.isConnectionFailure,
        selectedDeviceId: selectedDeviceId ?? this.selectedDeviceId,
        nicknameError: nicknameError ?? this.nicknameError);
  }
}
