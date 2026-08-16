import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cptsd_app/pages/tools/theme_provider.dart';

/// Notification Preference Configuration Page
///
/// Provides users with control over affirmation reminder behaviour,
/// including notification activation, daily frequency, and quiet periods.
class NotificationSettingsPage extends ConsumerStatefulWidget {
  const NotificationSettingsPage({super.key});

  @override
  ConsumerState<NotificationSettingsPage> createState() => _NotificationSettingsPageState();
}

class _NotificationSettingsPageState extends ConsumerState<NotificationSettingsPage> {
  // Whether affirmation reminders are globally enabled
  bool _enabled = true;
  // Number of supportive reminders delivered per day.
  // Controlled through UI constraints to avoid excessive notifications
  double _frequency = 3;
  // Stored as hour values rather than timestamps because quiet hours
  // represent recurring daily preferences
  double _quietStartHour = 22; // 10 PM
  double _quietEndHour = 8;    // 8 AM
  // Prevents displaying incomplete settings before local preferences
  // have been retrieved
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  // Load preferences locally for UI state persistence
  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _enabled = prefs.getBool('notif_enabled') ?? true;
      _frequency = prefs.getDouble('notif_frequency') ?? 3.0;
      _quietStartHour = prefs.getDouble('notif_quiet_start') ?? 22.0;
      _quietEndHour = prefs.getDouble('notif_quiet_end') ?? 8.0;
      _isLoading = false;
    });
  }

  // Save changes locally to SharedPreferences without triggering background hooks
  Future<void> _saveSetting(String key, dynamic value) async {
    final prefs = await SharedPreferences.getInstance();
    if (value is bool) {
      await prefs.setBool(key, value);
    } else if (value is double) {
      await prefs.setDouble(key, value);
    }
  }

  // Converts internal hour representation into user readable format
  String _formatTime(double hourFraction) {
    final int hour = hourFraction.round() % 24;
    return '${hour.toString().padLeft(2, '0')}:00';
  }

  @override
  Widget build(BuildContext context) {
    final theme = ref.watch(appThemeProvider);

    if (_isLoading) {
      return Scaffold(
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
          child: Center(
            child: CircularProgressIndicator.adaptive(
              valueColor: AlwaysStoppedAnimation<Color>(theme.accentColor),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: theme.foregroundColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Notification Settings',
          style: TextStyle(
            color: theme.foregroundColor,
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
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
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // --- ENABLE NOTIFICATIONS CARD ---
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: theme.cardColor,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: theme.foregroundColor.withOpacity(0.04)),
                  ),
                  child: SwitchListTile.adaptive(
                    contentPadding: EdgeInsets.zero,
                    activeColor: theme.accentColor,
                    title: Text(
                      'Enable Notifications',
                      style: TextStyle(
                        color: theme.foregroundColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Text(
                      'Receive daily gentle affirmations',
                      style: TextStyle(
                        color: theme.foregroundColor.withOpacity(0.5),
                        fontSize: 12,
                      ),
                    ),
                    value: _enabled,
                    onChanged: (val) {
                      setState(() => _enabled = val);
                      _saveSetting('notif_enabled', val);
                    },
                  ),
                ),
                const SizedBox(height: 24),

                // Provides visual feedback when notifications are disabled.
                // AbsorbPointer prevents accidental interaction while maintaining
                // visibility of available configuration options.
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 200),
                  opacity: _enabled ? 1.0 : 0.4,
                  child: AbsorbPointer(
                    absorbing: !_enabled,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // --- SLIDER FREQUENCY ---
                        _buildSectionHeader('Daily Frequency', theme),
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: theme.cardColor,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: theme.foregroundColor.withOpacity(0.04)),
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Delivery Goal',
                                    style: TextStyle(color: theme.foregroundColor, fontWeight: FontWeight.w500),
                                  ),
                                  Text(
                                    '${_frequency.round()} times / day',
                                    style: TextStyle(color: theme.accentColor, fontWeight: FontWeight.w700),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Slider.adaptive(
                                value: _frequency,
                                min: 1,
                                max: 6,
                                divisions: 5,
                                activeColor: theme.accentColor,
                                inactiveColor: theme.foregroundColor.withOpacity(0.1),
                                onChanged: (val) {
                                  setState(() => _frequency = val);
                                },
                                onChangeEnd: (val) {
                                  _saveSetting('notif_frequency', val);
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),

                        // --- QUIET HOURS PANEL ---
                        _buildSectionHeader('Quiet Hours', theme),
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: theme.cardColor,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: theme.foregroundColor.withOpacity(0.04)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Muted Window',
                                    style: TextStyle(color: theme.foregroundColor, fontWeight: FontWeight.w500),
                                  ),
                                  Text(
                                    '${_formatTime(_quietStartHour)} – ${_formatTime(_quietEndHour)}',
                                    style: TextStyle(color: theme.accentColor, fontWeight: FontWeight.w700),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),

                              // Start Slider
                              Text(
                                'START PAUSE',
                                style: TextStyle(
                                  fontSize: 10, 
                                  fontWeight: FontWeight.w800, 
                                  letterSpacing: 1.0,
                                  color: theme.foregroundColor.withOpacity(0.4)
                                ),
                              ),
                              Slider.adaptive(
                                value: _quietStartHour,
                                min: 0,
                                max: 23,
                                divisions: 23,
                                activeColor: theme.accentColor,
                                inactiveColor: theme.foregroundColor.withOpacity(0.1),
                                onChanged: (val) {
                                  setState(() => _quietStartHour = val);
                                },
                                onChangeEnd: (val) {
                                  _saveSetting('notif_quiet_start', val);
                                },
                              ),
                              const SizedBox(height: 8),

                              // End Slider
                              Text(
                                'END PAUSE',
                                style: TextStyle(
                                  fontSize: 10, 
                                  fontWeight: FontWeight.w800, 
                                  letterSpacing: 1.0,
                                  color: theme.foregroundColor.withOpacity(0.4)
                                ),
                              ),
                              Slider.adaptive(
                                value: _quietEndHour,
                                min: 0,
                                max: 23,
                                divisions: 23,
                                activeColor: theme.accentColor,
                                inactiveColor: theme.foregroundColor.withOpacity(0.1),
                                onChanged: (val) {
                                  setState(() => _quietEndHour = val);
                                },
                                onChangeEnd: (val) {
                                  _saveSetting('notif_quiet_end', val);
                                },
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'Notifications will pause during this window.',
                                style: TextStyle(
                                  color: theme.foregroundColor.withOpacity(0.4),
                                  fontSize: 11,
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, dynamic theme) {
    return Padding(
      padding: const EdgeInsets.only(left: 6.0, bottom: 8.0),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w800,
          letterSpacing: 1.5,
          color: theme.foregroundColor.withOpacity(0.4),
        ),
      ),
    );
  }
}