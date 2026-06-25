import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:votrr/core/utils/theme_utils.dart';
import '../../../core/theme/app_theme.dart';
import '../data/vote_notifier.dart';
import '../domain/candidate.dart';
import '../domain/vote_state.dart';

class VotePage extends ConsumerWidget {
  const VotePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(voteProvider);

    return Scaffold(
      backgroundColor: context.pageBackground,
      body: SafeArea(
        child: switch (state) {
          VoteInitial() => const _LoadingView(),
          VoteLoading() => const _LoadingView(),
          VoteSubmitting() =>
            const _LoadingView(message: 'Submitting your vote...'),
          VoteReady() => _ReadyView(state: state as VoteReady),
          VoteSubmitted() => _SubmittedView(state: state as VoteSubmitted),
          VoteError() => _ErrorView(state: state as VoteError),
        },
      ),
    );
  }
}

// ─── Loading ────────────────────────────────────────────────────────────────

class _LoadingView extends StatelessWidget {
  final String message;
  const _LoadingView({this.message = 'Loading candidates...'});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(color: AppTheme.primaryGreen),
          const SizedBox(height: 16),
          Text(message, style: const TextStyle(color: AppTheme.textMuted)),
        ],
      ),
    );
  }
}

// ─── Error ───────────────────────────────────────────────────────────────────

class _ErrorView extends ConsumerWidget {
  final VoteError state;
  const _ErrorView({required this.state});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.wifi_off, size: 48, color: AppTheme.textMuted),
            const SizedBox(height: 16),
            Text(
              state.message,
              textAlign: TextAlign.center,
              style: TextStyle(color: context.mutedText),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => ref.read(voteProvider.notifier).load(),
              child: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Already Voted ───────────────────────────────────────────────────────────

class _SubmittedView extends StatelessWidget {
  final VoteSubmitted state;
  const _SubmittedView({required this.state});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 88,
              height: 88,
              decoration: const BoxDecoration(
                color: AppTheme.primaryGreen,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check, color: Colors.white, size: 48),
            ),
            const SizedBox(height: 24),
            Text(
              'Vote Submitted',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: context.mutedText,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'You voted for',
              style: TextStyle(color: context.mutedText, fontSize: 14),
            ),
            const SizedBox(height: 4),
            Text(
              state.votedCandidateName,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: AppTheme.primaryGreen,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.primaryGreen.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppTheme.primaryGreen.withValues(alpha: 0.2),
                ),
              ),
              child: const Row(
                children: [
                  Icon(Icons.lock_outline,
                      size: 16, color: AppTheme.primaryGreen),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Your vote has been recorded and cannot be changed.',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppTheme.primaryGreen,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Ready to Vote ───────────────────────────────────────────────────────────

class _ReadyView extends ConsumerWidget {
  final VoteReady state;
  const _ReadyView({required this.state});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(child: _buildHeader()),
        if (!state.electionOpen)
          SliverToBoxAdapter(child: _buildClosedBanner()),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final candidate = state.candidates[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _CandidateCard(
                    candidate: candidate,
                    isSelected: state.selectedId == candidate.id,
                    isEnabled: state.electionOpen,
                    onTap: state.electionOpen
                        ? () => ref
                            .read(voteProvider.notifier)
                            .selectCandidate(candidate.id)
                        : null,
                  ),
                );
              },
              childCount: state.candidates.length,
            ),
          ),
        ),
        if (state.electionOpen)
          SliverToBoxAdapter(
            child: _buildSubmitButton(context, ref),
          ),
        const SliverToBoxAdapter(child: SizedBox(height: 32)),
      ],
    );
  }

  Widget _buildHeader() {
    return const Padding(
      padding: EdgeInsets.fromLTRB(16, 24, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Cast Your Vote',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w700,
              color: AppTheme.textMuted,
            ),
          ),
          SizedBox(height: 4),
          Text(
            'Select a candidate and confirm your choice.',
            style: TextStyle(fontSize: 14, color: AppTheme.textMuted),
          ),
        ],
      ),
    );
  }

  Widget _buildClosedBanner() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange.shade200),
      ),
      child: Row(
        children: [
          Icon(Icons.schedule, color: Colors.orange.shade700, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Voting is currently closed.',
              style: TextStyle(
                color: Colors.orange.shade800,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton(BuildContext context, WidgetRef ref) {
    final hasSelection = state.selectedId != null;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: ElevatedButton(
        onPressed: hasSelection ? () => _showConfirmDialog(context, ref) : null,
        style: ElevatedButton.styleFrom(
          disabledBackgroundColor: AppTheme.lightGrey,
          disabledForegroundColor: AppTheme.textMuted,
        ),
        child: const Text('Submit Vote'),
      ),
    );
  }

  Future<void> _showConfirmDialog(BuildContext context, WidgetRef ref) async {
    final candidate =
        state.candidates.firstWhere((c) => c.id == state.selectedId);

    final confirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Confirm Your Vote',
          style: TextStyle(fontWeight: FontWeight.w700, color: context.primaryText),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'You are about to vote for:',
              style: TextStyle(color: context.mutedText, fontSize: 14),
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: context.pageBackground,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: context.borderColor),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    candidate.name,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                      color: context.mutedText
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    candidate.party,
                    style: const TextStyle(
                      color: AppTheme.textMuted,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'This action cannot be undone.',
              style: TextStyle(
                color: AppTheme.errorRed,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('Cancel',
                style: TextStyle(color: context.mutedText)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Confirm Vote'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      ref.read(voteProvider.notifier).submitVote();
    }
  }
}

// ─── Candidate Card ──────────────────────────────────────────────────────────

class _CandidateCard extends StatelessWidget {
  final Candidate candidate;
  final bool isSelected;
  final bool isEnabled;
  final VoidCallback? onTap;

  const _CandidateCard({
    required this.candidate,
    required this.isSelected,
    required this.isEnabled,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: context.cardColor,
        border: Border.all(
          color: isSelected ? AppTheme.primaryGreen : context.borderColor,
          width: isSelected ? 2 : 1,
        ),
        boxShadow: isSelected
            ? [
                BoxShadow(
                  color: AppTheme.primaryGreen.withValues(alpha: 0.12),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                )
              ]
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                )
              ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Party colour accent bar
                Container(
                  width: 4,
                  height: 56,
                  decoration: BoxDecoration(
                    color: candidate.partyColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 14),
                // Avatar
                CircleAvatar(
                  radius: 28,
                  backgroundColor: AppTheme.lightGrey,
                  child: Text(
                    candidate.name.split(' ').map((w) => w[0]).take(2).join(),
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: context.cardColor,
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                // Name + party
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        candidate.name,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                          color: context.primaryText
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${candidate.party} · ${candidate.position}',
                        style: TextStyle(
                          fontSize: 13,
                          color: context.mutedText,
                        ),
                      ),
                    ],
                  ),
                ),
                // Selection indicator
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: isSelected
                      ? const Icon(Icons.check_circle,
                          key: ValueKey('selected'),
                          color: AppTheme.primaryGreen,
                          size: 24)
                      : Icon(Icons.circle_outlined,
                          key: const ValueKey('unselected'),
                          color: isEnabled
                              ? AppTheme.lightGrey
                              : AppTheme.lightGrey,
                          size: 24),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
