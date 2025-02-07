import 'package:esab/di/injector.dart';
import 'package:esab/features/onboard/domain/use_cases/onboard_use_case.dart';
import 'package:esab/features/onboard/presentation/providers/state/onboard_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OnboardNotifier extends StateNotifier<OnboardState> {
  final OnboardUseCase _onboardUseCase = injector.get<OnboardUseCase>();

  OnboardNotifier() : super(OnboardState.initial()) {
    _checkOnboardingStatus();
  }

  Future<void> _checkOnboardingStatus() async {
    final result = await _onboardUseCase.getOnboardingStatus();
    result.fold(
      (failure) {},
      (status) {
        state = state.copyWith(isFirst: status);
      },
    );
  }

  Future<void> completeOnboarding() async {
    final result = await _onboardUseCase.completeOnboarding();
    result.fold(
      (failure) {},
      (_) {
        state = state.copyWith(isFirst: false);
      },
    );
  }
}
