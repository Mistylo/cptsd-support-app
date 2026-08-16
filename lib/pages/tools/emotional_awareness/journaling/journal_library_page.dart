import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'journal_provider.dart';
import 'journal_model.dart';
import 'journal_form_canvas_page.dart';
import 'package:cptsd_app/pages/tools/theme_provider.dart';

class JournalLibraryPage extends ConsumerWidget {
  const JournalLibraryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(appThemeProvider);
    final journalState = ref.watch(journalProvider);
    // Retrieve persisted journal entries from the application state
    final entries = journalState.entries; 

    final bool isDarkBackground = ThemeData.estimateBrightnessForColor(theme.bottomColor) == Brightness.dark;
    final Color textColor = isDarkBackground ? Colors.white.withOpacity(0.9) : Colors.black87;
    final Color subTextColor = isDarkBackground ? Colors.white60 : Colors.black54;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          "Journal Gallery",
          style: TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 16,
            color: theme.accentColor,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, size: 20, color: theme.accentColor),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [theme.topColor, theme.bottomColor],
          ),
        ),
        child: SafeArea(
          child: entries.isEmpty
              ? _buildEmptyState(textColor, subTextColor)
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                  itemCount: entries.length,
                  itemBuilder: (context, index) {
                    final entry = entries[index];
                    return _buildJournalHistoryCard(context, ref, entry, isDarkBackground, textColor, subTextColor, theme.accentColor);
                  },
                ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(Color txtColor, Color subTxtColor) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.photo_album_outlined, size: 64, color: subTxtColor.withOpacity(0.4)),
          const SizedBox(height: 16),
          Text(
            "Your gallery is completely clear.",
            style: TextStyle(color: txtColor, fontSize: 15, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          Text(
            "Saved visual logs will surface here.",
            style: TextStyle(color: subTxtColor, fontSize: 13),
          ),
        ],
      ),
    );
  }

  Widget _buildJournalHistoryCard(
    BuildContext context,
    WidgetRef ref,
    JournalEntry entry,
    bool isDark,
    Color txtColor,
    Color subTxtColor,
    Color accentColor,
  ) {
    // Convert stored journal type identifiers into user facing labels
    String displayType = 'Free Writing Journal';
    if (entry.type == 'moment_of_calm') displayType = 'Moment of Calm';


    // Select matching icon per specific journal type
    IconData typeIcon = Icons.edit_note_rounded;
    if (entry.type == 'moment_of_calm') typeIcon = Icons.spa_outlined;
    // Format the actual timestamp property to Month/Day/Year style string layout
    final DateTime date = entry.timestamp;
    final String formattedDate = "${date.month}/${date.day}/${date.year}";

    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      elevation: 2,
      shadowColor: Colors.black.withOpacity(0.03),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      color: isDark ? const Color(0xFF2C2C2C) : Colors.white,
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => JournalFormCanvasPage(
                journalType: entry.type,
                existingEntry: entry,
              ),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: Color(entry.backgroundColorValue).withOpacity(0.15),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.grey.withOpacity(0.15), width: 1),
                ),
                child: Icon(
                  typeIcon, 
                  size: 22, 
                  color: isDark ? Colors.white70 : Colors.black87
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      formattedDate,
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: txtColor),
                    ),
                    const SizedBox(height: 4),
                    // Provide journal type information and available interaction
                    Text(
                      "$displayType • Tap to view or edit this journal",
                      style: TextStyle(fontSize: 11, color: subTxtColor),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(Icons.delete_outline_rounded, size: 20, color: accentColor.withOpacity(0.6)),
                onPressed: () {
                  _showDeleteConfirmation(context, ref, entry.id);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  // Confirm deletion before removing a journal entry from local storage
  void _showDeleteConfirmation(BuildContext context, WidgetRef ref, Id id) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Delete journal?", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        content: const Text("This action permanently deletes this journal entry from storage"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
              ref.read(journalProvider.notifier).deleteJournal(id);
              Navigator.pop(ctx);
            },
            child: const Text("Delete", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}