import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:cptsd_app/pages/tools/theme_provider.dart'; 

// This proof of concept uses in-memory data only to demonstrate the
// scheduling workflow and user interaction.
// Persistent storage, notifications, and background scheduling would
// be required for a production implementation


// Represents the lifecycle state of a scheduled worry item.
// Scheduled items remain locked until their reflection time,
// while completed items are moved to the archive
enum WorryStatus { scheduled, ready, missed, completed }
// Temporary data structure used to demonstrate the worry scheduling workflow
// In the final implementation, this would be replaced by persistent storage
class DummyWorryItem {
  final String id;
  final String title;
  final String originalWorryText;
  final DateTime scheduledStartTime;
  final DateTime scheduledEndTime;
  final WorryStatus status;

  DummyWorryItem({
    required this.id,
    required this.title,
    required this.originalWorryText,
    required this.scheduledStartTime,
    required this.scheduledEndTime,
    required this.status,
  });

  DummyWorryItem copyWith({WorryStatus? status}) {
    return DummyWorryItem(
      id: id,
      title: title,
      originalWorryText: originalWorryText,
      scheduledStartTime: scheduledStartTime,
      scheduledEndTime: scheduledEndTime,
      status: status ?? this.status,
    );
  }
}

// Demonstration dataset used to simulate different scheduling states
final List<DummyWorryItem> _initialDummyWorries = [
  DummyWorryItem(
    id: '1',
    title: 'Project Deadline Concerns',
    originalWorryText: 'Feeling overwhelmed about delivering the final UI mockups on time.',
    scheduledStartTime: DateTime.now(),
    scheduledEndTime: DateTime.now().add(const Duration(minutes: 15)),
    status: WorryStatus.ready,
  ),
  DummyWorryItem(
    id: '2',
    title: 'Upcoming Performance Review',
    originalWorryText: 'Worrying if my recent contributions met team expectations.',
    scheduledStartTime: DateTime.now().add(const Duration(hours: 4)),
    scheduledEndTime: DateTime.now().add(const Duration(hours: 4, minutes: 15)),
    status: WorryStatus.scheduled,
  ),
  DummyWorryItem(
    id: '3',
    title: 'Weekend Social Event',
    originalWorryText: 'Anxious about small talk and social energy levels.',
    scheduledStartTime: DateTime.now().subtract(const Duration(hours: 5)),
    scheduledEndTime: DateTime.now().subtract(const Duration(hours: 4, minutes: 45)),
    status: WorryStatus.missed,
  ),
  DummyWorryItem(
    id: '4',
    title: 'Car Maintenance Expenses',
    originalWorryText: 'Budgeting for annual service checkup.',
    scheduledStartTime: DateTime.now().subtract(const Duration(days: 2)),
    scheduledEndTime: DateTime.now().subtract(const Duration(days: 2, minutes: -15)),
    status: WorryStatus.completed,
  ),
];

class WorryHubPage extends ConsumerStatefulWidget {
  const WorryHubPage({super.key});

  @override
  ConsumerState<WorryHubPage> createState() => _WorryHubPageState();
}

class _WorryHubPageState extends ConsumerState<WorryHubPage> {
  late List<DummyWorryItem> _worries;

  @override
  void initState() {
    super.initState();
    _worries = List.from(_initialDummyWorries);
  }

