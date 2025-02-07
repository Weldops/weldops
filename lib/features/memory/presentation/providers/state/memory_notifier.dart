import 'package:esab/di/injector.dart';
import 'package:esab/features/adf_settings/domain/use_cases/get_adf_settings_use_case.dart';
import 'package:esab/features/adf_settings/presentation/screens/provider/state/adf_settings_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MemorySettingsNotifier extends StateNotifier<List<AdfSettingsState>> {
  final GetAdfSettingUseCase _getUseCase = injector.get<GetAdfSettingUseCase>();
  MemorySettingsNotifier() : super([]);

  Future<void> getMemorySettings(String deviceId) async {
    final result = await _getUseCase.execute(deviceId);
    result.fold(
      (exception) {
        print('Error: $exception');
        state = [];
      },
      (settings) {
        state = settings;
      },
    );
  }
}
