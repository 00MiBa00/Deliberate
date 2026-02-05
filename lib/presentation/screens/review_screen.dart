import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/decision.dart';
import '../providers/decision_provider.dart';
import 'decision_details_screen.dart';

class ReviewScreen extends ConsumerWidget {
  const ReviewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final decisionsWithoutResults = ref.watch(decisionsWithoutResultsProvider);

    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Review Decisions'),
      ),
      child: SafeArea(
        child: decisionsWithoutResults.isEmpty
            ? _buildEmptyState()
            : SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: CupertinoColors.systemOrange.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: CupertinoColors.systemOrange,
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            CupertinoIcons.info_circle_fill,
                            color: CupertinoColors.systemOrange,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'You have ${decisionsWithoutResults.length} decision${decisionsWithoutResults.length != 1 ? 's' : ''} without results',
                              style: const TextStyle(
                                fontSize: 15,
                                color: CupertinoColors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Decisions to Evaluate',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: CupertinoColors.black,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ...decisionsWithoutResults.map((decision) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _buildReviewCard(context, decision),
                      );
                    }),
                  ],
                ),
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
            CupertinoIcons.check_mark_circled_solid,
            size: 80,
            color: CupertinoColors.systemGreen.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          const Text(
            'All Evaluated!',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: CupertinoColors.systemGrey,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'You have no decisions awaiting evaluation',
            style: TextStyle(
              fontSize: 15,
              color: CupertinoColors.systemGrey.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewCard(BuildContext context, Decision decision) {
    final daysSince = DateTime.now().difference(decision.createdAt).inDays;
    
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: () {
        Navigator.of(context).push(
          CupertinoPageRoute(
            builder: (context) => DecisionDetailsScreen(decision: decision),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: CupertinoColors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  decision.category.emoji,
                  style: const TextStyle(fontSize: 32),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        decision.goal,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          color: CupertinoColors.black,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '$daysSince day${daysSince != 1 ? 's' : ''} ago',
                        style: const TextStyle(
                          fontSize: 13,
                          color: CupertinoColors.systemGrey,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  CupertinoIcons.chevron_right,
                  color: CupertinoColors.systemGrey,
                  size: 20,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: CupertinoColors.systemGrey6,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Expected Result:',
                    style: TextStyle(
                      fontSize: 13,
                      color: CupertinoColors.systemGrey,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    decision.expectedResult,
                    style: const TextStyle(
                      fontSize: 15,
                      color: CupertinoColors.black,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
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
