import 'package:equatable/equatable.dart';

class OnboardState extends Equatable {
  final bool isFirstLaunch;

  const OnboardState({required this.isFirstLaunch});

  factory OnboardState.initial() {
    return const OnboardState(
      isFirstLaunch: true,
    );
  }

  OnboardState copyWith({
    bool? isFirst,
  }) {
    return OnboardState(
      isFirstLaunch: isFirst ?? isFirstLaunch,
    );
  }

  @override
  List<Object?> get props => [isFirstLaunch];
}
