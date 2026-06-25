import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'feed_repository.dart';
import '../domain/election_config.dart';

final feedRepositoryProvider = Provider<FeedRepository>((ref) {
  return FeedRepository();
});

final electionConfigProvider = StreamProvider<ElectionConfig>((ref) {
  return ref.watch(feedRepositoryProvider).electionConfigStream();
});

final voteCountsProvider = StreamProvider<Map<String, int>>((ref) {
  return ref.watch(feedRepositoryProvider).voteCountsStream();
});

final candidatesStreamProvider =
    StreamProvider<List<Map<String, dynamic>>>((ref) {
  return ref.watch(feedRepositoryProvider).candidatesStream();
});