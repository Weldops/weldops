import 'package:esab/features/add_device/presentation/screens/provider/state/add_device_notifier.dart';
import 'package:esab/features/add_device/presentation/screens/provider/state/add_device_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final addDeviceStateNotifierProvider =
    AutoDisposeStateNotifierProvider<AddDeviceNotifier, AddDeviceState>(
        (ref) => AddDeviceNotifier());
