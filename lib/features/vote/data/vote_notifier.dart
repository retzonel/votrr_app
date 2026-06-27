import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/vote_state.dart';
import 'vote_repository.dart';

class VoteNotifier extends StateNotifier<VoteState> {
  final VoteRepository _repository;

  VoteNotifier(this._repository) : super(const VoteInitial()) {
    load();
  }

  Future<void> load() async {
    state = const VoteLoading();
    try {
      final existingVote = await _repository.getUserVote();

      if (existingVote != null) {
        String candidateName = 'your candidate';
        try {
          final candidates = await _repository.getCandidates();
          final voted = candidates.firstWhere(
            (c) => c.id == existingVote,
            orElse: () => throw Exception('not found'),
          );
          candidateName = voted.name;
        } catch (_) {}

        state = VoteSubmitted(
          votedCandidateId: existingVote,
          votedCandidateName: candidateName,
        );
        return;
      }

      final results = await Future.wait([
        _repository.getCandidates(),
        _repository.isElectionOpen(),
      ]);

      state = VoteReady(
        candidates: results[0] as dynamic,
        electionOpen: results[1] as bool,
      );
    } catch (e) {
      state = const VoteError('Failed to load. Please check your connection.');
    }
  }

  void selectCandidate(String candidateId) {
    if (state is! VoteReady) return;
    final current = state as VoteReady;
    state = current.copyWith(selectedId: candidateId);
  }

  Future<void> submitVote() async {
    if (state is! VoteReady) return;
    final current = state as VoteReady;
    if (current.selectedId == null) return;

    final candidate =
        current.candidates.firstWhere((c) => c.id == current.selectedId);

    state = const VoteSubmitting();
    try {
      await _repository.castVote(
        candidateId: candidate.id,
        candidateName: candidate.name,
      );
      state = VoteSubmitted(
        votedCandidateId: candidate.id,
        votedCandidateName: candidate.name,
      );
    } catch (e) {
      state =
          const VoteError('Failed to submit vote. You may have already voted.');
    }
  }
}

final voteRepositoryProvider = Provider<VoteRepository>((ref) {
  return VoteRepository();
});

final voteProvider = StateNotifierProvider<VoteNotifier, VoteState>((ref) {
  return VoteNotifier(ref.read(voteRepositoryProvider));
});
