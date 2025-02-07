import 'package:equatable/equatable.dart';
import 'package:esab/models/user.dart';

enum CreateAccountConcreteState { initial, loading, loaded, failure }

class CreateAccountState extends Equatable {
  final User? user;
  final bool isEmailLinkSent;
  final String errorMessage;
  final CreateAccountConcreteState state;
  final bool isLoading;

  const CreateAccountState(
      {this.user,
      this.isEmailLinkSent = false,
      this.errorMessage = '',
      this.state = CreateAccountConcreteState.initial,
      this.isLoading = false});

  const CreateAccountState.initial(
      {this.user,
      this.isEmailLinkSent = false,
      this.errorMessage = '',
      this.state = CreateAccountConcreteState.initial,
      this.isLoading = false});

  CreateAccountState copyWith(
      {User? user,
      bool? isEmailLinkSent,
      String? errorMessage,
      CreateAccountConcreteState? state,
      bool? isLoading}) {
    return CreateAccountState(
        user: user ?? this.user,
        errorMessage: errorMessage ?? this.errorMessage,
        isEmailLinkSent: isEmailLinkSent ?? this.isEmailLinkSent,
        state: state ?? this.state,
        isLoading: isLoading ?? this.isLoading);
  }

  @override
  List<Object?> get props =>
      [user, errorMessage, isEmailLinkSent, state, isLoading];
}
