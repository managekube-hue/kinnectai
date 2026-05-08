import 'package:flutter/material.dart';
import '../theme/colors.dart';

class KinshipBadgeSheet extends StatelessWidget {
  final double kinScore;
  final String relationshipType;
  final String targetUserId;
  
  const KinshipBadgeSheet({
    super.key,
    required this.kinScore,
    required this.relationshipType,
    required this.targetUserId,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: const BoxDecoration(
        color: KinnectColors.darkSurface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          AppBar(
            backgroundColor: Colors.transparent,
            title: const Text('Kin Score Details'),
            actions: [
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(24),
              children: [
                Center(
                  child: Column(
                    children: [
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: _getScoreColor(kinScore).withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            '${(kinScore * 100).toStringAsFixed(1)}%',
                            style: TextStyle(
                              color: _getScoreColor(kinScore),
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        relationshipType,
                        style: const TextStyle(
                          color: KinnectColors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                _buildSection('Coefficient of Relationship', 'Biological proximity based on DNA'),
                const SizedBox(height: 16),
                _buildSection('Connection Path', 'Shared ancestors: 2 generations back'),
                const SizedBox(height: 16),
                _buildSection('DNA Evidence', 'Haplogroup match confirmed'),
                const SizedBox(height: 16),
                _buildSection('Confidence', '${(kinScore * 100).toStringAsFixed(0)}% verified'),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(
                      context,
                      '/kin-score',
                      arguments: {'targetUserId': targetUserId},
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: KinnectColors.amber,
                    minimumSize: const Size(double.infinity, 56),
                  ),
                  child: const Text(
                    'View Full Graph Path',
                    style: TextStyle(color: KinnectColors.darkBg, fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, String description) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: KinnectColors.darkBg,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: KinnectColors.amber,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            description,
            style: const TextStyle(color: KinnectColors.grey60, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Color _getScoreColor(double score) {
    if (score >= 0.8) return KinnectColors.amber;
    if (score >= 0.5) return KinnectColors.success;
    return KinnectColors.grey60;
  }
}
