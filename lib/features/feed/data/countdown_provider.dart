import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'feed_providers.dart';

// Emits a Duration every second until closesAt.
// Automatically stops when the election closes.
final countdownProvider = StreamProvider<Duration>((ref) async* {
  // Watch election config — rebuilds if config changes
  final configAsync = ref.watch(electionConfigProvider);

  final config = configAsync.valueOrNull;
  if (config == null || config.closesAt == null) {
    yield Duration.zero;
    return;
  }

  final closesAt = config.closesAt!;

  // Tick every second
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