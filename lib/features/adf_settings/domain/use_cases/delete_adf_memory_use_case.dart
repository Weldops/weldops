import 'package:dartz/dartz.dart';
import 'package:esab/features/adf_settings/domain/repositories/adf_settings_repository.dart';
import 'package:esab/shared/util/app_exception.dart';

class DeleteAdfMemoryUseCase {
  final AdfSettingsRepository homeRepository;

  DeleteAdfMemoryUseCase({required this.homeRepository});

  Future<Either<AppException, bool>> execute(String id) {
    return homeRepository.deleteAdfSettingsById(id);
  }
}
