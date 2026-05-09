import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../blocs/discovery/discovery_bloc.dart';
import '../models/dtos/discovery_candidate_dto.dart';
import '../router/app_nav.dart';
import '../theme/colors.dart';
import '../theme/typography.dart';

/// PRD Section 07 -- Discovery Page.
/// Biologically-curated candidate cards ranked by Connection Score.
class DiscoveryPageScreen extends StatefulWidget {
  const DiscoveryPageScreen({super.key});

  @override
  State<DiscoveryPageScreen> createState() => _DiscoveryPageScreenState();
}

class _DiscoveryPageScreenState extends State<DiscoveryPageScreen> {
  int _filterIndex = 0;

  static const _filters = ['All', 'DNA Matches', 'Name Matches', 'Branch Overlaps', 'Facial Matches'];

  @override
  void initState() {
    super.initState();
    final bloc = context.read<DiscoveryBloc>();
    if (bloc.state is DiscoveryInitial) {
      bloc.add(const FetchCandidates());
    }
  }

  void _onFilterTap(int index) {
    setState(() => _filterIndex = index);
    context.read<DiscoveryBloc>().add(ApplyFilter(filter: _filters[index]));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KinnectColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Filter chips
            SizedBox(
              height: 48,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                itemCount: _filters.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, i) => _FilterChip(
                  label: _filters[i],
                  selected: i == _filterIndex,
                  onTap: () => _onFilterTap(i),
                ),
              ),
            ),

            // Candidate list
            Expanded(
              child: BlocBuilder<DiscoveryBloc, DiscoveryState>(
                builder: (context, state) {
                  if (state is DiscoveryLoading) {
                    return const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(KinnectColors.accent),
                      ),
                    );
                  }

                  if (state is DiscoveryEmpty) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(PhosphorIcons.binoculars(), size: 64, color: KinnectColors.textMuted),
                          const SizedBox(height: 16),
                          Text('Scanning biological graph...', style: KinnectTextStyles.bodyLarge.copyWith(color: KinnectColors.textSecondary)),
                          const SizedBox(height: 8),
                          Text('New candidates unlock every Sunday.', style: KinnectTextStyles.bodyLarge.copyWith(color: KinnectColors.textMuted)),
                        ],
                      ),
                    );
                  }

                  if (state is DiscoveryError) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(PhosphorIcons.wifiSlash(), size: 48, color: KinnectColors.error),
                          const SizedBox(height: 12),
                          Text(state.message, style: KinnectTextStyles.bodyLarge.copyWith(color: KinnectColors.textSecondary)),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () => context.read<DiscoveryBloc>().add(const FetchCandidates()),
                            style: ElevatedButton.styleFrom(backgroundColor: KinnectColors.accent),
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    );
                  }

                  if (state is DiscoveryLoaded) {
                    return RefreshIndicator(
                      color: KinnectColors.accent,
                      onRefresh: () async {
                        context.read<DiscoveryBloc>().add(const FetchCandidates());
                      },
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        itemCount: state.candidates.length + (state.hasMore ? 1 : 0),
                        itemBuilder: (context, i) {
                          if (i >= state.candidates.length) {
                            context.read<DiscoveryBloc>().add(const FetchCandidates(isLoadMore: true));
                            return const Padding(
                              padding: EdgeInsets.all(24),
                              child: Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(KinnectColors.accent))),
                            );
                          }
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: _DiscoveryCard(candidate: state.candidates[i]),
                          );
                        },
                      ),
                    );
                  }

                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Discovery Card (PRD 07.1)
// ---------------------------------------------------------------------------

class _DiscoveryCard extends StatelessWidget {
  const _DiscoveryCard({required this.candidate});

  final DiscoveryCandidateDTO candidate;

  @override
  Widget build(BuildContext context) {
    final score = (candidate.connectionScore * 100).round();

    return Container(
      decoration: BoxDecoration(
        color: KinnectColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: KinnectColors.dividerSubtle),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Preview area
          Stack(
            children: [
              Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: KinnectColors.surfaceElevated,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                ),
                child: candidate.previewMediaUrl != null
                    ? ClipRRect(
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                        child: Image.network(candidate.previewMediaUrl!, fit: BoxFit.cover),
                      )
                    : Center(
                        child: Icon(PhosphorIcons.user(), size: 64, color: KinnectColors.textMuted),
                      ),
              ),
              // Connection Score badge
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: score >= 80 ? KinnectColors.accent : score >= 50 ? KinnectColors.primary : KinnectColors.textSecondary.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '$score%',
                    style: KinnectTextStyles.bodyLarge.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(candidate.displayName, style: KinnectTextStyles.headlineSmall),
                const SizedBox(height: 4),
                Text(
                  candidate.relationshipGuess,
                  style: KinnectTextStyles.bodyLarge.copyWith(color: KinnectColors.primary),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      candidate.primarySignal.contains('DNA') ? PhosphorIcons.dna() : PhosphorIcons.treeStructure(),
                      size: 14,
                      color: KinnectColors.textSecondary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      candidate.primarySignal,
                      style: KinnectTextStyles.bodyLarge.copyWith(color: KinnectColors.textSecondary, fontSize: 13),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => AppNav.push(context, '/root/${candidate.userId}'),
                        icon: Icon(PhosphorIcons.path(), size: 18),
                        label: const Text('Explore Connection'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: KinnectColors.primary,
                          side: const BorderSide(color: KinnectColors.primary),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          context.read<DiscoveryBloc>().add(KinnectRequest(userId: candidate.userId));
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Kinnection request sent to ${candidate.displayName}'),
                              backgroundColor: KinnectColors.success,
                            ),
                          );
                        },
                        icon: Icon(PhosphorIcons.handshake(), size: 18),
                        label: const Text('Kinnect'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: KinnectColors.accent,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Filter Chip
// ---------------------------------------------------------------------------

class _FilterChip extends StatelessWidget {
  const _FilterChip({required this.label, required this.selected, required this.onTap});

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? KinnectColors.accent : KinnectColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: selected ? KinnectColors.accent : KinnectColors.dividerSubtle),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : KinnectColors.textSecondary,
            fontSize: 13,
            fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
