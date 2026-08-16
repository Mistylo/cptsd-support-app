import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cptsd_app/pages/tools/grounding/guided_breathing/visual_breathing_selection_page.dart';
import 'package:cptsd_app/pages/tools/grounding/guided_breathing/audio_breathing_selection_page.dart';
import 'package:cptsd_app/pages/tools/theme_provider.dart';

// Provides the main entry point for guided breathing exercises
// Users can choose between audio guided breathing and visually guided breathing modes

class BreathingHub extends ConsumerWidget {
  const BreathingHub({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Get the current app theme
    final theme = ref.watch(appThemeProvider);

    // Adjust text colours based on the background
    final bool isDarkBackground = ThemeData.estimateBrightnessForColor(theme.bottomColor) == Brightness.dark;
    final Color textColor = isDarkBackground ? Colors.white.withOpacity(0.9) : Colors.black87;
    final Color subTextColor = isDarkBackground ? Colors.white60 : Colors.black54;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          "Breathing Hub",
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
          gradient: theme.backgroundGradient
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
                            Icon(Icons.air_rounded, color: theme.accentColor, size: 28),
                            const SizedBox(width: 10),
                            Text(
                              "Guided Breathing",
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
                          "Guided Breathing helps ease your stress and soothe your body with steady pacing. Whether you want to listen to a calming sound or follow a gentle visual guide, these exercises are here to help lower your anxiety and bring you safely back to the present moment.",
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
                        title: "Audio Guided",
                        subtitle: "Calming voice & audio cues",
                        icon: Icons.record_voice_over_rounded,
                        iconBg: theme.accentColor.withOpacity(0.15),
                        iconColor: theme.accentColor,
                        textColor: textColor,
                        subTextColor: subTextColor,
                        isDarkBackground: isDarkBackground,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const AudioGuidedSelectionPage()),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildHubTile(
                        title: "Visual Guided",
                        subtitle: "Interactive pacing anchors",
                        icon: Icons.blur_on_rounded,
                        iconBg: theme.accentColor.withOpacity(0.15),
                        iconColor: theme.accentColor,
                        textColor: textColor,
                        subTextColor: subTextColor,
                        isDarkBackground: isDarkBackground,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const VisualBreathingSelectionPage()),
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