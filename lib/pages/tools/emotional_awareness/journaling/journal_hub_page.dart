import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'journal_library_page.dart'; 
import 'journal_provider.dart';
import 'journal_type_selection_page.dart'; 
import 'package:cptsd_app/pages/tools/theme_provider.dart';

/// Entry hub for the journaling tool
/// Allows users to create expressive journal entries and revisit
class JournalHubPage extends ConsumerWidget {
  const JournalHubPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Retrieve shared theme configuration to maintain visual consistency across modules
    final theme = ref.watch(appThemeProvider);

    // Adapt text colours dynamically according to background brightness 
    //to maintain readability across different user-selected themes
    final bool isDarkBackground = ThemeData.estimateBrightnessForColor(theme.bottomColor) == Brightness.dark;
    final Color textColor = isDarkBackground ? Colors.white.withOpacity(0.9) : Colors.black87;
    final Color subTextColor = isDarkBackground ? Colors.white60 : Colors.black54;

    // Retrieve journal state containing stored entries and metadata
    final journalState = ref.watch(journalProvider);
    
    // Calculate total journal entries for displaying collection progress
    final totalCount = journalState.entries.length;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          "Creative Journal Canvas", 
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
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Introductory explanation describing the purpose of creative journaling
                Card(
                  elevation: 0,
                  color: theme.accentColor.withOpacity(0.12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.auto_awesome_mosaic_rounded, color: theme.accentColor, size: 28),
                            const SizedBox(width: 10),
                            Text(
                              "Externalize Your Narrative",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: theme.accentColor,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          "Turn your inner thoughts and feelings into a personal piece of art. By mixing words with creative design elements, you can safely explore and release your emotions in your own unique way.",
                          style: TextStyle(
                            color: textColor,
                            height: 1.45,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: _buildHubTile(
                        title: "Write Journal",
                        subtitle: "Start a new writing & decoration session",
                        icon: Icons.edit_note_rounded,
                        iconBg: theme.accentColor.withOpacity(0.15),
                        iconColor: theme.accentColor,
                        textColor: textColor,
                        subTextColor: subTextColor,
                        isDarkBackground: isDarkBackground,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const JournalTypeSelectionPage(), 
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildHubTile(
                        title: "Journal Gallery",
                        subtitle: totalCount > 0 ? "$totalCount entries compiled" : "View your design history",
                        icon: Icons.photo_library_rounded,
                        iconBg: theme.accentColor.withOpacity(0.15),
                        iconColor: theme.accentColor,
                        textColor: textColor,
                        subTextColor: subTextColor,
                        isDarkBackground: isDarkBackground,
                        onTap: () {
                          Navigator.push(
                            context, 
                            MaterialPageRoute(builder: (c) => const JournalLibraryPage()),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHubTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
    required Color textColor,
    required Color subTextColor,
    required bool isDarkBackground,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      shadowColor: Colors.black.withOpacity(0.05),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      color: isDarkBackground ? const Color(0xFF2C2C2C) : Colors.white,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
                child: Icon(icon, color: iconColor, size: 24),
              ),
              const SizedBox(height: 20),
              Text(
                title, 
                style: TextStyle(
                  fontWeight: FontWeight.bold, 
                  fontSize: 14,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                subtitle,
                style: TextStyle(
                  color: subTextColor, 
                  fontSize: 12,
                  height: 1.25,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}