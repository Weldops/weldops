import 'package:equatable/equatable.dart';

enum GoogleSignInConcreteState { initial, loading, success, failure }

class GoogleSignInState extends Equatable {
  final String? userName;
  final String? email;
  final String? idToken;
  final bool isSignedIn;
  final String errorMessage;
  final GoogleSignInConcreteState state;
  final bool isLoading;

  const GoogleSignInState({
    this.userName,
    this.email,
    this.idToken,
    this.isSignedIn = false,
    this.errorMessage = '',
    this.state = GoogleSignInConcreteState.initial,
    this.isLoading = false,
  });

  // Initial state
  const GoogleSignInState.initial()
      : userName = null,
        email = null,
        idToken = null,
        isSignedIn = false,
        errorMessage = '',
        state = GoogleSignInConcreteState.initial,
        isLoading = false;

  GoogleSignInState copyWith({
    String? userName,
    String? email,
    String? idToken,
    bool? isSignedIn,
    String? errorMessage,
    GoogleSignInConcreteState? state,
    bool? isLoading,
  }) {
    return GoogleSignInState(
      userName: userName ?? this.userName,
      email: email ?? this.email,
      idToken: idToken ?? this.idToken,
      isSignedIn: isSignedIn ?? this.isSignedIn,
      errorMessage: errorMessage ?? this.errorMessage,
      state: state ?? this.state,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props =>
      [userName, email, idToken, isSignedIn, errorMessage, state, isLoading];
}
