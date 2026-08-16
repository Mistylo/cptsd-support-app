import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cptsd_app/resources.dart'; 
import 'package:cptsd_app/pages/inner_studio/inner_studio.dart'; 
import 'package:cptsd_app/pages/profile/profile_page.dart';
import 'package:cptsd_app/pages/tools/tools_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cptsd_app/onboarding/onboarding_registry.dart'; 
import 'package:cptsd_app/onboarding/static_intro_dialog.dart'; 

// This file implements the user interface prototype for the psychoeducation
// section of the CPTSD Companion application.

// Represents structured psychoeducation categories displayed in the library.
class EducationCategory {
  final String id;
  final String title;
  final String description;
  final IconData icon;

  const EducationCategory({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
  });
}

// Static prototype content representing available learning topics.
final List<EducationCategory> educationCategories = [
  const EducationCategory(
    id: 'understanding_cptsd',
    title: 'Understanding CPTSD',
    description: 'Core concepts, origins, and how complex trauma differs from PTSD',
    icon: Icons.psychology_outlined,
  ),
  const EducationCategory(
    id: 'trauma_responses',
    title: 'Trauma Responses',
    description: 'Explore survival strategies and how your nervous system adapts to threat',
    icon: Icons.shield_outlined,
  ),
  const EducationCategory(
    id: 'flashbacks_reactions',
    title: 'Flashbacks & Emotional Reactions',
    description: 'Identifying non-visual emotional regressions and managing acute reactions',
    icon: Icons.replay_outlined,
  ),
  const EducationCategory(
    id: 'triggers_patterns',
    title: 'Triggers & Patterns',
    description: 'Deconstructing emotional catalysts, intense reactions, and thought loops',
    icon: Icons.center_focus_strong_outlined,
  ),
  const EducationCategory(
    id: 'coping_grounding',
    title: 'Coping & Grounding',
    description: 'Practical somatic tools and self-soothing practices to return to baseline',
    icon: Icons.spa_outlined,
  ),
  const EducationCategory(
    id: 'reflection_recovery',
    title: 'Reflection & Recovery',
    description: 'Advanced perspectives on long term healing, setbacks, and self compassion',
    icon: Icons.eco_outlined,
  ),
];

// Provides users with structured trauma-related educational resources
class EducationScreen extends StatefulWidget {
  const EducationScreen({super.key});

  static const Color backgroundColor = Color(0xFFF8F9FA);
  static const Color surfaceColor = Colors.white;
  static const Color lavenderAccent = Color(0xFF7C698D);
  static const Color lavenderLightBg = Color(0xFFF3EFEF);
  static const Color borderGray = Color(0xFFE9ECEF);
  static const Color textPrimary = Color(0xFF212529);
  static const Color textSecondary = Color(0xFF6C757D);

  @override
  State<EducationScreen> createState() => _EducationScreenState();
}

class _EducationScreenState extends State<EducationScreen> {
  // Tracks the currently selected navigation section
  final int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();

    // Trigger onboarding dialog ONLY on first visit to Education
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final prefs = await SharedPreferences.getInstance();
      
      // 1. Check if Education onboarding has already been completed/seen
      final bool alreadySeen = prefs.getBool('seen_onboarding_${OnboardingRegistry.keyEducation}') ?? false;

      //change true back to !alreadySeen after debugging
      if (true && mounted) {
        final config = OnboardingRegistry.getConfig(OnboardingRegistry.keyEducation);
        if (config != null) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => StaticIntroDialog(
              config: config,
              onDismissed: () async {
                // 2. Save preference when dismissed
                await prefs.setBool('seen_onboarding_${OnboardingRegistry.keyEducation}', true);
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
  // Retrieves the active application theme configuration
  dynamic get _currentTheme => Theme.of(context);

  Widget _buildBottomNav() {
  final theme = Theme.of(context);
  final isDark = theme.brightness == Brightness.dark;
  final inactiveColor = isDark ? Colors.white54 : const Color(0xFF4B4B4B);
  final activeColor = theme.colorScheme.primary;

  return BottomNavigationBar(
    type: BottomNavigationBarType.fixed,
    backgroundColor: isDark ? const Color(0xFF1E1E1E) : const Color(0xFFF5F1F4),
    selectedItemColor: activeColor,
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
      _buildNavItem(AppIcons.book, 'Education', 0, activeColor, inactiveColor),
      _buildNavItem(AppIcons.star, 'Inner Studio', 1, activeColor, inactiveColor),
      _buildNavItem(AppIcons.tool, 'Tools', 2, activeColor, isDark ? Colors.white38 : const Color(0xFF4B4B4B)),
      _buildNavItem(AppIcons.profile, 'Profile', 3, activeColor, inactiveColor),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: EducationScreen.backgroundColor,
      appBar: AppBar(
        backgroundColor: EducationScreen.surfaceColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        iconTheme: const IconThemeData(color: EducationScreen.textPrimary),
        title: const Text(
          'Psychoeducation Library',
          style: TextStyle(
            color: EducationScreen.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.3,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        children: [
          // Banner
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: EducationScreen.lavenderLightBg,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFE5DEEC)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: EducationScreen.lavenderAccent.withOpacity(0.12),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.auto_stories_rounded,
                    color: EducationScreen.lavenderAccent,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 14),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Learn & Understand',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: EducationScreen.textPrimary,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Explore evidence-based insights to help make sense of your trauma responses and recovery.',
                        style: TextStyle(
                          fontSize: 12,
                          color: EducationScreen.textSecondary,
                          height: 1.35,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          const Padding(
            padding: EdgeInsets.only(left: 2, bottom: 12),
            child: Text(
              'Topics',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF495057),
              ),
            ),
          ),

          // Categories List
          ...educationCategories.map((category) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: InkWell(
                onTap: () {
                  // Future implementation: navigate to detailed educational content pages
                },
                borderRadius: BorderRadius.circular(14),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: EducationScreen.surfaceColor,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: EducationScreen.borderGray),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.02),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1F3F5),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          category.icon,
                          color: EducationScreen.lavenderAccent,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              category.title,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: EducationScreen.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              category.description,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 12,
                                color: EducationScreen.textSecondary,
                                height: 1.3,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(
                        Icons.chevron_right_rounded,
                        color: EducationScreen.textSecondary,
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ],
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }
}