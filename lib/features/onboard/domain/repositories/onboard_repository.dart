import 'package:dartz/dartz.dart';
import 'package:esab/shared/util/app_exception.dart';

abstract class OnboardRepository {
  Future<Either<AppException, bool>> getOnboardingStatus();
  Future<Either<AppException, void>> setOnboardingStatus(bool isCompleted);
}
