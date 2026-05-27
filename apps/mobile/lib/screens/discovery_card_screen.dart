import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/discovery/discovery_bloc.dart';
import '../models/dtos/discovery_candidate_dto.dart';
import '../theme/colors.dart';
import '../theme/typography.dart';

/// Single-candidate discovery card screen (PRD §07, Audit Item 29).
///
/// Deep-linked via `kinnect://discovery/<candidateId>` →
/// `GET /v1/discovery/:candidateId`
///
/// Displays the candidate's KC score, branch overlaps, and accept / dismiss
/// actions. Backed by [DiscoveryBloc].
class DiscoveryCardScreen extends StatelessWidget {
  const DiscoveryCardScreen({required this.candidateId, super.key});

  final String candidateId;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DiscoveryBloc, DiscoveryState>(
      builder: (ctx, state) {
        DiscoveryCandidateDTO? candidate;
        if (state is DiscoveryLoaded) {
          try {
            candidate = state.candidates.firstWhere(
              (c) => c.userId == candidateId,
            );
          } catch (_) {}
        }

        return Scaffold(
          backgroundColor: KinnectColors.background,
          appBar: AppBar(
            backgroundColor: KinnectColors.surface,
            title: const Text('Kin Discovery', style: KinnectTextStyles.headlineSmall),
            leading: const BackButton(color: KinnectColors.textPrimary),
          ),
          body: switch (state) {
            DiscoveryLoading() => const Center(child: CircularProgressIndicator()),
            DiscoveryError(:final message) => Center(
                child: Text(message, style: KinnectTextStyles.bodyMedium),
              ),
            _ when candidate != null => _CandidateCard(candidate: candidate),
            _ => Center(
                child: Text(
                  'Candidate not found',
                  style: KinnectTextStyles.bodyMedium.copyWith(
                    color: KinnectColors.textSecondary,
                  ),
                ),
              ),
          },
        );
      },
    );
  }
}

class _CandidateCard extends StatelessWidget {
  const _CandidateCard({required this.candidate});

  final DiscoveryCandidateDTO candidate;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CircleAvatar(
            radius: 48,
            backgroundImage: candidate.avatarUrl != null
                ? NetworkImage(candidate.avatarUrl!)
                : null,
            child: candidate.avatarUrl == null
                ? Text(
                    candidate.displayName.isNotEmpty
                        ? candidate.displayName[0].toUpperCase()
                        : '?',
                    style: KinnectTextStyles.headlineSmall,
                  )
                : null,
          ),
          const SizedBox(height: 16),
          Text(
            candidate.displayName,
            style: KinnectTextStyles.headlineSmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'KC Score: ${(candidate.connectionScore * 100).toStringAsFixed(1)}%',
            style: KinnectTextStyles.bodyMedium.copyWith(
              color: KinnectColors.accent,
            ),
            textAlign: TextAlign.center,
          ),
          const Spacer(),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    context
                        .read<DiscoveryBloc>()
                        .add(DismissCandidate(candidate.userId));
                    Navigator.of(context).pop();
                  },
                  child: const Text('Dismiss'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    context
                        .read<DiscoveryBloc>()
                        .add(KinnectRequest(candidate.userId));
                    Navigator.of(context).pop();
                  },
                  child: const Text('Connect'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
