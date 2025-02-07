import 'package:esab/features/adf_settings/presentation/screens/provider/state/adf_settings_state.dart';
import 'package:esab/features/memory/presentation/providers/state/memory_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final memoryStateNotifierProvider = AutoDisposeStateNotifierProvider<
    MemorySettingsNotifier,
    List<AdfSettingsState>>((ref) => MemorySettingsNotifier());
