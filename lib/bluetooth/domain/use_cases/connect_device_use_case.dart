import 'package:flutter_blue_plus/flutter_blue_plus.dart';

import '../repositories/bluetooth_repository.dart';

class ConnectDeviceUseCase {
  final BluetoothRepository bluetoothRepository;

  ConnectDeviceUseCase({required this.bluetoothRepository});

  Future<String> execute(BluetoothDevice device) {
    return bluetoothRepository.connectToDevice(device);
  }
}
