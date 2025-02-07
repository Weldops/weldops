abstract class OnboardLocalDataSource {
  Future<bool> getOnboardingStatus();
  Future<void> setOnboardingStatus(bool isFirst);
}
