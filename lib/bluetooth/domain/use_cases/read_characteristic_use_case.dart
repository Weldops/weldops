import 'package:flutter_blue_plus/flutter_blue_plus.dart';

import '../repositories/bluetooth_repository.dart';

class ReadCharacteristicUseCase {
  final BluetoothRepository bluetoothRepository;

  ReadCharacteristicUseCase({required this.bluetoothRepository});

  Future<Object> execute(BluetoothCharacteristic? characteristic) {
    return bluetoothRepository.readCharacteristic(characteristic);
  }
}
