import 'package:esab/features/home/presentation/providers/state/home_notifier.dart';
import 'package:esab/features/home/presentation/providers/state/home_state.dart';
import 'package:esab/features/home/presentation/providers/state/logout_notifier.dart';
import 'package:esab/features/home/presentation/providers/state/logout_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final logoutStateNotifierProvider =
    StateNotifierProvider<LogoutNotifier, LogoutState>(
        (ref) => LogoutNotifier());

final homeStateNotifierProvider =
    AutoDisposeStateNotifierProvider<HomeNotifier, HomeState>(
        (ref) => HomeNotifier());
