import 'package:esab/features/onboard/presentation/providers/state/onboard_notifier.dart';
import 'package:esab/features/onboard/presentation/providers/state/onboard_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final onboardStateNotifierProvider =
    StateNotifierProvider<OnboardNotifier, OnboardState>(
        (ref) => OnboardNotifier());
