import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cptsd_app/resources.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cptsd_app/onboarding/onboarding_registry.dart'; 
import 'package:cptsd_app/onboarding/static_intro_dialog.dart';
import 'package:cptsd_app/pages/profile/security/security_service.dart';
import 'package:cptsd_app/pages/tools/theme_provider.dart';
import 'package:cptsd_app/pages/tools/tools_page.dart'; 
import 'package:cptsd_app/pages/inner_studio/inner_studio.dart';
import 'package:cptsd_app/pages/profile/affirmation_notifications/affirmation_notifications_hub_page.dart';
import 'package:cptsd_app/pages/profile/data_setting/data_settings_screen.dart';
import 'package:cptsd_app/pages/profile/emotional_history/emotional_history_screen.dart';
import 'package:cptsd_app/pages/education/education_screen.dart';

/// Provides the user profile management interface, including personalization,
/// application security settings, notification preferences, emotional history
/// access, and data management controls.
/// 
// Provides access to application security services such as PIN management
// while keeping security related logic separated from UI components
final securityServiceProvider = Provider<SecurityService>((ref) {
  return SecurityService();
});

// Stores the current biometric/security preference state.
// This provider allows security settings to be shared across profile related components
final biometricEnabledProvider = StateProvider<bool>((ref) {
  return false; 
});

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
   // Maintains the selected navigation tab for consistent bottom navigation state
  final int _selectedIndex = 3;
  
   // User profile information currently stored locally within the application state.
  // Future versions can persist these values using local storage
  String _username = 'Mindful User';
  IconData _selectedAvatarIcon = Icons.person_outline_rounded;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final prefs = await SharedPreferences.getInstance();
      
      // Check if Profile onboarding has already been completed/seen
      final bool alreadySeen = prefs.getBool('seen_onboarding_${OnboardingRegistry.keyProfile}') ?? false;

      if (!alreadySeen && mounted) {
        final config = OnboardingRegistry.getConfig(OnboardingRegistry.keyProfile);
        if (config != null) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => StaticIntroDialog(
              config: config,
              onDismissed: () async {
                // 2. Save preference when dismissed
                await prefs.setBool('seen_onboarding_${OnboardingRegistry.keyProfile}', true);
                if (context.mounted) {
                  Navigator.of(context).pop();
                }
              },
            ),
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = ref.watch(appThemeProvider);
    final isBiometricOn = ref.watch(biometricEnabledProvider);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Profile',
          style: TextStyle(
            color: theme.foregroundColor,
            fontWeight: FontWeight.w800,
            fontSize: 24,
            letterSpacing: -0.5,
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
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 12),
                _buildUserHeader(theme),
                const SizedBox(height: 36),

                // Groups security related controls separately to improve discoverability
                // and provide users with direct access to privacy protection features
                _buildMenuSection(
                  title: 'Security',
                  theme: theme,
                  children: [
                    _buildMenuTile(
                      icon: Icons.lock_outline_rounded,
                      title: 'Change Security PIN',
                      subtitle: 'Manage your 4-digit application lock',
                      theme: theme,
                      onTap: () => _showChangePinDialog(context),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Contains user preference controls such as notification management
                _buildMenuSection(
                  title: 'Preferences',
                  theme: theme,
                  children: [
                    _buildMenuTile(
                      icon: Icons.notifications_active_outlined,
                      title: 'Affirmation Notifications',
                      subtitle: 'Set up daily reminder preferences',
                      theme: theme,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AffirmationNotificationsHubPage(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Provides access to historical emotional records
                _buildMenuSection(
                  title: 'History & Logs',
                  theme: theme,
                  children: [
                    _buildMenuTile(
                      icon: Icons.history_edu_rounded,
                      title: 'Emotional History Overview',
                      subtitle: 'View your mood patterns over time',
                      theme: theme,
                       onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const EmotionalHistoryScreen(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Contains privacy and data management features including export
                // and application data reset functionality
                _buildMenuSection(
                  title: 'System & Safety',
                  theme: theme,
                  children: [
                    _buildMenuTile(
                      icon: Icons.shield_outlined,
                      title: 'Data Settings',
                      subtitle: 'Export logs or reset application data',
                      theme: theme,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const DataSettingsScreen(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNav(theme),
    );
  }

  Widget _buildUserHeader(ToolThemeData theme) {
    return Column(
      children: [
        GestureDetector(
          // Allows users to personalise their profile representation
          onTap: () => _showEditProfileSheet(theme),
          child: Stack(
            children: [
              Container(
                padding: const EdgeInsets.all(4.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: theme.accentColor.withValues(alpha: 0.3),
                    width: 2,
                  ),
                ),
                child: CircleAvatar(
                  radius: 46,
                  backgroundColor: theme.cardColor,
                  child: Icon(
                    _selectedAvatarIcon,
                    size: 40,
                    color: theme.accentColor,
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: theme.accentColor,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.15),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      )
                    ]
                  ),
                  child: const Icon(
                    Icons.edit_rounded,
                    size: 14,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        Text(
          _username,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.3,
            color: theme.foregroundColor,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'On your inner journey',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: theme.foregroundColor.withValues(alpha: 0.5),
            letterSpacing: 0.1,
          ),
        ),
      ],
    );
  }

  Widget _buildMenuSection({
    required String title,
    required List<Widget> children,
    required ToolThemeData theme,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Reusable section container used to maintain consistent layout
        // across different profile settings categories.
        Padding(
          padding: const EdgeInsets.only(left: 6.0, bottom: 8.0),
          child: Text(
            title.toUpperCase(),
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.5,
              color: theme.foregroundColor.withValues(alpha: 0.4),
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: theme.foregroundColor.withValues(alpha: 0.04),
              width: 1,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Column(children: children),
          ),
        ),
      ],
    );
  }

  Widget _buildMenuTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required ToolThemeData theme,
    required VoidCallback onTap,
  }) {
    return ListTile(
      // Shared menu component to ensure consistent interaction patterns
    // and visual hierarchy across profile options
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: theme.accentColor.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Icon(
          icon, 
          color: theme.accentColor,
          size: 22,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 16,
          letterSpacing: -0.1,
          color: theme.foregroundColor,
        ),
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 2.0),
        child: Text(
          subtitle,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: theme.foregroundColor.withValues(alpha: 0.5),
          ),
        ),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios_rounded,
        size: 13,
        color: theme.foregroundColor.withValues(alpha: 0.25),
      ),
      onTap: onTap,
    );
  }

  void _showEditProfileSheet(ToolThemeData theme) {
    final TextEditingController nameController = TextEditingController(text: _username);
    // Temporary local state is used inside the modal to avoid updating
  // the profile before the user confirms their changes
    IconData localSelectedIcon = _selectedAvatarIcon;

    final List<IconData> avatarOptions = [
      Icons.person_outline_rounded,
      Icons.sentiment_satisfied_alt_rounded,
      Icons.spa_outlined,
      Icons.favorite_border_rounded,
      Icons.wb_sunny_outlined,
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: theme.cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 24.0,
                right: 24.0,
                top: 20.0,
                bottom: MediaQuery.of(context).viewInsets.bottom + 32.0,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 5,
                      decoration: BoxDecoration(
                        color: theme.foregroundColor.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Edit Profile',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: theme.foregroundColor,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'USERNAME',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.2,
                      color: theme.foregroundColor.withValues(alpha: 0.4),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: nameController,
                    style: TextStyle(color: theme.foregroundColor, fontWeight: FontWeight.w600),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: theme.foregroundColor.withValues(alpha: 0.03),
                      hintText: 'Enter username...',
                      hintStyle: TextStyle(color: theme.foregroundColor.withValues(alpha: 0.3)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(color: theme.accentColor, width: 1.5),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'SELECT AVATAR ICON',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.2,
                      color: theme.foregroundColor.withValues(alpha: 0.4),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: avatarOptions.map((icon) {
                      final bool isSelected = localSelectedIcon == icon;
                      return GestureDetector(
                        onTap: () {
                          setSheetState(() => localSelectedIcon = icon);
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: isSelected ? theme.accentColor : theme.foregroundColor.withValues(alpha: 0.03),
                            shape: BoxShape.circle,
                            border: isSelected ? Border.all(color: Colors.white.withValues(alpha: 0.2), width: 1) : null,
                          ),
                          child: Icon(
                            icon,
                            color: isSelected ? Colors.white : theme.foregroundColor.withValues(alpha: 0.5),
                            size: 26,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        if (nameController.text.trim().isNotEmpty) {
                          setState(() {
                            _username = nameController.text.trim();
                            _selectedAvatarIcon = localSelectedIcon;
                          });
                        }
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.accentColor,
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      child: const Text(
                        'Save Changes',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showChangePinDialog(BuildContext context) {
    final securityService = ref.read(securityServiceProvider);
    final controller = TextEditingController();
    final formKey = GlobalKey<FormState>();

    const Color bgDark = Color(0xFF1E2022);      
    const Color cardDark = Color(0xFF2C2E31);     
    const Color textPrimary = Color(0xFFF5F5F7);  
    const Color textSecondary = Color(0xFF8E9196);
    const Color accentActive = Color(0xFFFFFFFF);  

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: bgDark,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(color: textSecondary.withValues(alpha: 0.1)),
          ),
          title: const Text(
            "Change Security PIN",
            style: TextStyle(
              color: textPrimary,
              fontWeight: FontWeight.w700,
              fontSize: 20,
              letterSpacing: -0.5,
            ),
          ),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "ENTER NEW 4-DIGIT PIN",
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.2,
                    color: textSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: controller,
                  keyboardType: TextInputType.number,
                  maxLength: 4,
                  obscureText: true,
                  autofocus: true,
                  style: const TextStyle(
                    color: textPrimary, 
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                    letterSpacing: 4.0,
                  ),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: cardDark,
                    hintText: "••••",
                    hintStyle: TextStyle(
                      color: textSecondary.withValues(alpha: 0.4),
                      letterSpacing: 4.0,
                    ),
                    counterText: "",
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(color: textSecondary.withValues(alpha: 0.5), width: 1.5),
                    ),
                    errorStyle: const TextStyle(color: Colors.redAccent),
                  ),
                  validator: (value) {
                    if (value == null || value.length != 4 || int.tryParse(value) == null) {
                      return "PIN must be exactly 4 numbers";
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              style: TextButton.styleFrom(
                foregroundColor: textSecondary,
              ),
              child: const Text(
                "Cancel",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
            ElevatedButton(
              // Security PIN modification workflow:
              // 1. Validate user input format
              // 2. Delegate secure storage operation to SecurityService
              // 3. Provide feedback only after successful update
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  final success = await securityService.setPIN(controller.text);
                  if (success && context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("PIN changed successfully!"),
                        backgroundColor: Color(0xFF2E7D32),
                      ),
                    );
                    Navigator.pop(context);
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: accentActive,
                foregroundColor: bgDark,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
              child: const Text(
                "Save",
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildBottomNav(ToolThemeData theme) {
    final inactiveColor = theme.isDarkMode ? Colors.white54 : const Color(0xFF4B4B4B);

    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: theme.isDarkMode ? const Color(0xFF1E1E1E) : const Color(0xFFF5F1F4),
      selectedItemColor: theme.accentColor,
      unselectedItemColor: inactiveColor,
      currentIndex: _selectedIndex,
      onTap: (index) {
        if (index == _selectedIndex) return;
        final Widget target = switch (index) {
          0 => const EducationScreen(),
          1 => const InnerStudioPage(),
          2 => const ToolsPage(),
          3 => const ProfilePage(),
          _ => const ToolsPage(),
        };
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => target));
      },
      items: [
        _buildNavItem(AppIcons.book, 'Education', 0, theme.accentColor, inactiveColor),
        _buildNavItem(AppIcons.star, 'Inner Studio', 1, theme.accentColor, inactiveColor),
        _buildNavItem(AppIcons.tool, 'Tools', 2, theme.accentColor, theme.isDarkMode ? Colors.white38 : const Color(0xFF4B4B4B)),
        _buildNavItem(AppIcons.profile, 'Profile', 3, theme.accentColor, inactiveColor),
      ],
    );
  }

  BottomNavigationBarItem _buildNavItem(String asset, String label, int index, Color activeColor, Color inactiveColor) {
    return BottomNavigationBarItem(
      icon: SvgPicture.asset(
        asset,
        width: 24,
        colorFilter: ColorFilter.mode(
          _selectedIndex == index ? activeColor : inactiveColor,
          BlendMode.srcIn,
        ),
      ),
      label: label,
    );
  }
}