  void _markAsResolved(String id) {
    setState(() {
      final index = _worries.indexWhere((w) => w.id == id);
      if (index != -1) {
        _worries[index] = _worries[index].copyWith(status: WorryStatus.completed);
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Worry marked as resolved.')),
    );
  }

  void _addNewDummyWorry(String title, String details) {
    final newItem = DummyWorryItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title.isNotEmpty ? title : 'New Scheduled Worry',
      originalWorryText: details,
      scheduledStartTime: DateTime.now().add(const Duration(hours: 2)),
      scheduledEndTime: DateTime.now().add(const Duration(hours: 2, minutes: 15)),
      status: WorryStatus.scheduled,
    );
    setState(() {
      _worries.insert(0, newItem);
    });
  }

  @override
  Widget build(BuildContext context) {
    // Retrieve shared theme configuration to maintain visual consistency across different intervention modules
    final theme = ref.watch(appThemeProvider);

    final Color textColor = theme.foregroundColor;
    final Color subTextColor = theme.subtitleColor;
    final Color cardBgColor = theme.cardColor;
    final Color border = theme.isDarkMode ? Colors.white12 : Colors.black12;

    final activeWorries = _worries.where((w) => w.status != WorryStatus.completed).toList();
    final completedWorries = _worries.where((w) => w.status == WorryStatus.completed).toList();

    return Container(
      decoration: BoxDecoration(
        gradient: theme.backgroundGradient,
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          title: Text(
            'Worry Release',
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 16,
              color: theme.accentColor,
            ),
          ),
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.transparent,
          iconTheme: IconThemeData(color: theme.accentColor),
        ),
        body: SafeArea(
          child: RefreshIndicator(
            onRefresh: () async {
              await Future.delayed(const Duration(milliseconds: 500));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Dummy state refreshed')),
              );
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildIntroductoryHeader(theme, textColor),
                  const SizedBox(height: 24),

                  _buildActionButton(
                    theme: theme,
                    textColor: textColor,
                    subTextColor: subTextColor,
                    cardBgColor: cardBgColor,
                    borderColor: border,
                    title: 'Write & Schedule a Worry',
                    description: 'Capture a worry now and choose a dedicated time to reflect on it later.',
                    icon: Icons.edit_calendar_outlined,
                    onTap: () => _openCaptureBottomSheet(context, theme),
                  ),
                  const SizedBox(height: 16),

                  _buildReviewSummaryButton(
                    theme: theme,
                    activeWorries: activeWorries,
                    textColor: textColor,
                    subTextColor: subTextColor,
                    cardBgColor: cardBgColor,
                    borderColor: border,
                  ),
                  const SizedBox(height: 28),

                  Text(
                    'Scheduled Reflections',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.2,
                      color: theme.accentColor,
                    ),
                  ),
                  const SizedBox(height: 12),

                  if (activeWorries.isEmpty)
                    _buildEmptyState(subTextColor)
                  else
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: activeWorries.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final item = activeWorries[index];
                        return _buildWorryCard(
                          theme: theme,
                          item: item,
                          cardBgColor: cardBgColor,
                          textColor: textColor,
                          subTextColor: subTextColor,
                        );
                      },
                    ),

                  const SizedBox(height: 24),
                  Divider(color: theme.accentColor.withOpacity(0.2)),
                  const SizedBox(height: 12),

                  _buildArchivePanel(theme, completedWorries, subTextColor),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }


