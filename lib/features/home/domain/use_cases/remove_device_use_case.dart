import 'package:dartz/dartz.dart';
import 'package:esab/features/home/domain/repositories/home_repository.dart';
import 'package:esab/shared/util/app_exception.dart';

class RemoveDeviceUseCase {
  final HomeRepository homeRepository;

  RemoveDeviceUseCase({required this.homeRepository});

  Future<Either<AppException, bool>> execute({required String device}) {
    return homeRepository.removeDevice(device);
  }
}
