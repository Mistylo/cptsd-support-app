import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cptsd_app/pages/tools/theme_provider.dart';
import 'notification_setting_page.dart';
import 'manage_affirmation_page.dart';

/// Hub page for managing affirmation notifications and personal affirmations
class AffirmationNotificationsHubPage extends ConsumerWidget {
  const AffirmationNotificationsHubPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Get the current app theme so the page follows the user's settings
    final theme = ref.watch(appThemeProvider);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: theme.foregroundColor,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          // Use the selected theme colours for the page background
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              theme.topColor,
              theme.bottomColor,
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 16.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 12),

                Text(
                  'Affirmation Notifications',
                  style: TextStyle(
                    color: theme.foregroundColor,
                    fontWeight: FontWeight.w800,
                    fontSize: 28,
                    letterSpacing: -0.5,
                  ),
                ),

                const SizedBox(height: 12),

                // Explain the purpose of the notification feature
                Text(
                  'Receive gentle reminders throughout the day to encourage self-compassion and emotional support. You can customize how often they appear and personalise the affirmations to make them meaningful for you.',
                  style: TextStyle(
                    color: theme.foregroundColor.withOpacity(0.7),
                    fontSize: 14,
                    height: 1.5,
                  ),
                ),

                const SizedBox(height: 36),

                // Open the page for changing notification frequency and quiet hours
                _buildHubCard(
                  title: 'Notification Settings',
                  subtitle:
                      'Configure frequency, quiet hours, and status',
                  icon: Icons.tune_rounded,
                  theme: theme,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            const NotificationSettingsPage(),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 16),

                // Open the page for managing the user's affirmations
                _buildHubCard(
                  title: 'Manage Affirmations',
                  subtitle:
                      'Add, edit, or remove personal support messages',
                  icon: Icons.favorite_border_rounded,
                  theme: theme,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            const ManageAffirmationsPage(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Builds a reusable card used to navigate to the two settings pages
  Widget _buildHubCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required dynamic theme,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: theme.foregroundColor.withOpacity(0.04),
          width: 1,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 16,
          ),
          leading: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: theme.accentColor.withOpacity(0.08),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              icon,
              color: theme.accentColor,
              size: 24,
            ),
          ),
          title: Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 16,
              color: theme.foregroundColor,
            ),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Text(
              subtitle,
              style: TextStyle(
                fontSize: 12,
                color: theme.foregroundColor.withOpacity(0.5),
              ),
            ),
          ),
          trailing: Icon(
            Icons.arrow_forward_ios_rounded,
            size: 14,
            color: theme.foregroundColor.withOpacity(0.25),
          ),
          onTap: onTap,
        ),
      ),
    );
  }
}