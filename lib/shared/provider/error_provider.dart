import 'package:flutter_riverpod/flutter_riverpod.dart';

class ErrorState {
  final String? emailError;
  final String? passwordError;
  final String? confirmPasswordError;
  final String? commonError;

  ErrorState({
    this.emailError,
    this.passwordError,
    this.confirmPasswordError,
    this.commonError,
  });
}

class ErrorNotifier extends StateNotifier<ErrorState> {
  ErrorNotifier() : super(ErrorState());

  void setEmailError(String message) {
    state = ErrorState(
      emailError: message,
      passwordError: state.passwordError,
      confirmPasswordError: state.confirmPasswordError,
      commonError: state.commonError,
    );
  }

  void setPasswordError(String message) {
    state = ErrorState(
      emailError: state.emailError,
      passwordError: message,
      confirmPasswordError: state.confirmPasswordError,
      commonError: state.commonError,
    );
  }

  void setConfirmPasswordError(String message) {
    state = ErrorState(
      emailError: state.emailError,
      passwordError: state.passwordError,
      confirmPasswordError: message,
      commonError: state.commonError,
    );
  }

  void setCommonError(String message) {
    state = ErrorState(
      emailError: state.emailError,
      passwordError: state.passwordError,
      confirmPasswordError: state.confirmPasswordError,
      commonError: message,
    );
  }

  void clearErrors() {
    state = ErrorState();
  }
}

final errorProvider = StateNotifierProvider<ErrorNotifier, ErrorState>((ref) {
  return ErrorNotifier();
});
