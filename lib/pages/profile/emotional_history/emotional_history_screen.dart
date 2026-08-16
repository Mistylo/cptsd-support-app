import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:cptsd_app/main.dart'; 
import 'package:cptsd_app/pages/inner_studio/inner_studio_models.dart';   
import 'package:cptsd_app/pages/inner_studio/inner_studio_provider.dart';  

// Defines lightweight models and providers used to present emotional history
// and practice statistics within the prototype interface.
class MoodInsight {
  final String topEmotion;
  final String leastEmotion;
  final String monthStartMood;
  final String monthEndMood;
  final Map<String, int> emotionCounts;

  const MoodInsight({
    required this.topEmotion,
    required this.leastEmotion,
    required this.monthStartMood,
    required this.monthEndMood,
    required this.emotionCounts,
  });
}

class ToolUsageItem {
  final String activityKey;
  final String displayName;
  final int count;

  const ToolUsageItem({
    required this.activityKey,
    required this.displayName,
    required this.count,
  });
}

class PracticeStats {
  final int totalPractices;
  final List<ToolUsageItem> topTools;

  const PracticeStats({
    required this.totalPractices,
    required this.topTools,
  });
}

// Supplies placeholder emotional summary data to demonstrate the intended
// monthly insight interface before analytics are fully implemented
final moodSummaryProvider = Provider<MoodInsight>((ref) {
  return const MoodInsight(
    topEmotion: 'Anxious',
    leastEmotion: 'Happy',
    monthStartMood: 'Overwhelmed',
    monthEndMood: 'Calm',
    emotionCounts: {
      'Anxious': 11,
      'Calm': 8,
      'Overwhelmed': 5,
      'Sad': 4,
      'Angry': 3,
      'Happy': 2,
    },
  );
});


// Retrieves recorded activity completion data from the local Isar database
// and prepares summary statistics for visual presentation
final practiceStatsProvider = FutureProvider<PracticeStats>((ref) async {
  final isar = ref.watch(isarProvider);
  final savedState = await isar.studioStateDatas.where().findFirst();

  if (savedState == null || savedState.completedActivityKeys.isEmpty) {
    return const PracticeStats(totalPractices: 0, topTools: []);
  }

  final keys = savedState.completedActivityKeys;
  final counts = savedState.completedActivityCounts;

  int totalPractices = 0;
  final List<ToolUsageItem> items = [];

  for (int i = 0; i < keys.length; i++) {
    final String key = keys[i];
    final int count = (i < counts.length) ? counts[i] : 0;
    
    totalPractices += count;

    if (count > 0) {
      items.add(
        ToolUsageItem(
          activityKey: key,
          displayName: _formatActivityTitle(key),
          count: count,
        ),
      );
    }
  }

  // Sort descending by usage count
  items.sort((a, b) => b.count.compareTo(a.count));

  // Extract top 5
  final top5 = items.take(5).toList();

  return PracticeStats(
    totalPractices: totalPractices,
    topTools: top5,
  );
});

/// Converts internal activity identifiers into titles for display
String _formatActivityTitle(String key) {
  switch (key) {
    case StudioNotifier.actGuidedBreathing:
      return 'Guided Breathing';
    case StudioNotifier.actMeditation:
      return 'Meditation';
    case StudioNotifier.actGrounding54321:
      return '5-4-3-2-1 Grounding';
    case StudioNotifier.actJournaling:
      return 'Journaling';
    case StudioNotifier.actReframeThought:
      return 'Reframe Thought';
    case StudioNotifier.actDecisionMaking:
      return 'Decision Making';
    case StudioNotifier.actWorryRelease:
      return 'Worry Release';
    case StudioNotifier.actInterpersonalSkills:
      return 'Interpersonal Skills';
    case StudioNotifier.actMoodTracker:
      return 'Mood Tracker';
    case StudioNotifier.actSosProtocol:
      return 'SOS Protocol';
    default:
      return key
          .replaceAll('_', ' ')
          .split(' ')
          .map((str) => str.isNotEmpty
              ? '${str[0].toUpperCase()}${str.substring(1)}'
              : '')
          .join(' ');
  }
}

