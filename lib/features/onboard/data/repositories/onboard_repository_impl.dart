import 'package:dartz/dartz.dart';
import 'package:esab/features/onboard/data/datasource/onboard_local_datasource.dart';
import 'package:esab/features/onboard/domain/repositories/onboard_repository.dart';
import 'package:esab/shared/util/app_exception.dart';

class OnboardRepositoryImpl extends OnboardRepository {
  final OnboardLocalDataSource onboardLocalDataSource;

  OnboardRepositoryImpl({required this.onboardLocalDataSource});

  @override
  Future<Either<AppException, bool>> getOnboardingStatus() async {
    try {
      final status = await onboardLocalDataSource.getOnboardingStatus();
      return Right(status);
    } catch (e) {
      return Left(AppException(
        'Failed to fetch onboarding status: $e',
        message: e.toString(),
        statusCode: 500,
      ));
    }
  }

  @override
  Future<Either<AppException, void>> setOnboardingStatus(
      bool isCompleted) async {
    try {
      await onboardLocalDataSource.setOnboardingStatus(isCompleted);
      return const Right(null);
    } catch (e) {
      return Left(AppException(
        'Failed to set onboarding status: $e',
        message: e.toString(),
        statusCode: 500,
      ));
    }
  }
}
