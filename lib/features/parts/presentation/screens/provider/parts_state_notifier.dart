import 'package:esab/features/parts/presentation/screens/provider/state/parts_notifier.dart';
import 'package:esab/features/parts/presentation/screens/provider/state/parts_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final partsProvider =
    AutoDisposeStateNotifierProvider<PartsNotifier, PartsState>(
        (ref) => PartsNotifier());
