import 'package:esab/di/injector.dart';
import 'package:esab/features/auth/domain/use_cases/google_signin_use_case.dart';
import 'package:esab/features/auth/presentation/providers/state/google_signin_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dartz/dartz.dart';
import 'package:esab/shared/util/app_exception.dart';
import 'package:esab/models/user.dart';

class GoogleSignInNotifier extends StateNotifier<GoogleSignInState> {
  final GoogleSignInUseCase _googleSignInUseCase =
      injector.get<GoogleSignInUseCase>();

  GoogleSignInNotifier() : super(const GoogleSignInState.initial());

  Future<void> googleSignIn() async {
    if (!mounted) {
      return;
    }

    state = state.copyWith(isLoading: true);

    try {
      final Either<AppException, User> result =
          await _googleSignInUseCase.execute();

      result.fold(
        (failure) {
          if (mounted) {
            state = state.copyWith(
              isLoading: false,
              errorMessage: failure.message,
            );
          }
        },
        (user) {
          if (mounted) {
            state = state.copyWith(
              isLoading: false,
              isSignedIn: true,
              errorMessage: null,
            );
          }
        },
      );
    } catch (e) {
      print("Unexpected error during Google Sign-In: $e");
      if (mounted) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: 'An unexpected error occurred during Google Sign-In.',
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
      state = const GoogleSignInState.initial();
    }
  }
}
