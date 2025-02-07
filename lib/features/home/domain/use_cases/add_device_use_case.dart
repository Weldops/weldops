import 'package:dartz/dartz.dart';
import 'package:esab/features/home/domain/repositories/home_repository.dart';
import 'package:esab/models/bluetooth_device.dart';
import 'package:esab/shared/util/app_exception.dart';

class AddDeviceUseCase {
  final HomeRepository homeRepository;

  AddDeviceUseCase({required this.homeRepository});

  Future<Either<AppException, bool>> execute({required Device device}) {
    return homeRepository.addDevice(device);
  }
}
