import 'package:dartz/dartz.dart';
import 'package:esab/features/adf_settings/domain/repositories/adf_settings_repository.dart';
import 'package:esab/shared/util/app_exception.dart';

class UpdateAdfMemoryUseCase {
  final AdfSettingsRepository homeRepository;

  UpdateAdfMemoryUseCase({required this.homeRepository});

  Future<Either<AppException, bool>> execute(
      String id, Map<String, dynamic> updatedValues, bool isApply) {
    return homeRepository.updateAdfSettingsById(id, updatedValues, isApply);
  }
}
