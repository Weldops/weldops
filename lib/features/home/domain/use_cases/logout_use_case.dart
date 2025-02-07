import 'package:dartz/dartz.dart';
import 'package:esab/features/home/domain/repositories/home_repository.dart';
import 'package:esab/shared/util/app_exception.dart';

class LogoutUseCase {
  HomeRepository homeRepository;

  LogoutUseCase({required this.homeRepository});

  Future<Either<AppException, void>> execute() async {
    try {
      await homeRepository.logout();
      return const Right(null);
    } catch (e) {
      return Left(AppException(
        'Logout failed: ${e.toString()}',
        message: e.toString(),
        statusCode: 500,
      ));
    }
  }
}
