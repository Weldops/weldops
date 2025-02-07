import 'package:dartz/dartz.dart';
import 'package:esab/features/home/domain/repositories/home_repository.dart';
import 'package:esab/shared/util/app_exception.dart';

class UpdateNameUseCase {
  final HomeRepository homeRepository;

  UpdateNameUseCase({required this.homeRepository});

  Future<Either<AppException, bool>> execute(
      {required String deviceId, required String newDeviceName}) {
    return homeRepository.updateDeviceName(deviceId, newDeviceName);
  }
}
