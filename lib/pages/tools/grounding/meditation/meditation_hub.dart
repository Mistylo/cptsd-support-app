import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cptsd_app/pages/tools/grounding/meditation/unguided_session_page.dart';
import 'package:cptsd_app/pages/tools/grounding/meditation/guided_selection_page.dart';
import 'package:cptsd_app/pages/tools/theme_provider.dart';

// Provides the main entry point for guided and unguided meditation exercises
// Users can choose between audio guided meditation and unguided meditation exercises

class MeditationHub extends ConsumerWidget {
  const MeditationHub({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Get the current app theme
    final theme = ref.watch(appThemeProvider);

    // Choose text colours based on the current background
    final bool isDarkBackground = ThemeData.estimateBrightnessForColor(theme.bottomColor) == Brightness.dark;
    final Color textColor = isDarkBackground ? Colors.white.withOpacity(0.9) : Colors.black87;
    final Color subTextColor = isDarkBackground ? Colors.white60 : Colors.black54;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          "Meditation Hub", 
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
          gradient: theme.backgroundGradient,
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                            Icon(Icons.self_improvement_rounded, color: theme.accentColor, size: 28),
                            const SizedBox(width: 10),
                            Text(
                              "Meditation",
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
                          "Meditation gives you a deliberate pause to step back, look at your thoughts, and reconnect with right now. Whether you prefer a gently guided session or a quiet space with ambient sounds, these exercises are here to help you process emotions and find a sense of calm at your own pace.",
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
                        title: "Unguided Session",
                        subtitle: "Custom timers & ambient sounds",
                        icon: Icons.hourglass_top_rounded,
                        iconBg: theme.accentColor.withOpacity(0.15),
                        iconColor: theme.accentColor,
                        textColor: textColor,
                        subTextColor: subTextColor,
                        isDarkBackground: isDarkBackground,
                        onTap: () {
                          Navigator.push(
                            context, 
                            MaterialPageRoute(builder: (context) => const UnguidedSessionPage()),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildHubTile(
                        title: "Guided Meditation",
                        subtitle: "Paths led by a supportive voice",
                        icon: Icons.spa_rounded,
                        iconBg: theme.accentColor.withOpacity(0.15),
                        iconColor: theme.accentColor,
                        textColor: textColor,
                        subTextColor: subTextColor,
                        isDarkBackground: isDarkBackground,
                        onTap: () {
                          Navigator.push(
                            context, 
                            MaterialPageRoute(builder: (context) => const GuidedSelectionPage()),
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