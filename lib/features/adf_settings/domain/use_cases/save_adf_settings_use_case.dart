import 'package:dartz/dartz.dart';
import 'package:esab/features/adf_settings/domain/repositories/adf_settings_repository.dart';
import 'package:esab/features/adf_settings/presentation/screens/provider/state/adf_settings_state.dart';
import 'package:esab/shared/util/app_exception.dart';

class SaveAdfSettingUseCase {
  final AdfSettingsRepository homeRepository;

  SaveAdfSettingUseCase({required this.homeRepository});

  Future<Either<AppException, bool>> execute(
      String deviceId, AdfSettingsState adfSettings) {
    return homeRepository.saveAdfSettings(deviceId, adfSettings);
  }
}
