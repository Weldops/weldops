import 'package:dartz/dartz.dart';
import 'package:esab/features/adf_settings/presentation/screens/provider/state/adf_settings_state.dart';
import 'package:esab/shared/util/app_exception.dart';

abstract class AdfSettingsRepository {
  Future<Either<AppException, bool>> saveAdfSettings(
      String deviceId, AdfSettingsState adfSettings);
  Future<Either<AppException, bool>> deleteAdfSettingsById(String id);
  Future<Either<AppException, bool>> updateAdfSettingsById(
      String id, Map<String, dynamic> updatedValues, bool isApply);
  Future<Either<AppException, List<AdfSettingsState>>> getAdfSettingsByDeviceId(
      String deviceId);
}
