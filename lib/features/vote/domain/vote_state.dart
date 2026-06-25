import 'candidate.dart';

sealed class VoteState {
  const VoteState();
}

class VoteInitial extends VoteState {
  const VoteInitial();
}

class VoteLoading extends VoteState {
  const VoteLoading();
}

// Candidates loaded, waiting for user to pick
class VoteReady extends VoteState {
  final List<Candidate> candidates;
  final String? selectedId;      // which card is highlighted
  final bool electionOpen;

  const VoteReady({
    required this.candidates,
    this.selectedId,
    required this.electionOpen,
  });

  VoteReady copyWith({
    List<Candidate>? candidates,
    String? selectedId,
    bool clearSelection = false,
    bool? electionOpen,
  }) {
    return VoteReady(
      candidates: candidates ?? this.candidates,
      selectedId: clearSelection ? null : (selectedId ?? this.selectedId),
      electionOpen: electionOpen ?? this.electionOpen,
    );
  }
}

// User has already voted
class VoteSubmitted extends VoteState {
  final String votedCandidateId;
  final String votedCandidateName;

  const VoteSubmitted({
    required this.votedCandidateId,
    required this.votedCandidateName,
  });
}

class VoteSubmitting extends VoteState {
  const VoteSubmitting();
}

class VoteError extends VoteState {
  final String message;
  const VoteError(this.message);
}