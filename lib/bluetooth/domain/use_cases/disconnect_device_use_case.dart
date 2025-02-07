import 'package:flutter_blue_plus/flutter_blue_plus.dart';

import '../repositories/bluetooth_repository.dart';

class DisconnectDeviceUseCase {
  final BluetoothRepository bluetoothRepository;

  DisconnectDeviceUseCase({required this.bluetoothRepository});

  Future<String> execute(BluetoothDevice device) {
    return bluetoothRepository.disconnectDevice(device);
  }
}
