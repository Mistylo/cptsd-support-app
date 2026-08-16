import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:cptsd_app/resources.dart';
import 'package:cptsd_app/pages/sos_function/sos_protocol_page.dart';

class MoodTrackerPage extends StatefulWidget {
  // Receive the current app theme from the previous page
  // so the mood tracker can keep the same visual style
  final dynamic currentTheme; 

  const MoodTrackerPage({super.key, this.currentTheme});

  @override
  State<MoodTrackerPage> createState() => _MoodTrackerPageState();
}

class _MoodTrackerPageState extends State<MoodTrackerPage> {
  // Used to control whether the user sees the mood input page
  // or the mood history calendar after recording today's mood
  bool _hasRecordedToday = false;
   // Store the currently selected mood before saving.
  String? _selectedMood;
  // Controller for the optional user reflection note
  final TextEditingController _noteController = TextEditingController();

  // Temporary local mood history data used for prototype demonstration.
  // This simulates previous user records before database integration.
  final Map<DateTime, Map<String, String>> _history = {
    DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day - 1): {
      'emoji': '🙂',
      'label': 'Happy',
      'note': 'Had a peaceful walk and caught up on my coding work.'
    },
    DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day - 2): {
      'emoji': '😟',
      'label': 'Anxious',
      'note': 'Felt overwhelmed by deadlines in the afternoon.'
    },
  };

  @override
  void dispose() {
    // Release the text controller when the page is removed
    _noteController.dispose();
    super.dispose();
  }

  // Convert DateTime objects into date-only format.
  // This avoids comparing different timestamps for the same calendar day
  DateTime _normalizeDate(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  @override
  Widget build(BuildContext context) {
    // Retrieve theme colors from the main application theme.
    // Default values are provided for standalone testing
    final topBgColor = widget.currentTheme?.topColor ?? const Color(0xFFF5F5F5);
    final bottomBgColor = widget.currentTheme?.bottomColor ?? Colors.white;
    final accentColor = widget.currentTheme?.accentColor ?? const Color(0xFF757575);

    final isMidnight = (topBgColor.computeLuminance() < 0.5);
    
    final primaryTextColor = isMidnight ? Colors.white : Colors.black87;
    final secondaryTextColor = isMidnight ? Colors.white70 : Colors.black54;
    final contentCardBg = isMidnight ? const Color(0xFF1E1E1E) : Colors.white.withOpacity(0.9);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: _buildAppBar(context, primaryTextColor), 
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [topBgColor, bottomBgColor],
          ),
        ),
        child: SafeArea(
          // Show mood selection for first time entry,
          // otherwise display the calendar history view
          child: _hasRecordedToday 
              ? _buildCalendarView(primaryTextColor, secondaryTextColor, accentColor, contentCardBg) 
              : _buildMoodSelectionView(primaryTextColor, secondaryTextColor, accentColor),
        ),
      ),
    );
  }

  // Builds the top navigation bar containing close button
  // and quick access to the SOS emergency protocol
  PreferredSizeWidget _buildAppBar(BuildContext context, Color textColor) {
    return AppBar(
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.close, color: textColor),
        onPressed: () => Navigator.pop(context),
      ),
      title: IconButton(
        icon: SvgPicture.asset(AppIcons.sos, width: 36),
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const SOSProtocolPage())),
      ),
      centerTitle: true,
      actions: const [
        SizedBox(width: 8),
      ],
    );
  }

  // Displays available mood options and allows users
  // to optionally add a short reflection note
  Widget _buildMoodSelectionView(Color textColor, Color subTextColor, Color accentColor) {
    final moods = [
      {'label': 'Anxious', 'emoji': '😟'},
      {'label': 'Calm', 'emoji': '😌'},
      {'label': 'Sad', 'emoji': '😢'},
      {'label': 'Angry', 'emoji': '😡'},
      {'label': 'Happy', 'emoji': '🙂'},
      {'label': 'Overwhelmed', 'emoji': '😵‍💫'},
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            "How are you feeling today?",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: textColor),
          ),
          const SizedBox(height: 32),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 1.0, 
            ),
            itemCount: moods.length,
            itemBuilder: (context, index) {
              final mood = moods[index];
              final isSelected = _selectedMood == mood['emoji'];
              return GestureDetector(
                onTap: () => setState(() => _selectedMood = mood['emoji']),
                child: Container(
                  decoration: BoxDecoration(
                    color: isSelected ? accentColor.withOpacity(0.2) : textColor.withOpacity(0.04),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isSelected ? accentColor : textColor.withOpacity(0.1),
                      width: isSelected ? 1.5 : 1,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(mood['emoji']!, style: const TextStyle(fontSize: 32)),
                      const SizedBox(height: 6),
                      Text(
                        mood['label']!,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          color: isSelected ? accentColor : textColor,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 32),
          TextField(
            controller: _noteController,
            maxLines: 3,
            style: TextStyle(color: textColor),
            decoration: InputDecoration(
              hintText: "What's on your mind? (Optional)",
              hintStyle: TextStyle(color: subTextColor.withOpacity(0.6)),
              filled: true,
              fillColor: textColor.withOpacity(0.04),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: textColor.withOpacity(0.1)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: textColor.withOpacity(0.1)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: accentColor),
              ),
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: accentColor,
              foregroundColor: accentColor.computeLuminance() > 0.5 ? Colors.black87 : Colors.white,
              disabledBackgroundColor: textColor.withOpacity(0.12),
              disabledForegroundColor: subTextColor,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 0,
            ),
            onPressed: _selectedMood == null
                ? null
                : () {
                    setState(() {
                      _hasRecordedToday = true;
                      final todayNormalized = _normalizeDate(DateTime.now());
                      final label = moods.firstWhere((element) => element['emoji'] == _selectedMood)['label'] ?? '';
                      
                      _history[todayNormalized] = {
                        'emoji': _selectedMood!,
                        'label': label,
                        'note': _noteController.text.trim(),
                      };
                    });
                  },
            child: const Text("Save Record", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarView(Color textColor, Color subTextColor, Color accentColor, Color containerBg) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            "Your Mood History",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: textColor),
          ),
          const SizedBox(height: 20),
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: textColor.withOpacity(0.1)),
            ),
            color: containerBg, 
            surfaceTintColor: Colors.transparent,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TableCalendar(
                firstDay: DateTime.utc(2025, 1, 1),
                lastDay: DateTime.utc(2030, 12, 31),
                focusedDay: DateTime.now(),
                rowHeight: 52,
                headerStyle: HeaderStyle(
                  formatButtonVisible: false,
                  titleCentered: true,
                  titleTextStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textColor),
                  leftChevronIcon: Icon(Icons.chevron_left, color: textColor),
                  rightChevronIcon: Icon(Icons.chevron_right, color: textColor),
                ),
                daysOfWeekStyle: DaysOfWeekStyle(
                  weekdayStyle: TextStyle(color: subTextColor, fontWeight: FontWeight.w500),
                  weekendStyle: TextStyle(color: subTextColor, fontWeight: FontWeight.w500),
                ),
                calendarStyle: const CalendarStyle(
                  outsideDaysVisible: false,
                  todayDecoration: BoxDecoration(),
                  selectedDecoration: BoxDecoration(),
                ),
                calendarBuilders: CalendarBuilders(
                  defaultBuilder: (context, date, focusedDay) {
                    final normalizedDate = _normalizeDate(date);
                    if (_history.containsKey(normalizedDate)) {
                      return Center(
                        child: Text(_history[normalizedDate]!['emoji']!, style: const TextStyle(fontSize: 26)),
                      );
                    }
                    return Center(child: Text('${date.day}', style: TextStyle(color: textColor)));
                  },
                  todayBuilder: (context, date, focusedDay) {
                    final normalizedDate = _normalizeDate(date);
                    if (_history.containsKey(normalizedDate)) {
                      return Center(
                        child: Text(_history[normalizedDate]!['emoji']!, style: const TextStyle(fontSize: 26)),
                      );
                    }
                    return Center(
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: accentColor.withOpacity(0.15),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            '${date.day}',
                            style: TextStyle(color: accentColor, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    );
                  },
                ),
                onDaySelected: (selectedDay, focusedDay) {
                  _showDaySummary(context, selectedDay, accentColor, containerBg, textColor, subTextColor);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showDaySummary(BuildContext context, DateTime date, Color accentColor, Color dialogBg, Color textColor, Color subTextColor) {
    final normalizedDate = _normalizeDate(date);
    final hasEntry = _history.containsKey(normalizedDate);
    
    final emoji = hasEntry ? _history[normalizedDate]!['emoji'] : '';
    final label = hasEntry ? _history[normalizedDate]!['label'] : 'No Entry';
    final note = hasEntry && _history[normalizedDate]!['note']!.isNotEmpty 
        ? _history[normalizedDate]!['note'] 
        : 'No notes logged for this day.';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: dialogBg,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        contentPadding: EdgeInsets.zero,
        content: Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${date.month}/${date.day} Review", 
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: textColor)
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Text(emoji!.isNotEmpty ? emoji : '⚪', style: const TextStyle(fontSize: 32)),
                  const SizedBox(width: 12),
                  Text(
                    label!, 
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: textColor)
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text("Notes:", style: TextStyle(fontWeight: FontWeight.bold, color: subTextColor.withOpacity(0.6), fontSize: 12)),
              const SizedBox(height: 4),
              Text(
                note!, 
                style: TextStyle(fontSize: 14, color: textColor, height: 1.4)
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Close", style: TextStyle(color: accentColor, fontWeight: FontWeight.bold)),
          )
        ],
      ),
    );
  }
}