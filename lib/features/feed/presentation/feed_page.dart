import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';
import '../data/countdown_provider.dart';
import '../data/feed_providers.dart';
import '../../../core/utils/theme_utils.dart';

class FeedPage extends ConsumerWidget {
  const FeedPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final configAsync = ref.watch(electionConfigProvider);
    final countsAsync = ref.watch(voteCountsProvider);
    final candidatesAsync = ref.watch(candidatesStreamProvider);
    final countdownAsync = ref.watch(countdownProvider);

    return Scaffold(
      backgroundColor: context.pageBackground,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: _buildHeader(configAsync, countdownAsync),
            ),
            SliverToBoxAdapter(child: _buildTotalVotes(context, countsAsync)),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                child: Text(
                  'Candidate Results',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: context.mutedText),
                ),
              ),
            ),
            _buildCandidateResults(candidatesAsync, countsAsync),
            const SliverToBoxAdapter(child: SizedBox(height: 32)),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(AsyncValue configAsync, AsyncValue countdownAsync) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppTheme.primaryGreen, AppTheme.deepGreen],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.bar_chart, color: Colors.white70, size: 18),
              const SizedBox(width: 6),
              const Text(
                'LIVE FEED',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.2,
                ),
              ),
              const Spacer(),
              _LiveDot(),
            ],
          ),
          const SizedBox(height: 12),
          configAsync.when(
            data: (config) => Text(
              config.title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            loading: () => const Text(
              'Loading...',
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
            error: (_, __) => const Text(
              'Election',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),
          const SizedBox(height: 16),
          configAsync.when(
            data: (config) => _StatusChip(isOpen: config.isOpen),
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
          ),
          const SizedBox(height: 16),
          countdownAsync.when(
            data: (duration) => _CountdownDisplay(duration: duration),
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  Widget _buildTotalVotes(
      BuildContext context, AsyncValue<Map<String, int>> countsAsync) {
    return countsAsync.when(
      data: (counts) {
        final total = counts.values.fold(0, (a, b) => a + b);
        return Container(
          margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: context.cardColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: context.borderColor),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppTheme.primaryGreen.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.how_to_vote_outlined,
                  color: AppTheme.primaryGreen,
                  size: 20,
                ),
              ),
              const SizedBox(width: 14),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$total',
                    style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        color: context.primaryText),
                  ),
                  Text(
                    'Total Votes Cast',
                    style: TextStyle(fontSize: 13, color: context.mutedText),
                  ),
                ],
              ),
            ],
          ),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }

  Widget _buildCandidateResults(
    AsyncValue<List<Map<String, dynamic>>> candidatesAsync,
    AsyncValue<Map<String, int>> countsAsync,
  ) {
    return candidatesAsync.when(
      data: (candidates) {
        final counts = countsAsync.valueOrNull ?? {};
        final total = counts.values.fold(0, (a, b) => a + b);

        return SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              final c = candidates[index];
              final id = c['id'] as String;
              final votes = counts[id] ?? 0;
              final percent = total == 0 ? 0.0 : votes / total;

              return Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                child: _CandidateResultCard(
                  name: c['name'] as String,
                  party: c['party'] as String,
                  votes: votes,
                  percent: percent,
                  isLeading: total > 0 &&
                      votes == counts.values.reduce((a, b) => a > b ? a : b),
                ),
              );
            },
            childCount: candidates.length,
          ),
        );
      },
      loading: () => SliverToBoxAdapter(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(32),
            child: CircularProgressIndicator(color: AppTheme.primaryGreen),
          ),
        ),
      ),
      error: (e, _) => SliverToBoxAdapter(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Text('Failed to load results: $e',
                style: const TextStyle(color: AppTheme.textMuted)),
          ),
        ),
      ),
    );
  }
}

class _LiveDot extends StatefulWidget {
  @override
  State<_LiveDot> createState() => _LiveDotState();
}

class _LiveDotState extends State<_LiveDot>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);
    _animation = Tween(begin: 0.4, end: 1.0).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: Colors.greenAccent,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 4),
          const Text(
            'LIVE',
            style: TextStyle(
              color: Colors.greenAccent,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final bool isOpen;
  const _StatusChip({required this.isOpen});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isOpen
            ? Colors.greenAccent.withOpacity(0.2)
            : Colors.red.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isOpen ? Colors.greenAccent : Colors.redAccent,
          width: 1,
        ),
      ),
      child: Text(
        isOpen ? '● Voting Open' : '● Voting Closed',
        style: TextStyle(
          color: isOpen ? Colors.greenAccent : Colors.redAccent,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _CountdownDisplay extends StatelessWidget {
  final Duration duration;
  const _CountdownDisplay({required this.duration});

  String _pad(int n) => n.toString().padLeft(2, '0');

  @override
  Widget build(BuildContext context) {
    if (duration == Duration.zero) {
      return const Text(
        'Voting has closed',
        style: TextStyle(color: Colors.white70, fontSize: 13),
      );
    }

    final days = duration.inDays;
    final hours = duration.inHours % 24;
    final minutes = duration.inMinutes % 60;
    final seconds = duration.inSeconds % 60;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Closes in',
          style: TextStyle(color: Colors.white60, fontSize: 12),
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            _TimeUnit(value: _pad(days), label: 'DAYS'),
            const _TimeSep(),
            _TimeUnit(value: _pad(hours), label: 'HRS'),
            const _TimeSep(),
            _TimeUnit(value: _pad(minutes), label: 'MIN'),
            const _TimeSep(),
            _TimeUnit(value: _pad(seconds), label: 'SEC'),
          ],
        ),
      ],
    );
  }
}

class _TimeUnit extends StatelessWidget {
  final String value;
  final String label;
  const _TimeUnit({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.w800,
            fontFeatures: [FontFeature.tabularFigures()],
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white54,
            fontSize: 9,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }
}

class _TimeSep extends StatelessWidget {
  const _TimeSep();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.fromLTRB(6, 0, 6, 8),
      child: Text(
        ':',
        style: TextStyle(
          color: Colors.white54,
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _CandidateResultCard extends StatelessWidget {
  final String name;
  final String party;
  final int votes;
  final double percent;
  final bool isLeading;

  const _CandidateResultCard({
    required this.name,
    required this.party,
    required this.votes,
    required this.percent,
    required this.isLeading,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isLeading
              ? AppTheme.primaryGreen.withOpacity(0.4)
              : context.borderColor,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: AppTheme.lightGrey,
                child: Text(
                  name.split(' ').map((w) => w[0]).take(2).join(),
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                    color: AppTheme.textDark,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            name,
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                                color: context.primaryText),
                          ),
                        ),
                        if (isLeading)
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppTheme.primaryGreen,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Text(
                              'Leading',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                      ],
                    ),
                    Text(
                      party,
                      style: TextStyle(fontSize: 12, color: context.mutedText),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${(percent * 100).toStringAsFixed(1)}%',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: context.primaryText),
                  ),
                  Text(
                    '$votes vote${votes == 1 ? '' : 's'}',
                    style: TextStyle(fontSize: 11, color: context.mutedText),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: percent),
              duration: const Duration(milliseconds: 600),
              curve: Curves.easeOut,
              builder: (context, value, _) {
                return LinearProgressIndicator(
                  value: value,
                  minHeight: 8,
                  backgroundColor:
                      context.isDark ? AppTheme.darkBorder : AppTheme.lightGrey,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    isLeading
                        ? AppTheme.primaryGreen
                        : AppTheme.primaryGreen.withOpacity(0.5),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