  Widget _buildIntroductoryHeader(var theme, Color textColor) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.accentHighlightColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: theme.accentColor.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.shield_moon_outlined, color: theme.accentColor, size: 24),
              const SizedBox(width: 10),
              Text(
                'Setting Boundaries with Rumination',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: theme.accentColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'When worries stay in our minds, they often become louder and harder to let go. This exercise helps you acknowledge your worries, set them aside for now, and return to them at a dedicated time.',
            style: TextStyle(fontSize: 13, height: 1.45, color: textColor),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required var theme,
    required Color textColor,
    required Color subTextColor,
    required Color cardBgColor,
    required Color borderColor,
    required String title,
    required String description,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: borderColor),
      ),
      color: cardBgColor,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: theme.accentHighlightColor,
                child: Icon(icon, color: theme.accentColor),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: textColor)),
                    const SizedBox(height: 4),
                    Text(description, style: TextStyle(fontSize: 12, color: subTextColor)),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: theme.accentColor.withOpacity(0.7)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReviewSummaryButton({
    required var theme,
    required List<DummyWorryItem> activeWorries,
    required Color textColor,
    required Color subTextColor,
    required Color cardBgColor,
    required Color borderColor,
  }) {
    final hasReady = activeWorries.any((w) => w.status == WorryStatus.ready);
    final readyWorry = activeWorries.firstWhere(
      (w) => w.status == WorryStatus.ready,
      orElse: () => activeWorries.isNotEmpty
          ? activeWorries.first
          : DummyWorryItem(
              id: '0',
              title: '',
              originalWorryText: '',
              scheduledStartTime: DateTime.now(),
              scheduledEndTime: DateTime.now(),
              status: WorryStatus.scheduled,
            ),
    );

    return _buildActionButton(
      theme: theme,
      textColor: textColor,
      subTextColor: subTextColor,
      cardBgColor: cardBgColor,
      borderColor: borderColor,
      title: 'Review Scheduled Worries',
      description: hasReady ? 'You have a session active right now.' : 'Return to your worries during your scheduled reflection time.',
      icon: Icons.psychology_outlined,
      onTap: () {
        if (hasReady && readyWorry.originalWorryText.isNotEmpty) {
          _openDummyReviewDialog(context, theme, readyWorry);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No active session ready. Worries unlock at their scheduled times.')),
          );
        }
      },
    );
  }

  Widget _buildWorryCard({
    required var theme,
    required DummyWorryItem item,
    required Color cardBgColor,
    required Color textColor,
    required Color subTextColor,
  }) {
    final isReady = item.status == WorryStatus.ready;
    final isMissed = item.status == WorryStatus.missed;
    final formatTime = '${DateFormat('jm').format(item.scheduledStartTime)}–${DateFormat('jm').format(item.scheduledEndTime)}';
    final formatDate = DateUtils.isSameDay(item.scheduledStartTime, DateTime.now()) ? 'Today' : 'Scheduled';

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: isReady ? theme.accentColor : theme.accentColor.withOpacity(0.2),
          width: isReady ? 1.5 : 1,
        ),
      ),
      color: cardBgColor,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('$formatDate $formatTime', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: theme.accentColor)),
                _buildStatusIndicator(theme, item),
              ],
            ),
            const SizedBox(height: 8),
            Text(item.title, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15, color: textColor)),
            if (isMissed) ...[
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => _markAsResolved(item.id),
                    child: Text('Mark Resolved', style: TextStyle(fontSize: 12, color: theme.accentColor)),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.accentColor,
                      foregroundColor: theme.buttonTextColor,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      textStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                    ),
                    onPressed: () => _openCaptureBottomSheet(context, theme, rescheduleItem: item),
                    child: const Text('Reschedule'),
                  ),
                ],
              )
            ]
          ],
        ),
      ),
    );
  }

  Widget _buildStatusIndicator(var theme, DummyWorryItem item) {
    switch (item.status) {
      case WorryStatus.ready:
        return const Row(
          children: [
            CircleAvatar(radius: 4, backgroundColor: Colors.green),
            SizedBox(width: 4),
            Text('Ready for Review', style: TextStyle(color: Colors.green, fontSize: 12, fontWeight: FontWeight.bold)),
          ],
        );
      case WorryStatus.missed:
        return const Row(
          children: [
            Icon(Icons.report_problem_outlined, size: 14, color: Colors.orange),
            SizedBox(width: 4),
            Text('Session Missed', style: TextStyle(color: Colors.orange, fontSize: 12)),
          ],
        );
      case WorryStatus.scheduled:
      default:
        return Row(
          children: [
            Icon(Icons.lock_outline, size: 13, color: theme.subtitleColor),
            const SizedBox(width: 4),
            Text('Locked', style: TextStyle(color: theme.subtitleColor, fontSize: 12)),
          ],
        );
    }
  }

  Widget _buildArchivePanel(var theme, List<DummyWorryItem> completed, Color subTextColor) {
    return InkWell(
      onTap: () {
        _openDummyArchiveDialog(context, theme, completed);
      },
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
        decoration: BoxDecoration(
          color: theme.accentHighlightColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Icon(Icons.archive_outlined, color: theme.accentColor),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Completed Reflections (${completed.length})',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: theme.accentColor),
                  ),
                  const SizedBox(height: 2),
                  Text('Tap to view resolved worry items.', style: TextStyle(fontSize: 11, color: subTextColor)),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 14, color: theme.accentColor.withOpacity(0.7)),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(Color subTextColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32.0),
      child: Center(
        child: Text('No scheduled reflections active.', style: TextStyle(color: subTextColor)),
      ),
    );
  }

  void _openCaptureBottomSheet(BuildContext context, var theme, {DummyWorryItem? rescheduleItem}) {
    final titleController = TextEditingController(text: rescheduleItem?.title ?? '');
    final detailsController = TextEditingController(text: rescheduleItem?.originalWorryText ?? '');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: theme.cardColor,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
          top: 20,
          left: 20,
          right: 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              rescheduleItem != null ? 'Reschedule Reflection' : 'Capture & Schedule Worry',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: theme.foregroundColor),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: titleController,
              style: TextStyle(color: theme.foregroundColor),
              decoration: InputDecoration(
                labelText: 'Worry Title',
                labelStyle: TextStyle(color: theme.subtitleColor),
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: detailsController,
              maxLines: 3,
              style: TextStyle(color: theme.foregroundColor),
              decoration: InputDecoration(
                labelText: 'Worry Details (optional)',
                labelStyle: TextStyle(color: theme.subtitleColor),
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.accentColor,
                foregroundColor: theme.buttonTextColor,
                minimumSize: const Size.fromHeight(48),
              ),
              onPressed: () {
                if (rescheduleItem != null) {
                  _markAsResolved(rescheduleItem.id);
                }
                _addNewDummyWorry(titleController.text, detailsController.text);
                Navigator.pop(ctx);
              },
              child: Text(rescheduleItem != null ? 'Confirm Reschedule' : 'Save & Lock Schedule'),
            ),
          ],
        ),
      ),
    );
  }

  void _openDummyReviewDialog(BuildContext context, var theme, DummyWorryItem item) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: theme.cardColor,
        title: Text('Active Review Session', style: TextStyle(color: theme.foregroundColor)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(item.title, style: TextStyle(fontWeight: FontWeight.bold, color: theme.accentColor)),
            const SizedBox(height: 8),
            Text(item.originalWorryText, style: TextStyle(color: theme.foregroundColor)),
            const SizedBox(height: 16),
            Text('Reflection Steps (PoC Placeholder):', style: TextStyle(fontSize: 12, color: theme.subtitleColor)),
            const Text('• Can you take action on this right now?\n• What is the worst-case scenario?\n• How likely is it?'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Close', style: TextStyle(color: theme.subtitleColor)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: theme.accentColor, foregroundColor: theme.buttonTextColor),
            onPressed: () {
              _markAsResolved(item.id);
              Navigator.pop(ctx);
            },
            child: const Text('Complete Session'),
          ),
        ],
      ),
    );
  }

  void _openDummyArchiveDialog(BuildContext context, var theme, List<DummyWorryItem> completed) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: theme.cardColor,
        title: Text('Completed Reflections', style: TextStyle(color: theme.foregroundColor)),
        content: SizedBox(
          width: double.maxFinite,
          child: completed.isEmpty
              ? Text('No completed reflections yet.', style: TextStyle(color: theme.subtitleColor))
              : ListView.builder(
                  shrinkWrap: true,
                  itemCount: completed.length,
                  itemBuilder: (_, index) => ListTile(
                    dense: true,
                    leading: const Icon(Icons.check_circle_outline, color: Colors.green),
                    title: Text(completed[index].title, style: TextStyle(color: theme.foregroundColor)),
                  ),
                ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Close', style: TextStyle(color: theme.accentColor)),
          ),
        ],
      ),
    );
  }
}