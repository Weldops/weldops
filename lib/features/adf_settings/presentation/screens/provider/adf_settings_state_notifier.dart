import 'package:esab/bluetooth/presentation/provider/bluetooth_device_state_notifier.dart';
import 'package:esab/features/adf_settings/presentation/screens/provider/state/adf_settings_notifier.dart';
import 'package:esab/features/adf_settings/presentation/screens/provider/state/adf_settings_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final adfSettingStateNotifierProvider =
    AutoDisposeStateNotifierProvider<AdfSettingsNotifier, AdfSettingsState>(
        (ref) =>
            AdfSettingsNotifier(ref.watch(bluetoothNotifierProvider.notifier)));
