class AdfSettingsState {
  final String? id;
  final String deviceId;
  final String? deviceName;
  final String? workingType;
  final String? configType;
  final bool isSelected;
  final Map<String, dynamic> values;

  AdfSettingsState(
      {this.deviceId = '0',
      this.id,
      this.isSelected = false,
      this.deviceName,
      this.workingType,
      this.configType,
      this.values = const {}});

  AdfSettingsState copyWith(
      {String? id,
      String? workingType,
      String? deviceId,
      bool? isSelected,
      String? deviceName,
      String? configType,
      Map<String, dynamic>? values}) {
    return AdfSettingsState(
        id: id ?? this.id,
        deviceId: deviceId ?? this.deviceId,
        workingType: workingType ?? this.workingType,
        configType: configType ?? this.configType,
        values: values ?? this.values,
        isSelected: isSelected ?? this.isSelected,
        deviceName: deviceName ?? this.deviceName);
  }
}
