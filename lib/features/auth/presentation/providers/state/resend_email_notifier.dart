import 'package:esab/features/auth/domain/use_cases/resend_email_use_case.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dartz/dartz.dart';
import 'package:esab/di/injector.dart';
import 'package:esab/shared/util/app_exception.dart';
import 'package:esab/features/auth/presentation/providers/state/resend_email_state.dart';

class ResendEmailNotifier extends StateNotifier<ResendEmailState> {
  final ResendEmailUseCase _resendEmailUseCase =
      injector.get<ResendEmailUseCase>();

  ResendEmailNotifier() : super(ResendEmailState.initial());

  Future<void> resendEmail(String email) async {
    if (!mounted) {
      return;
    }

    state = state.copyWith(isLoading: true);

    try {
      final Either<AppException, bool> result =
          await _resendEmailUseCase.execute(email: email);

      result.fold(
        (failure) {
          if (mounted) {
            state = state.copyWith(
              isLoading: false,
              errorMessage: failure.message,
            );
          }
        },
        (success) {
          if (mounted) {
            state = state.copyWith(
              isLoading: false,
              isEmailSent: success,
              errorMessage: null,
            );
          }
        },
      );
    } catch (e) {
      print("Unexpected error during Resend Email: $e");
      if (mounted) {
        state = state.copyWith(
          isLoading: false,
          errorMessage:
              'An unexpected error occurred while resending the email.',
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
      state = ResendEmailState.initial();
    }
  }
}
