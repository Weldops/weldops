import 'package:equatable/equatable.dart';
import 'package:esab/models/user.dart';

enum SignInConcreteState { initial, loading, loaded, failure }

class SignInState extends Equatable {
  final User? user;
  final bool isSignedIn;
  final String errorMessage;
  final SignInConcreteState state;
  final bool isLoading;

  const SignInState(
      {this.user,
      this.isSignedIn = false,
      this.errorMessage = '',
      this.state = SignInConcreteState.initial,
      this.isLoading = false});

  const SignInState.initial(
      {this.user,
      this.isSignedIn = false,
      this.errorMessage = '',
      this.state = SignInConcreteState.initial,
      this.isLoading = false});

  SignInState copyWith(
      {User? user,
      bool? isSignedIn,
      String? errorMessage,
      SignInConcreteState? state,
      bool? isLoading}) {
    return SignInState(
        user: user ?? this.user,
        errorMessage: errorMessage ?? this.errorMessage,
        isSignedIn: isSignedIn ?? this.isSignedIn,
        state: state ?? this.state,
        isLoading: isLoading ?? this.isLoading);
  }

  @override
  List<Object?> get props => [user, errorMessage, isSignedIn, state, isLoading];
}
