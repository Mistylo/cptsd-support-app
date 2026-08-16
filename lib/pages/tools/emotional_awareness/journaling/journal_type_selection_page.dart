import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'journal_form_canvas_page.dart';
import 'package:cptsd_app/pages/tools/theme_provider.dart';

// User can select the type of journal they want to create
class JournalTypeSelectionPage extends ConsumerWidget {
  const JournalTypeSelectionPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(appThemeProvider);

    final bool isDarkBackground = ThemeData.estimateBrightnessForColor(theme.bottomColor) == Brightness.dark;
    final Color textColor = isDarkBackground ? Colors.white.withOpacity(0.9) : Colors.black87;
    final Color subTextColor = isDarkBackground ? Colors.white60 : Colors.black54;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          "Choose Journal Type", 
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
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            children: [
              _buildSelectionCard(
                context: context,
                title: "Free Writing Journal",
                subtitle: "Free writing with no rules or structure",
                icon: Icons.edit_note_rounded,
                typeKey: 'free_writing',
                theme: theme,
                textColor: textColor,
                subTextColor: subTextColor,
                isDarkBackground: isDarkBackground,
              ),
              const SizedBox(height: 16),
              _buildSelectionCard(
                context: context,
                title: "Moment of Calm",
                subtitle: "Record the things that made you feel grounding",
                icon: Icons.spa_rounded,
                typeKey: 'moment_of_calm',
                theme: theme,
                textColor: textColor,
                subTextColor: subTextColor,
                isDarkBackground: isDarkBackground,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSelectionCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required String typeKey,
    required dynamic theme,
    required Color textColor,
    required Color subTextColor,
    required bool isDarkBackground,
  }) {
    return Card(
      elevation: 2,
      shadowColor: Colors.black.withOpacity(0.05),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      color: isDarkBackground ? const Color(0xFF2C2C2C) : Colors.white,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => JournalFormCanvasPage(journalType: typeKey),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: theme.accentColor.withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: theme.accentColor, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: subTextColor,
                        fontSize: 12,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}