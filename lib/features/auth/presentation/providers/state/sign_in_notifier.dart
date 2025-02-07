import 'package:esab/di/injector.dart';
import 'package:esab/features/auth/domain/use_cases/sign_in_use_case.dart';
import 'package:esab/features/auth/presentation/providers/state/sign_in_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SignInNotifier extends StateNotifier<SignInState> {
  final SignInUseCase _signInUseCase = injector.get<SignInUseCase>();

  SignInNotifier() : super(const SignInState.initial());

  Future<void> signIn({required String email, required String password}) async {
    print("Starting signIn...");

    if (!mounted) {
      return;
    }

    state = state.copyWith(isLoading: true);

    try {
      final result =
          await _signInUseCase.execute(email: email, password: password);

      print("RESULT CONSOLE $result");

      result.fold(
        (failure) {
          print("SignIn failed with message: ${failure.message}");
          state = state.copyWith(
            isLoading: false,
            errorMessage: failure.message,
          );
        },
        (success) {
          if (mounted) {
            state = state.copyWith(
                isLoading: false,
                isSignedIn: true,
                errorMessage: null,
                user: success);
            print("SignIn succeeded.");
          }
        },
      );
    } catch (e) {
      print("Error during signIn execution: $e");
      if (mounted) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: 'An error occurred during sign in.',
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
      state = const SignInState.initial();
    }
  }
}
