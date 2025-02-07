import 'package:dartz/dartz.dart';
import 'package:esab/features/home/domain/repositories/home_repository.dart';
import 'package:esab/shared/util/app_exception.dart';

class GetDeviceUseCase {
  final HomeRepository homeRepository;

  GetDeviceUseCase({required this.homeRepository});

  Future<Either<AppException, List<Map<String, dynamic>>>> execute() {
    return homeRepository.getDevices();
  }
}
