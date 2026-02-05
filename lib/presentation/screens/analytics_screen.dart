import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/decision.dart';
import '../providers/decision_provider.dart';

class AnalyticsScreen extends ConsumerWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final decisionsAsync = ref.watch(allDecisionsProvider);

    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Analytics'),
      ),
      child: SafeArea(
        child: decisionsAsync.when(
          data: (decisions) {
            if (decisions.isEmpty) {
              return _buildEmptyState();
            }

            final withResults = decisions.where((d) => d.hasResult).toList();

            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildStatCard(
                    'Total Decisions',
                    decisions.length.toString(),
                    CupertinoColors.activeBlue,
                  ),
                  const SizedBox(height: 12),
                  _buildStatCard(
                    'With Results',
                    withResults.length.toString(),
                    CupertinoColors.systemGreen,
                  ),
                  const SizedBox(height: 12),
                  _buildStatCard(
                    'Awaiting Evaluation',
                    (decisions.length - withResults.length).toString(),
                    CupertinoColors.systemOrange,
                  ),
                  const SizedBox(height: 32),
                  const Text(
                    'Average Rating by Category',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: CupertinoColors.black,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ...DecisionCategory.values.map((category) {
                    final categoryDecisions = withResults
                        .where((d) => d.category == category)
                        .toList();
                    
                    if (categoryDecisions.isEmpty) return const SizedBox();

                    final avgRating = categoryDecisions
                            .map((d) => d.resultRating!)
                            .reduce((a, b) => a + b) /
                        categoryDecisions.length;

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _buildCategoryRatingCard(
                        category,
                        avgRating,
                        categoryDecisions.length,
                      ),
                    );
                  }),
                  const SizedBox(height: 32),
                  const Text(
                    'Energy Level and Success',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: CupertinoColors.black,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ...EmotionalState.values.map((state) {
                    final stateDecisions = withResults
                        .where((d) => d.emotionalState == state)
                        .toList();
                    
                    if (stateDecisions.isEmpty) return const SizedBox();

                    final avgRating = stateDecisions
                            .map((d) => d.resultRating!)
                            .reduce((a, b) => a + b) /
                        stateDecisions.length;

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _buildEmotionRatingCard(
                        state,
                        avgRating,
                        stateDecisions.length,
                      ),
                    );
                  }),
                  const SizedBox(height: 32),
                  const Text(
                    'Energy Level and Success',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: CupertinoColors.black,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ...List.generate(5, (index) {
                    final energyLevel = index + 1;
                    final energyDecisions = withResults
                        .where((d) => d.energyLevel == energyLevel)
                        .toList();
                    
                    if (energyDecisions.isEmpty) return const SizedBox();

                    final avgRating = energyDecisions
                            .map((d) => d.resultRating!)
                            .reduce((a, b) => a + b) /
                        energyDecisions.length;

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _buildEnergyRatingCard(
                        energyLevel,
                        avgRating,
                        energyDecisions.length,
                      ),
                    );
                  }),
                ],
              ),
            );
          },
          loading: () => const Center(child: CupertinoActivityIndicator()),
          error: (error, stack) => Center(child: Text('Error: $error')),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            CupertinoIcons.chart_bar,
            size: 80,
            color: CupertinoColors.systemGrey.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          const Text(
            'Insufficient Data',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: CupertinoColors.systemGrey,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Add decisions and evaluate results',
            style: TextStyle(
              fontSize: 15,
              color: CupertinoColors.systemGrey.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: CupertinoColors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 17,
              color: CupertinoColors.systemGrey,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryRatingCard(
      DecisionCategory category, double avgRating, int count) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: CupertinoColors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Text(category.emoji, style: const TextStyle(fontSize: 32)),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  category.displayName,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: CupertinoColors.black,
                  ),
                ),
                Text(
                  '$count decisions',
                  style: const TextStyle(
                    fontSize: 13,
                    color: CupertinoColors.systemGrey,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: _getRatingColor(avgRating.round()),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              avgRating.toStringAsFixed(1),
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: CupertinoColors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmotionRatingCard(
      EmotionalState state, double avgRating, int count) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: CupertinoColors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Text(state.emoji, style: const TextStyle(fontSize: 32)),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  state.displayName,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: CupertinoColors.black,
                  ),
                ),
                Text(
                  '$count decisions',
                  style: const TextStyle(
                    fontSize: 13,
                    color: CupertinoColors.systemGrey,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: _getRatingColor(avgRating.round()),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              avgRating.toStringAsFixed(1),
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: CupertinoColors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEnergyRatingCard(int level, double avgRating, int count) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: CupertinoColors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Text('⚡', style: TextStyle(fontSize: 32)),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Energy $level/5',
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: CupertinoColors.black,
                  ),
                ),
                Text(
                  '$count decisions',
                  style: const TextStyle(
                    fontSize: 13,
                    color: CupertinoColors.systemGrey,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: _getRatingColor(avgRating.round()),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              avgRating.toStringAsFixed(1),
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: CupertinoColors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getRatingColor(int rating) {
    if (rating >= 4) return CupertinoColors.systemGreen;
    if (rating >= 3) return CupertinoColors.systemOrange;
    return CupertinoColors.systemRed;
  }
}
