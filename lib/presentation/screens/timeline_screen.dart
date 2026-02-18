import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/decision_provider.dart';
import '../../domain/models/decision.dart';
import 'add_decision/add_decision_screen.dart';
import 'decision_details_screen.dart';
import 'analytics_screen.dart';
import 'review_screen.dart';

class TimelineScreen extends ConsumerStatefulWidget {
  const TimelineScreen({super.key});

  @override
  ConsumerState<TimelineScreen> createState() => _TimelineScreenState();
}

class _TimelineScreenState extends ConsumerState<TimelineScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final decisionsAsync = ref.watch(allDecisionsProvider);
    final selectedCategory = ref.watch(selectedCategoryProvider);

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        backgroundColor: CupertinoColors.white.withOpacity(0.95),
        border: null,
        middle: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF007AFF), Color(0xFF5AC8FA)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                CupertinoIcons.compass_fill,
                color: CupertinoColors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 10),
            const Text(
              'Deliberate',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
          ],
        ),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () => _showMenu(context),
          child: const Icon(CupertinoIcons.ellipsis_circle),
        ),
      ),
      child: Stack(
        children: [
          SafeArea(
            child: Column(
              children: [
                _buildCategoryFilter(),
                Expanded(
                  child: decisionsAsync.when(
                    data: (decisions) {
                      final filtered = selectedCategory == null
                          ? decisions
                          : decisions
                                .where((d) => d.category == selectedCategory)
                                .toList();

                      return CustomScrollView(
                        controller: _scrollController,
                        physics: const AlwaysScrollableScrollPhysics(),
                        slivers: [
                          CupertinoSliverRefreshControl(
                            onRefresh: () async {
                              ref.invalidate(allDecisionsProvider);
                              await Future.delayed(
                                const Duration(milliseconds: 500),
                              );
                            },
                          ),
                          if (decisions.isNotEmpty)
                            SliverToBoxAdapter(
                              child: _buildStatsHeader(decisions),
                            ),
                          SliverToBoxAdapter(child: _buildQuickActionsWidget()),
                          SliverToBoxAdapter(child: _buildDailyQuoteWidget()),
                          if (decisions.isNotEmpty) ...[
                            SliverToBoxAdapter(
                              child: _buildAchievementsWidget(decisions),
                            ),
                            SliverToBoxAdapter(
                              child: _buildCategoriesOverviewWidget(decisions),
                            ),
                            SliverToBoxAdapter(
                              child: _buildPendingReviewsWidget(decisions),
                            ),
                          ],
                          if (filtered.isEmpty)
                            SliverFillRemaining(
                              child: _buildEmptyStateInline(selectedCategory),
                            )
                          else
                            SliverToBoxAdapter(
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(
                                  16,
                                  16,
                                  16,
                                  8,
                                ),
                                child: Text(
                                  'Recent Decisions',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: CupertinoColors.black,
                                  ),
                                ),
                              ),
                            ),
                          if (filtered.isNotEmpty)
                            SliverPadding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              sliver: SliverList(
                                delegate: SliverChildBuilderDelegate((
                                  context,
                                  index,
                                ) {
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 12),
                                    child: _DecisionCardEnhanced(
                                      decision: filtered[index],
                                    ),
                                  );
                                }, childCount: filtered.length),
                              ),
                            ),
                          const SliverPadding(
                            padding: EdgeInsets.only(bottom: 80),
                          ),
                        ],
                      );
                    },
                    loading: () =>
                        const Center(child: CupertinoActivityIndicator()),
                    error: (error, stack) =>
                        Center(child: Text('Error: $error')),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            right: 16,
            bottom: 16,
            child: Hero(
              tag: 'add_decision_fab',
              child: CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: () => _navigateToAddDecision(context),
                child: Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF007AFF), Color(0xFF5AC8FA)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: CupertinoColors.activeBlue.withOpacity(0.4),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: const Icon(
                    CupertinoIcons.add,
                    color: CupertinoColors.white,
                    size: 32,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsHeader(List<Decision> decisions) {
    final withResults = decisions.where((d) => d.hasResult).length;
    final avgRating = decisions.where((d) => d.hasResult).isEmpty
        ? 0.0
        : decisions
                  .where((d) => d.hasResult)
                  .map((d) => d.resultRating!)
                  .reduce((a, b) => a + b) /
              withResults;

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            CupertinoColors.activeBlue.withOpacity(0.1),
            CupertinoColors.systemPurple.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: CupertinoColors.activeBlue.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildStatItem(
              icon: CupertinoIcons.doc_text_fill,
              value: '${decisions.length}',
              label: 'Total',
              color: CupertinoColors.activeBlue,
            ),
          ),
          Container(width: 1, height: 40, color: CupertinoColors.systemGrey5),
          Expanded(
            child: _buildStatItem(
              icon: CupertinoIcons.checkmark_seal_fill,
              value: '$withResults',
              label: 'Reviewed',
              color: CupertinoColors.systemGreen,
            ),
          ),
          Container(width: 1, height: 40, color: CupertinoColors.systemGrey5),
          Expanded(
            child: _buildStatItem(
              icon: CupertinoIcons.star_fill,
              value: avgRating > 0 ? avgRating.toStringAsFixed(1) : '-',
              label: 'Avg Rating',
              color: CupertinoColors.systemOrange,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
  }) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: CupertinoColors.black,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: CupertinoColors.systemGrey,
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryFilter() {
    final selectedCategory = ref.watch(selectedCategoryProvider);

    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          _buildFilterChip('All', null, selectedCategory == null),
          ...DecisionCategory.values.map(
            (category) => _buildFilterChip(
              category.emoji,
              category,
              selectedCategory == category,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(
    String label,
    DecisionCategory? category,
    bool isSelected,
  ) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: CupertinoButton(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        minSize: 0,
        onPressed: () =>
            ref.read(selectedCategoryProvider.notifier).state = category,
        color: isSelected
            ? CupertinoColors.activeBlue
            : CupertinoColors.systemGrey5,
        borderRadius: BorderRadius.circular(20),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 15,
            color: isSelected ? CupertinoColors.white : CupertinoColors.black,
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    final selectedCategory = ref.watch(selectedCategoryProvider);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    CupertinoColors.activeBlue.withOpacity(0.2),
                    CupertinoColors.systemPurple.withOpacity(0.1),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
              ),
              child: Icon(
                selectedCategory == null
                    ? CupertinoIcons.lightbulb_fill
                    : CupertinoIcons.search,
                size: 60,
                color: CupertinoColors.activeBlue.withOpacity(0.6),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              selectedCategory == null ? 'Start Your Journey' : 'No Decisions',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: CupertinoColors.black,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              selectedCategory == null
                  ? 'Make better decisions by tracking and analyzing your choices'
                  : 'No decisions in this category yet',
              style: const TextStyle(
                fontSize: 16,
                color: CupertinoColors.systemGrey,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            CupertinoButton(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              color: CupertinoColors.activeBlue,
              borderRadius: BorderRadius.circular(25),
              onPressed: () => _navigateToAddDecision(context),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(
                    CupertinoIcons.add_circled_solid,
                    color: CupertinoColors.white,
                    size: 20,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Add Decision',
                    style: TextStyle(
                      color: CupertinoColors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
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

  Widget _buildEmptyStateInline(DecisionCategory? selectedCategory) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    CupertinoColors.activeBlue.withOpacity(0.2),
                    CupertinoColors.systemPurple.withOpacity(0.1),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
              ),
              child: Icon(
                selectedCategory == null
                    ? CupertinoIcons.lightbulb_fill
                    : CupertinoIcons.search,
                size: 40,
                color: CupertinoColors.activeBlue.withOpacity(0.6),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              selectedCategory == null
                  ? 'Start Your Journey'
                  : 'No Decisions in ${selectedCategory.displayName}',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: CupertinoColors.black,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            Text(
              selectedCategory == null
                  ? 'Make better decisions by tracking and analyzing your choices'
                  : 'No decisions in this category yet',
              style: const TextStyle(
                fontSize: 14,
                color: CupertinoColors.systemGrey,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 20),
            CupertinoButton(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              color: CupertinoColors.activeBlue,
              borderRadius: BorderRadius.circular(25),
              onPressed: () => _navigateToAddDecision(context),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(
                    CupertinoIcons.add_circled_solid,
                    color: CupertinoColors.white,
                    size: 18,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Add Decision',
                    style: TextStyle(
                      color: CupertinoColors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
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

  void _navigateToAddDecision(BuildContext context) {
    Navigator.of(
      context,
    ).push(CupertinoPageRoute(builder: (context) => const AddDecisionScreen()));
  }

  void _showMenu(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        actions: [
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context) => const AnalyticsScreen(),
                ),
              );
            },
            child: const Text('Analytics'),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                CupertinoPageRoute(builder: (context) => const ReviewScreen()),
              );
            },
            child: const Text('Review Decisions'),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          isDefaultAction: true,
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
      ),
    );
  }

  // New widget methods
  Widget _buildQuickActionsWidget() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(bottom: 12),
            child: Text(
              'Quick Actions',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: CupertinoColors.black,
              ),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: _buildActionCard(
                  icon: CupertinoIcons.add_circled_solid,
                  title: 'New Decision',
                  color: CupertinoColors.activeBlue,
                  onTap: () => _navigateToAddDecision(context),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildActionCard(
                  icon: CupertinoIcons.chart_bar_square_fill,
                  title: 'Analytics',
                  color: CupertinoColors.systemPurple,
                  onTap: () => Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) => const AnalyticsScreen(),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildActionCard(
                  icon: CupertinoIcons.checkmark_seal_fill,
                  title: 'Review',
                  color: CupertinoColors.systemGreen,
                  onTap: () => Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) => const ReviewScreen(),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildActionCard(
                  icon: CupertinoIcons.clock_fill,
                  title: 'Timeline',
                  color: CupertinoColors.systemOrange,
                  onTap: () => _scrollController.animateTo(
                    _scrollController.position.maxScrollExtent,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard({
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color.withOpacity(0.15), color.withOpacity(0.05)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.3), width: 1.5),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [color, color.withOpacity(0.8)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: color.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(icon, color: CupertinoColors.white, size: 24),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: CupertinoColors.black,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 32),
            CupertinoButton(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              color: CupertinoColors.activeBlue,
              borderRadius: BorderRadius.circular(25),
              onPressed: () => _navigateToAddDecision(context),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(
                    CupertinoIcons.add_circled_solid,
                    color: CupertinoColors.white,
                  ),
                  SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      'Add First Decision',
                      style: TextStyle(
                        color: CupertinoColors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
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

  Widget _buildDailyQuoteWidget() {
    final quotes = [
      {'text': 'Every decision shapes your future.', 'author': 'Deliberate'},
      {'text': 'Reflect on choices, grow from outcomes.', 'author': 'Wisdom'},
      {
        'text': 'The quality of your life is the quality of your decisions.',
        'author': 'Tony Robbins',
      },
      {
        'text':
            'In any moment of decision, the best thing you can do is the right thing.',
        'author': 'Theodore Roosevelt',
      },
      {
        'text':
            'Good decisions come from experience, and experience comes from bad decisions.',
        'author': 'Mark Twain',
      },
    ];

    final now = DateTime.now();
    final dayOfYear = now.difference(DateTime(now.year, 1, 1)).inDays;
    final quote = quotes[dayOfYear % quotes.length];

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF667EEA).withOpacity(0.3),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: CupertinoColors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  CupertinoIcons.lightbulb_fill,
                  color: CupertinoColors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 10),
              const Flexible(
                child: Text(
                  'Daily Inspiration',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: CupertinoColors.white,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            '"${quote['text']}"',
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w500,
              color: CupertinoColors.white,
              height: 1.5,
              fontStyle: FontStyle.italic,
            ),
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 12),
          Text(
            '— ${quote['author']}',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: CupertinoColors.white.withOpacity(0.8),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementsWidget(List<Decision> decisions) {
    final totalDecisions = decisions.length;
    final reviewedCount = decisions.where((d) => d.hasResult).length;
    final highRatingCount = decisions
        .where((d) => d.hasResult && d.resultRating! >= 4)
        .length;
    final weekStreak = _calculateWeekStreak(decisions);

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(bottom: 12),
            child: Text(
              'Achievements',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: CupertinoColors.black,
              ),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: _buildAchievementCard(
                  icon: CupertinoIcons.flame_fill,
                  value: '$weekStreak',
                  label: 'Week Streak',
                  color: CupertinoColors.systemOrange,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildAchievementCard(
                  icon: CupertinoIcons.star_fill,
                  value: '$highRatingCount',
                  label: 'Great Choices',
                  color: CupertinoColors.systemYellow,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildProgressCard(
            title: 'Review Progress',
            current: reviewedCount,
            total: totalDecisions,
            color: CupertinoColors.systemGreen,
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementCard({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: CupertinoColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: CupertinoColors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [color, color.withOpacity(0.7)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: CupertinoColors.white, size: 28),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: CupertinoColors.black,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              color: CupertinoColors.systemGrey,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildProgressCard({
    required String title,
    required int current,
    required int total,
    required Color color,
  }) {
    final progress = total > 0 ? current / total : 0.0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: CupertinoColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: CupertinoColors.systemGrey5, width: 1),
        boxShadow: [
          BoxShadow(
            color: CupertinoColors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: CupertinoColors.black,
                ),
              ),
              Text(
                '$current/$total',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Container(
              height: 10,
              decoration: BoxDecoration(
                color: CupertinoColors.systemGrey5,
                borderRadius: BorderRadius.circular(8),
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: progress,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [color, color.withOpacity(0.7)],
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoriesOverviewWidget(List<Decision> decisions) {
    final categoryCounts = <DecisionCategory, int>{};
    for (var decision in decisions) {
      categoryCounts[decision.category] =
          (categoryCounts[decision.category] ?? 0) + 1;
    }

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(bottom: 12),
            child: Text(
              'Categories',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: CupertinoColors.black,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: CupertinoColors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: CupertinoColors.systemGrey5, width: 1),
              boxShadow: [
                BoxShadow(
                  color: CupertinoColors.black.withOpacity(0.03),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: DecisionCategory.values.map((category) {
                final count = categoryCounts[category] ?? 0;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _buildCategoryRow(category, count, decisions.length),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryRow(DecisionCategory category, int count, int total) {
    final percentage = total > 0
        ? (count / total * 100).toStringAsFixed(0)
        : '0';

    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: () {
        ref.read(selectedCategoryProvider.notifier).state = category;
        _scrollController.animateTo(
          0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      },
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  _getCategoryColor(category).withOpacity(0.2),
                  _getCategoryColor(category).withOpacity(0.1),
                ],
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(category.emoji, style: const TextStyle(fontSize: 20)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  category.displayName,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: CupertinoColors.black,
                  ),
                ),
                const SizedBox(height: 2),
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
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: _getCategoryColor(category).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '$percentage%',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: _getCategoryColor(category),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Icon(
            CupertinoIcons.chevron_right,
            size: 16,
            color: CupertinoColors.systemGrey,
          ),
        ],
      ),
    );
  }

  Widget _buildPendingReviewsWidget(List<Decision> decisions) {
    final pendingReviews = decisions.where((d) => !d.hasResult).toList();

    if (pendingReviews.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Flexible(
                child: Text(
                  'Pending Reviews',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: CupertinoColors.black,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFF6B6B), Color(0xFFEE5A6F)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${pendingReviews.length}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: CupertinoColors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  CupertinoColors.systemOrange.withOpacity(0.1),
                  CupertinoColors.systemRed.withOpacity(0.05),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: CupertinoColors.systemOrange.withOpacity(0.3),
                width: 1.5,
              ),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            CupertinoColors.systemOrange,
                            Color(0xFFFF6B35),
                          ],
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        CupertinoIcons.exclamationmark,
                        color: CupertinoColors.white,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Decisions awaiting review',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: CupertinoColors.black,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Review your decisions to learn and improve',
                            style: TextStyle(
                              fontSize: 13,
                              color: CupertinoColors.systemGrey.withOpacity(
                                0.8,
                              ),
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                CupertinoButton(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  color: CupertinoColors.systemOrange,
                  borderRadius: BorderRadius.circular(12),
                  onPressed: () => Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) => const ReviewScreen(),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(CupertinoIcons.checkmark_circle_fill, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'Review Now',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  int _calculateWeekStreak(List<Decision> decisions) {
    if (decisions.isEmpty) return 0;

    final sortedDecisions = List<Decision>.from(decisions)
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

    int streak = 0;
    DateTime checkDate = DateTime.now();

    for (int week = 0; week < 52; week++) {
      final weekStart = checkDate.subtract(
        Duration(days: checkDate.weekday - 1),
      );
      final weekEnd = weekStart.add(const Duration(days: 6));

      final hasDecisionThisWeek = sortedDecisions.any(
        (decision) =>
            decision.createdAt.isAfter(weekStart) &&
            decision.createdAt.isBefore(weekEnd.add(const Duration(days: 1))),
      );

      if (hasDecisionThisWeek) {
        streak++;
        checkDate = weekStart.subtract(const Duration(days: 1));
      } else {
        break;
      }
    }

    return streak;
  }

  Color _getCategoryColor(DecisionCategory category) {
    switch (category) {
      case DecisionCategory.work:
        return CupertinoColors.activeBlue;
      case DecisionCategory.money:
        return CupertinoColors.systemGreen;
      case DecisionCategory.relationships:
        return CupertinoColors.systemPink;
      case DecisionCategory.health:
        return CupertinoColors.systemRed;
      case DecisionCategory.other:
        return CupertinoColors.systemPurple;
    }
  }
}

class _DecisionCardEnhanced extends ConsumerWidget {
  final Decision decision;

  const _DecisionCardEnhanced({required this.decision});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: CupertinoColors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: CupertinoColors.systemGrey5, width: 1),
          boxShadow: [
            BoxShadow(
              color: CupertinoColors.black.withOpacity(0.03),
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
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        _getCategoryColor(decision.category).withOpacity(0.2),
                        _getCategoryColor(decision.category).withOpacity(0.1),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      decision.category.emoji,
                      style: const TextStyle(fontSize: 28),
                    ),
                  ),
                ),
                const SizedBox(width: 14),
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
                          height: 1.3,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(
                            CupertinoIcons.time,
                            size: 12,
                            color: CupertinoColors.systemGrey.withOpacity(0.8),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            _formatDate(decision.createdAt),
                            style: TextStyle(
                              fontSize: 13,
                              color: CupertinoColors.systemGrey.withOpacity(
                                0.8,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                if (decision.hasResult)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          _getRatingColor(decision.resultRating!),
                          _getRatingColor(
                            decision.resultRating!,
                          ).withOpacity(0.8),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: _getRatingColor(
                            decision.resultRating!,
                          ).withOpacity(0.3),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          CupertinoIcons.star_fill,
                          size: 12,
                          color: CupertinoColors.white,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${decision.resultRating}',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: CupertinoColors.white,
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: CupertinoColors.systemOrange.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: CupertinoColors.systemOrange.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: const Icon(
                      CupertinoIcons.clock,
                      size: 14,
                      color: CupertinoColors.systemOrange,
                    ),
                  ),
              ],
            ),
            if (decision.description.isNotEmpty) ...[
              const SizedBox(height: 14),
              Text(
                decision.description,
                style: const TextStyle(
                  fontSize: 15,
                  color: CupertinoColors.systemGrey,
                  height: 1.4,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
            const SizedBox(height: 14),
            Row(
              children: [
                _buildEnhancedTag(
                  decision.emotionalState.emoji,
                  decision.emotionalState.displayName,
                ),
                const SizedBox(width: 8),
                _buildEnhancedTag(
                  decision.context.emoji,
                  decision.context.displayName,
                ),
                const SizedBox(width: 8),
                _buildEnhancedTag('⚡', '${decision.energyLevel}/5'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEnhancedTag(String emoji, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: CupertinoColors.systemGrey6,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: CupertinoColors.systemGrey5, width: 0.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 12)),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: CupertinoColors.systemGrey,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Color _getCategoryColor(DecisionCategory category) {
    switch (category) {
      case DecisionCategory.work:
        return CupertinoColors.activeBlue;
      case DecisionCategory.money:
        return CupertinoColors.systemGreen;
      case DecisionCategory.relationships:
        return CupertinoColors.systemPink;
      case DecisionCategory.health:
        return CupertinoColors.systemRed;
      case DecisionCategory.other:
        return CupertinoColors.systemPurple;
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Today ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return '$weeks ${weeks == 1 ? 'week' : 'weeks'} ago';
    } else {
      return '${date.day}.${date.month}.${date.year}';
    }
  }

  Color _getRatingColor(int rating) {
    if (rating >= 4) return CupertinoColors.systemGreen;
    if (rating >= 3) return CupertinoColors.systemOrange;
    return CupertinoColors.systemRed;
  }
}

class DecisionCard extends ConsumerWidget {
  final Decision decision;

  const DecisionCard({super.key, required this.decision});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
          border: Border.all(color: CupertinoColors.systemGrey5, width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  decision.category.emoji,
                  style: const TextStyle(fontSize: 24),
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
                        _formatDate(decision.createdAt),
                        style: const TextStyle(
                          fontSize: 13,
                          color: CupertinoColors.systemGrey,
                        ),
                      ),
                    ],
                  ),
                ),
                if (decision.hasResult)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: _getRatingColor(decision.resultRating!),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '${decision.resultRating}/5',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: CupertinoColors.white,
                      ),
                    ),
                  ),
              ],
            ),
            if (decision.description.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(
                decision.description,
                style: const TextStyle(
                  fontSize: 15,
                  color: CupertinoColors.systemGrey,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
            const SizedBox(height: 12),
            Row(
              children: [
                _buildTag(decision.emotionalState.emoji),
                const SizedBox(width: 8),
                _buildTag(decision.context.emoji),
                const SizedBox(width: 8),
                _buildTag('⚡ ${decision.energyLevel}'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTag(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: CupertinoColors.systemGrey6,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 12, color: CupertinoColors.systemGrey),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Today ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
    } else if (difference.inDays == 1) {
      return 'Yesterday ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${date.day}.${date.month}.${date.year}';
    }
  }

  Color _getRatingColor(int rating) {
    if (rating >= 4) return CupertinoColors.systemGreen;
    if (rating >= 3) return CupertinoColors.systemOrange;
    return CupertinoColors.systemRed;
  }
}
