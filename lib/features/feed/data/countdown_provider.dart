import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'feed_providers.dart';

// emits a "Duration" every second until closesAt.
// automatically stops when the election closes.
final countdownProvider = StreamProvider<Duration>((ref) async* {
  // Watch election config and rebuilds if config changes
  final configAsync = ref.watch(electionConfigProvider);

  final config = configAsync.valueOrNull;
  if (config == null || config.closesAt == null) {
    yield Duration.zero;
    return;
  }

  final closesAt = config.closesAt!;

  // tick every second
  while (true) {
    final remaining = closesAt.difference(DateTime.now());
    if (remaining.isNegative) {
      yield Duration.zero;
      return;
    }
    yield remaining;
    await Future.delayed(const Duration(seconds: 1));
  }
});