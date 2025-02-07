import 'package:esab/di/injector.dart';
import 'package:esab/features/home/domain/use_cases/logout_use_case.dart';
import 'package:esab/features/home/presentation/providers/state/logout_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LogoutNotifier extends StateNotifier<LogoutState> {
  final LogoutUseCase _logoutUseCase = injector.get<LogoutUseCase>();

  LogoutNotifier() : super(LogoutState.initial());

  Future<void> logout() async {
    print("Starting logout...");

    if (!mounted) {
      return;
    }

    state = state.copyWith(isLoading: true);

    try {
      final result = await _logoutUseCase.execute();

      print("Logout RESULT: $result");

      result.fold(
        (failure) {
          print("Logout failed with message: ${failure.message}");
          state = state.copyWith(
            isLoading: false,
            errorMessage: failure.message,
          );
        },
        (_) {
          if (mounted) {
            state = state.copyWith(
              isLoading: false,
              isLoggedOut: true,
              errorMessage: null,
            );
            print("Logout succeeded.");
          }
        },
      );
    } catch (e) {
      print("Error during logout execution: $e");
      if (mounted) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: 'An error occurred during logout.',
        );
      }
    }
  }

  void clearErrorMessage() {
    if (mounted) {
      state = state.copyWith(errorMessage: '');
    }
  }

  void clearState() {
    if (mounted) {
      state = LogoutState.initial();
    }
  }
}
