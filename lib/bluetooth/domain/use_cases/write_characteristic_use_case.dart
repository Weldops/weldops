import 'package:flutter_blue_plus/flutter_blue_plus.dart';

import '../repositories/bluetooth_repository.dart';

class WriteCharacteristicUseCase {
  final BluetoothRepository bluetoothRepository;

  WriteCharacteristicUseCase({required this.bluetoothRepository});

  Future<String> execute(
      BluetoothCharacteristic? characteristicId, List<int> value) {
    return bluetoothRepository.writeCharacteristic(characteristicId, value);
  }
}
