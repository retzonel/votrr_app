import 'package:flutter/material.dart';
import 'package:votrr/core/utils/theme_utils.dart';
import '../../../core/theme/app_theme.dart';
import '../data/polling_data.dart';
import '../domain/polling_models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../feed/data/feed_providers.dart';

class PollingPage extends ConsumerWidget {
  const PollingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final configAsync = ref.watch(electionConfigProvider);
    return Scaffold(
      backgroundColor: context.pageBackground,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: _buildHeader(context)),
            SliverToBoxAdapter(
              child: _buildElectionInfoCard(
                configAsync.valueOrNull?.title ?? 'Election',
              ),
            ),
            SliverToBoxAdapter(child: _buildSectionLabel('How to Vote', context)),
            SliverToBoxAdapter(child: _buildInstructions()),
            SliverToBoxAdapter(child: _buildSectionLabel('Polling Locations', context)),
            SliverToBoxAdapter(child: _buildLocationSubtitle()),
            _buildLocationList(),
            const SliverToBoxAdapter(child: SizedBox(height: 32)),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Polling Info',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w700,
              color: context.primaryText
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Everything you need to know before voting.',
            style: TextStyle(fontSize: 14, color: AppTheme.textMuted),
          ),
        ],
      ),
    );
  }

  Widget _buildElectionInfoCard(String title) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 16),
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
          const Row(
            children: [
              Icon(Icons.info_outline, color: Colors.white70, size: 16),
              SizedBox(width: 6),
              Text(
                'ELECTION DETAILS',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 16),
          const Divider(color: Colors.white24),
          const SizedBox(height: 12),
          const _InfoRow(
            icon: Icons.calendar_today_outlined,
            label: 'Election Date',
            value: 'February 27, 2027',
          ),
          const SizedBox(height: 10),
          const _InfoRow(
            icon: Icons.access_time_outlined,
            label: 'Voting Hours',
            value: '8:00 AM — 2:30 PM',
          ),
          const SizedBox(height: 10),
          const _InfoRow(
            icon: Icons.location_on_outlined,
            label: 'Authority',
            value: 'GROUP-2',
          ),
          const SizedBox(height: 10),
          const _InfoRow(
            icon: Icons.gavel_outlined,
            label: 'Position',
            value: 'President of Yam',
          ),
        ],
      ),
    );
  }

  Widget _buildSectionLabel(String label, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: context.primaryText
        ),
      ),
    );
  }

  Widget _buildInstructions() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      child: Column(
        children: PollingData.instructions
            .map((i) => _InstructionCard(instruction: i))
            .toList(),
      ),
    );
  }

  Widget _buildLocationSubtitle() {
    return const Padding(
      padding: EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: Text(
        'Mock data for demonstration purposes.',
        style: TextStyle(fontSize: 13, color: AppTheme.textMuted),
      ),
    );
  }

  Widget _buildLocationList() {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final location = PollingData.locations[index];
          return Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: _LocationCard(location: location),
          );
        },
        childCount: PollingData.locations.length,
      ),
    );
  }
}

// ─── Supporting Widgets ───────────────────────────────────────────────────────

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: Colors.white60, size: 16),
        const SizedBox(width: 10),
        Text(
          label,
          style: const TextStyle(color: Colors.white60, fontSize: 13),
        ),
        const Spacer(),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _InstructionCard extends StatelessWidget {
  final VotingInstruction instruction;
  const _InstructionCard({required this.instruction});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Step number circle
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: AppTheme.primaryGreen,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                instruction.step,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),
          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                Text(
                  instruction.title,
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: context.primaryText),
                ),
                const SizedBox(height: 4),
                Text(
                  instruction.description,
                  style: TextStyle(
                    fontSize: 13,
                    color: context.mutedText,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 12),
                // Connector line (except last item)
                if (instruction.step != '06')
                  Padding(
                    padding: const EdgeInsets.only(left: 0),
                    child: Container(
                      height: 1,
                      color: AppTheme.lightGrey,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LocationCard extends StatelessWidget {
  final PollingLocation location;
  const _LocationCard({required this.location});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: context.borderColor),
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.primaryGreen.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.location_on,
                  color: AppTheme.primaryGreen,
                  size: 18,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      location.name,
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                          color: context.primaryText),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      location.address,
                      style: TextStyle(fontSize: 13, color: context.mutedText),
                    ),
                  ],
                ),
              ),
              if (location.isAccessible)
                Tooltip(
                  message: 'Wheelchair accessible',
                  child: Icon(
                    Icons.accessible,
                    color: AppTheme.primaryGreen.withOpacity(0.7),
                    size: 18,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Divider(
            height: 1,
            color: context.borderColor,
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: [
              _MetaChip(
                icon: Icons.map_outlined,
                label: '${location.lga} LGA',
              ),
              _MetaChip(
                icon: Icons.access_time,
                label: '${location.openTime} – ${location.closeTime}',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MetaChip extends StatelessWidget {
  final IconData icon;
  final String label;
  const _MetaChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: context.pageBackground,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: context.borderColor),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: AppTheme.textMuted),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: context.mutedText,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
