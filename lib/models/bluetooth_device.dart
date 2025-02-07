class Device {
  String deviceId;
  String deviceModel;
  String deviceName;
  String displayName;
  String macAddress;
  String imageUrl;
  DateTime createdAt;
  dynamic data;

  Device({
    required this.deviceId,
    required this.deviceModel,
    required this.deviceName,
    required this.displayName,
    required this.macAddress,
    required this.imageUrl,
    required this.createdAt,
    required this.data,
  });

  factory Device.fromJson(Map<String, dynamic> json) {
    return Device(
      deviceId: json['deviceId'],
      deviceModel: json['deviceModel'],
      deviceName: json['deviceName'],
      displayName: json['displayName'],
      macAddress: json['macAddress'],
      imageUrl: json['imageUrl'],
      createdAt: DateTime.parse(json['createdAt']),
      data: json['data'], // data is dynamic, could be a Map or any type
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'deviceId': deviceId,
      'deviceModel': deviceModel,
      'deviceName': deviceName,
      'displayName': displayName,
      'macAddress': macAddress,
      'imageUrl': imageUrl,
      'createdAt': createdAt.toIso8601String(),
      'data': data,
    };
  }
}
