import 'package:dartz/dartz.dart';
import 'package:esab/features/onboard/data/datasource/onboard_local_datasource.dart';
import 'package:esab/shared/util/app_exception.dart';

class OnboardUseCase {
  final OnboardLocalDataSource onboardLocalDataSource;

  OnboardUseCase({required this.onboardLocalDataSource});

  Future<Either<AppException, bool>> getOnboardingStatus() async {
    try {
      final status = await onboardLocalDataSource.getOnboardingStatus();
      return Right(status);
    } catch (e) {
      return Left(AppException('Failed to fetch onboarding status: $e',
          message: '', statusCode: 500));
    }
  }

  Future<Either<AppException, void>> completeOnboarding() async {
    try {
      await onboardLocalDataSource.setOnboardingStatus(false);
      return const Right(null);
    } catch (e) {
      return Left(AppException('Failed to complete onboarding: $e',
          message: '', statusCode: 500));
    }
  }
}
