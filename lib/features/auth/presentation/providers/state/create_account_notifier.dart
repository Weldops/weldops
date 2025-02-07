import 'package:esab/di/injector.dart';
import 'package:esab/features/auth/domain/use_cases/create_account_use_case.dart';
import 'package:esab/features/auth/presentation/providers/state/create_account_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreateAccountNotifier extends StateNotifier<CreateAccountState> {
  final CreateAccountUseCase _createAccountUseCase =
      injector.get<CreateAccountUseCase>();

  CreateAccountNotifier() : super(const CreateAccountState.initial());

  Future<void> createAccount(
      {required String email, required String password}) async {
    if (!mounted) {
      return;
    }

    state = state.copyWith(isLoading: true);

    try {
      final result =
          await _createAccountUseCase.execute(email: email, password: password);

      print("RESULT CONSOLE $result");

      result.fold(
        (failure) {
          print("Create Account failed with message: ${failure.message}");
          state = state.copyWith(
            isLoading: false,
            errorMessage: failure.message,
          );
        },
        (success) {
          if (mounted) {
            state = state.copyWith(
              isLoading: false,
              isEmailLinkSent: true,
              errorMessage: null,
            );
            print("Email sent successfully");
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
      state = const CreateAccountState.initial();
    }
  }
}
