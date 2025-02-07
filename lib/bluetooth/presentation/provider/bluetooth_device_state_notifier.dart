import 'package:esab/bluetooth/presentation/provider/state/bluetooth_device_notifier.dart';
import 'package:esab/bluetooth/presentation/provider/state/bluetooth_device_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final bluetoothNotifierProvider =
    AutoDisposeStateNotifierProvider<BluetoothDeviceNotifier, BtDeviceState>(
        (ref) => BluetoothDeviceNotifier());