// Displays a prototype dashboard combining emotional summaries and practice
// history to illustrate potential long term progress visualisation
class EmotionalHistoryScreen extends ConsumerWidget {
  const EmotionalHistoryScreen({super.key});
  static const Color backgroundColor = Color(0xFFF8F9FA);
  static const Color surfaceColor = Colors.white;
  static const Color lavenderAccent = Color(0xFF7C698D);
  static const Color lavenderLightBg = Color(0xFFF3EFEF);
  static const Color borderGray = Color(0xFFE9ECEF);
  static const Color textPrimary = Color(0xFF212529);
  static const Color textSecondary = Color(0xFF6C757D);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final moodData = ref.watch(moodSummaryProvider);
    final statsAsync = ref.watch(practiceStatsProvider);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: surfaceColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        iconTheme: const IconThemeData(color: textPrimary),
        title: const Text(
          'Emotional History & Progress',
          style: TextStyle(
            color: textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.3,
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(practiceStatsProvider);
        },
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          children: [
            // Displays the total number of completed self-help activities.
            statsAsync.when(
              data: (stats) => _ModernCard(
                backgroundColor: lavenderLightBg,
                borderColor: const Color(0xFFE5DEEC),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: lavenderAccent.withOpacity(0.12),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.self_improvement_rounded,
                        color: lavenderAccent,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Total Times Practiced',
                          style: TextStyle(
                            fontSize: 12,
                            color: textSecondary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${stats.totalPractices} sessions',
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: textPrimary,
                            letterSpacing: -0.5,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              loading: () => const _LoadingCard(height: 72),
              error: (_, __) => const SizedBox.shrink(),
            ),

            const SizedBox(height: 24),

            // Demonstrates how future emotional trends could be summarised using
            // aggregated mood tracking data.
            const _SectionHeader(title: '30-Day Mood Summary'),
            _ModernCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Summary narrative describing the user's emotional trends.
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F3F5),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      'Over the last 30 days, your primary felt emotion was ${moodData.topEmotion} (${moodData.emotionCounts[moodData.topEmotion]} times), while ${moodData.leastEmotion} was recorded least. You transitioned from feeling ${moodData.monthStartMood} early in the month toward feeling ${moodData.monthEndMood} recently.',
                      style: const TextStyle(
                        fontSize: 13,
                        color: textPrimary,
                        height: 1.45,
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),

                  const Text(
                    'Emotion Distribution',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: textSecondary,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Visual representation of emotion frequency distribution.
                  ...moodData.emotionCounts.entries.map((entry) {
                    final int maxCount = moodData.emotionCounts.values
                        .reduce((a, b) => a > b ? a : b);
                    final double percentage =
                        maxCount > 0 ? entry.value / maxCount : 0.0;

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                entry.key,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                '${entry.value} days',
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: textSecondary,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: percentage,
                              minHeight: 6,
                              backgroundColor: borderGray,
                              color: entry.key == moodData.topEmotion
                                  ? lavenderAccent
                                  : const Color(0xFFA89BB5),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Displays the five most frequently completed self-help exercises.
            const _SectionHeader(title: 'Most Used Tools (Top 5)'),
            statsAsync.when(
              data: (stats) {
                if (stats.topTools.isEmpty) {
                  return const _ModernCard(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Center(
                        child: Text(
                          'No practice tools logged yet. Complete exercises in the studio to view your top tools!',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 13, color: textSecondary),
                        ),
                      ),
                    ),
                  );
                }

                return _ModernCard(
                  child: Column(
                    children: stats.topTools.asMap().entries.map((entry) {
                      final int index = entry.key;
                      final ToolUsageItem tool = entry.value;

                      return Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Row(
                              children: [
                                // Rank Badge
                                Container(
                                  width: 26,
                                  height: 26,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: index == 0
                                        ? lavenderAccent
                                        : borderGray,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Text(
                                    '${index + 1}',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: index == 0
                                          ? Colors.white
                                          : textSecondary,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                // Tool Name
                                Expanded(
                                  child: Text(
                                    tool.displayName,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                      color: textPrimary,
                                    ),
                                  ),
                                ),
                                // Activity completion count
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: lavenderLightBg,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    '${tool.count} uses',
                                    style: const TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: lavenderAccent,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (index < stats.topTools.length - 1)
                            const Divider(height: 1, color: borderGray),
                        ],
                      );
                    }).toList(),
                  ),
                );
              },
              loading: () => const _LoadingCard(height: 180),
              error: (err, stack) => _ModernCard(
                child: Text(
                  'Failed to load practice history.',
                  style: TextStyle(color: Colors.red[300], fontSize: 13),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Supporting widgets used throughout the prototype to maintain a consistent
// visual layout and loading behaviour
class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 2, bottom: 10),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.2,
          color: Color(0xFF495057),
        ),
      ),
    );
  }
}

class _ModernCard extends StatelessWidget {
  final Widget child;
  final Color backgroundColor;
  final Color borderColor;

  const _ModernCard({
    Key? key,
    required this.child,
    this.backgroundColor = EmotionalHistoryScreen.surfaceColor,
    this.borderColor = EmotionalHistoryScreen.borderGray,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _LoadingCard extends StatelessWidget {
  final double height;

  const _LoadingCard({Key? key, required this.height}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: EmotionalHistoryScreen.borderGray),
      ),
      child: const Center(
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: EmotionalHistoryScreen.lavenderAccent,
        ),
      ),
    );
  }
}