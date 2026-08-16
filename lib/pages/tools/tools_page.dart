import 'dart:math' as math;
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

import 'package:cptsd_app/resources.dart';
import 'package:cptsd_app/pages/mood_tracker/mood_tracker_page.dart';
import 'package:cptsd_app/pages/tools/theme_provider.dart';
import 'package:cptsd_app/pages/inner_studio/inner_studio.dart';
import 'package:cptsd_app/pages/sos_function/sos_protocol_page.dart';
import 'package:cptsd_app/pages/tools/emotional_awareness/journaling/journal_hub_page.dart';
import 'package:cptsd_app/pages/tools/grounding/meditation/meditation_hub.dart';
import 'package:cptsd_app/pages/tools/grounding/guided_breathing/breathing_hub.dart';
import 'package:cptsd_app/pages/tools/grounding/five_4_3_2_1_grounding/five_4_3_2_1_grounding_page.dart';
import 'package:cptsd_app/pages/tools/congnitive_processing/decision_making/decision_making_page.dart';
import 'package:cptsd_app/pages/tools/congnitive_processing/interpersonal_skills/skill_hub_page.dart';
import 'package:cptsd_app/pages/tools/congnitive_processing/reframe_thought/reframe_thought_page.dart';
import 'package:cptsd_app/pages/tools/emotional_regulation/worry_release/worry_hub_page.dart';
import 'tools_setting_views_page.dart';
import 'package:cptsd_app/pages/inner_studio/inner_studio_provider.dart';
import 'package:cptsd_app/pages/profile/profile_page.dart';
import 'package:cptsd_app/pages/education/education_screen.dart';
import 'package:cptsd_app/onboarding/onboarding_registry.dart';
import 'package:cptsd_app/onboarding/static_intro_dialog.dart';


// This file implements the main Tools page of the application.
//
// The Tools page provides access to different self help tools,
// including grounding exercises, emotional awareness activities,
// cognitive processing tools, and emotional regulation techniques.
//
// Users can customise how tools are displayed and access individual
// intervention pages from this central location.

// Defines different ways that tools can be displayed on the page

enum LayoutType { list, grid, geometric }

// Stores user customisation settings for each tool,
// including whether the tool is available, pinned, or has a custom icon
class ToolMetaConfig {
  final bool isActive;
  final bool isPinned;
  final String? customIconPath;

  const ToolMetaConfig({
    required this.isActive,
    required this.isPinned,
    this.customIconPath,
  });
}

// Represents a group of related therapeutic tools.
// Categories are used to organise tools based on their purpose
class ToolCategory {
  final String title;
  final String icon;
  final List<String> toolIds;

  const ToolCategory({required this.title, required this.icon, required this.toolIds});
}

// Stores the basic information required to display and open a tool.
//
// Each tool contains its title, icon, progress tracking key,
// and the page that should be opened when the user selects it
class ToolItemSpec {
  final String title;
  final String icon;
  final String studioActivityKey;
  final String? tag;
  final String? desc;
  final String? benefit;
  final WidgetBuilder? customPageBuilder;

  const ToolItemSpec({
    required this.title,
    required this.icon,
    required this.studioActivityKey,
    this.tag,
    this.desc,
    this.benefit,
    this.customPageBuilder,
  });
}

// Defines the main categories used to organise the available tools.
//
// The categories are based on different types of coping strategies,
// such as grounding, emotional awareness, and cognitive processing
final List<ToolCategory> appCategories = const [
  ToolCategory(title: "Grounding", icon: AppIcons.grounding, toolIds: ["Guided Breathing", "Meditation", "5-4-3-2-1 Grounding"]),
  ToolCategory(title: "Emotional Awareness", icon: AppIcons.emotionalAwareness, toolIds: ["Journaling"]),
  ToolCategory(title: "Cognitive Processing", icon: AppIcons.cognitiveProcessing, toolIds: ["Reframe Thought", "Decision Making", "Interpersonal Skills"]),
  ToolCategory(title: "Emotional Regulation", icon: AppIcons.emotionalRegulation, toolIds: ["Worry Release"]),
];

// Registers all available tools in the application
final List<ToolItemSpec> registeredTools = [
  ToolItemSpec(title: 'Meditation', icon: AppIcons.meditation, studioActivityKey: StudioNotifier.actMeditation, customPageBuilder: (c) => const MeditationHub()),
  ToolItemSpec(title: 'Guided Breathing', icon: AppIcons.guidedBreathing, studioActivityKey: StudioNotifier.actGuidedBreathing, customPageBuilder: (c) => const BreathingHub()),
  ToolItemSpec(title: '5-4-3-2-1 Grounding', icon: AppIcons.fiveFour, studioActivityKey: StudioNotifier.actGrounding54321, customPageBuilder: (c) => const GroundingSessionPage()),
  ToolItemSpec(title: 'Journaling', icon: AppIcons.journaling, studioActivityKey: StudioNotifier.actJournaling, customPageBuilder: (c) => const JournalHubPage()),
  ToolItemSpec(title: 'Reframe Thought', icon: AppIcons.thoughtreframing, tag: "AI", studioActivityKey: StudioNotifier.actReframeThought, customPageBuilder: (c) => const ReframeHubPage()),
  ToolItemSpec(title: 'Worry Release', icon: AppIcons.worryRelease, tag: "Optional AI", studioActivityKey: StudioNotifier.actWorryRelease, customPageBuilder: (c) => const WorryHubPage()),
  ToolItemSpec(title: 'Interpersonal Skills', icon: AppIcons.interpersonalSkills, tag: "Optional AI", studioActivityKey: StudioNotifier.actInterpersonalSkills, customPageBuilder: (c) => const SkillHubPage()),
  ToolItemSpec(title: 'Decision Making', icon: AppIcons.desisionMaking, studioActivityKey: StudioNotifier.actDecisionMaking, customPageBuilder: (c) => const DecisionMakingPage()),
];

// The main page that displays available therapeutic tools.
//
// This page also manages tool customisation options such as
// categories, layouts, themes, and pinned tools
class ToolsPage extends ConsumerStatefulWidget {
  const ToolsPage({super.key});

  @override
  ConsumerState<ToolsPage> createState() => _ToolsPageState();
}

class _ToolsPageState extends ConsumerState<ToolsPage> {
  // Stores the current navigation tab.
  // The Tools page is the third tab in the bottom navigation bar.
  static const int _selectedIndex = 2;
  bool _isCategorized = true; // Controls whether tools are shown by category or directly as a list
  String? _activeCategoryTitle; // Stores the currently opened category
  LayoutType _currentLayout = LayoutType.list; // Controls the current display layout selected by the user

  // Keys to highlight the 3 AppBar tools for Coach Marks
  final GlobalKey _moodTrackerKey = GlobalKey();
  final GlobalKey _sosProtocolKey = GlobalKey();
  final GlobalKey _customizationKey = GlobalKey();

  TutorialCoachMark? _tutorialCoachMark;

  // Stores the current configuration of each tool.
  // This allows users to activate/deactivate tools,
  // pin frequently used tools, and customise icons.
  late Map<String, ToolMetaConfig> _toolsRegistry;

  @override
  void initState() {
    super.initState();
    _toolsRegistry = {
      for (final tool in registeredTools)
        tool.title: const ToolMetaConfig(isActive: true, isPinned: false),
    };

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final prefs = await SharedPreferences.getInstance();
      
      // PRODUCTION ONE-TIME CHECK (Commented out for testing):
      // final bool alreadySeen = prefs.getBool('seen_onboarding_${OnboardingRegistry.keyTools}') ?? false;
      
      // TESTING MODE: Force alreadySeen to false so static intro always runs
      final bool alreadySeen = false;

      // Helper function to handle coach mark execution
      Future<void> checkAndShowCoachMark() async {
        // PRODUCTION ONE-TIME CHECK (Commented out for testing):
        // final bool hasSeenCoachMark = prefs.getBool('has_seen_tools_coach_mark') ?? false;
        // if (!hasSeenCoachMark && mounted) {
        //   await prefs.setBool('has_seen_tools_coach_mark', true);
        //   _showCoachMark();
        // }

        // TESTING MODE: Always show coach mark every time
        if (mounted) {
          _showCoachMark();
        }
      }

      if (!alreadySeen && mounted) {
        final config = OnboardingRegistry.getConfig(OnboardingRegistry.keyTools);
        if (config != null) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => StaticIntroDialog(
              config: config,
              onDismissed: () async {
                // 2. Mark intro as seen when dismissed
                await prefs.setBool('seen_onboarding_${OnboardingRegistry.keyTools}', true);
                if (context.mounted) {
                  Navigator.of(context).pop();
                  // Trigger coach mark after intro closes
                  await checkAndShowCoachMark();
                }
              },
            ),
          );
        } else {
          // Fallback if config is null
          await checkAndShowCoachMark();
        }
      } else {
        // If static intro was already completed, check coach mark directly
        await checkAndShowCoachMark();
      }
    });
  }

  void _showCoachMark() {
    _tutorialCoachMark = TutorialCoachMark(
      targets: _createCoachMarkTargets(),
      colorShadow: Colors.black,
      textSkip: "SKIP",
      paddingFocus: 8,
      opacityShadow: 0.75,
      onFinish: () => true,
      onSkip: () => true,
    );

    _tutorialCoachMark?.show(context: context);
  }

  List<TargetFocus> _createCoachMarkTargets() {
    return [
      // 1. Mood Tracker Target
      TargetFocus(
        identify: "Mood Tracker Target",
        keyTarget: _moodTrackerKey,
        alignSkip: Alignment.topRight,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, controller) => _buildCoachTooltip(
              title: "Mood Tracker",
              description: "A calendar based tracker to record your feelings every day",
            ),
          ),
        ],
      ),

      // 2. SOS Protocol Target
      TargetFocus(
        identify: "SOS Protocol Target",
        keyTarget: _sosProtocolKey,
        alignSkip: Alignment.topRight,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, controller) => _buildCoachTooltip(
              title: "SOS Protocol",
              description:
                  "A one-tap guided soothing process to help you focus on the present when feeling overwhelmed or having flashbacks",
            ),
          ),
        ],
      ),

      // 3. Customization Target
      TargetFocus(
        identify: "Customization Target",
        keyTarget: _customizationKey,
        alignSkip: Alignment.topLeft,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, controller) => _buildCoachTooltip(
              title: "Customization",
              description:
                  "Change your preferences for colors, layouts, icons, and pin or hide specific tools.",
            ),
          ),
        ],
      ),
    ];
  }

  Widget _buildCoachTooltip({required String title, required String description}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 8,
            offset: Offset(0, 3),
          )
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF212529),
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            description,
            style: const TextStyle(
              color: Color(0xFF6C757D),
              fontSize: 13,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }

  ToolThemeData get _currentTheme => ref.read(appThemeProvider);

  // Builds the tool cards shown on the page.
  //
  // The method filters tools according to the selected category
  // and separates pinned tools so they appear first.
  List<Widget> _buildToolWidgets({
  bool compact = false,
  List<String>? filterIds,
}) {
  final List<Widget> pinnedTools = [];
  final List<Widget> normalTools = [];

  for (final spec in registeredTools) {
    if (!_toolsRegistry.containsKey(spec.title)) continue;
    if (filterIds != null && !filterIds.contains(spec.title)) continue;

    final config = _toolsRegistry[spec.title]!;
    if (!config.isActive) continue;

    final cardWidget = _buildToolCard(
      title: spec.title,
      svgAssetPath: spec.icon,
      isPinned: config.isPinned,
      compact: compact,
      tag: spec.tag,
      onTap: () {
        // Record tool usage before opening the selected tool
        ref
            .read(studioProvider.notifier)
            .completeActivity(
              spec.studioActivityKey,
              spec.title,
            );

        if (!mounted) return;

        final targetPage = spec.customPageBuilder!(context);

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => targetPage,
          ),
        );
      },
    );

    if (config.isPinned) {
      pinnedTools.add(cardWidget);
    } else {
      normalTools.add(cardWidget);
    }
  }

  return [...pinnedTools, ...normalTools];
}

  // Creates the reusable card component used to display tools.
  //
  // The appearance changes depending on the selected layout
  // and supports custom icons uploaded by the user.
  Widget _buildToolCard({
    required String title,
    required String svgAssetPath,
    required VoidCallback onTap,
    bool isPinned = false,
    bool compact = false,
    String? tag,
  }) {
    final theme = _currentTheme;
    final config = _toolsRegistry[title];

    // Builds the icon displayed on the tool card.
    Widget buildIconFrame(double size) {
      final customPath = config?.customIconPath;
      if (customPath != null && customPath.isNotEmpty) {
        final isLocalFile = customPath.startsWith('/') ||
            customPath.contains('data/user/') ||
            customPath.contains('Application/') ||
            customPath.contains('Users\\') ||
            customPath.contains('c:');

        if (isLocalFile) {
          final file = File(customPath);
          if (file.existsSync()) {
            return Image.file(file, width: size, height: size, fit: BoxFit.contain);
          }
        } else {
          return Image.asset(customPath, width: size, height: size, fit: BoxFit.contain);
        }
      }
      return SvgPicture.asset(svgAssetPath, width: size, height: size);
    }

    return Container(
      margin: compact ? EdgeInsets.zero : const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(compact ? 20 : 16),
        boxShadow: [
          BoxShadow(
            color: theme.isDarkMode ? Colors.black26 : Colors.black.withOpacity(0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(compact ? 20 : 16),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: compact
                    ? Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          buildIconFrame(32),
                          const SizedBox(height: 8),
                          Text(
                            title,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              height: 1.1,
                              color: theme.foregroundColor,
                            ),
                          ),
                          if (tag != null) ...[
                            const SizedBox(height: 4),
                            _buildTagChip(tag, theme),
                          ],
                        ],
                      )
                    : Row(
                        children: [
                          Expanded(
                            child: Wrap(
                              crossAxisAlignment: WrapCrossAlignment.center,
                              spacing: 8,
                              runSpacing: 4,
                              children: [
                                Text(
                                  title,
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w500,
                                    color: theme.foregroundColor,
                                  ),
                                ),
                                if (tag != null) _buildTagChip(tag, theme),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          buildIconFrame(40),
                        ],
                      ),
              ),
              if (isPinned)
                Positioned(
                  top: 8,
                  right: 8,
                  child: Transform.rotate(
                    angle: 0.5,
                    child: Icon(Icons.push_pin, size: 14, color: theme.accentColor),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  // Creates small labels such as "AI" or "Optional AI"
  Widget _buildTagChip(String label, ToolThemeData theme) {
    final bool isDark = theme.isDarkMode;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withOpacity(0.12) : Colors.black.withOpacity(0.06),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: isDark ? Colors.white70 : Colors.black54,
        ),
      ),
    );
  }

  // Builds the main content area depending on the current mode
  Widget _buildMainLayout() {
    if (_isCategorized && _activeCategoryTitle == null) {
      final categoryWidgets = appCategories.map((cat) {
        return _buildToolCard(
          title: cat.title,
          svgAssetPath: cat.icon,
          compact: _currentLayout != LayoutType.list,
          onTap: () => setState(() => _activeCategoryTitle = cat.title),
        );
      }).toList();

      return _applyLayout(categoryWidgets);
    }

    List<String>? activeFilter;
    if (_isCategorized && _activeCategoryTitle != null) {
      activeFilter = appCategories.firstWhere((c) => c.title == _activeCategoryTitle).toolIds;
    }

    final tools = _buildToolWidgets(
      compact: _currentLayout != LayoutType.list,
      filterIds: activeFilter,
    );

    if (_activeCategoryTitle != null) {
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back_ios_new, size: 18, color: _currentTheme.foregroundColor),
                  onPressed: () => setState(() => _activeCategoryTitle = null),
                ),
                Text(
                  _activeCategoryTitle!,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: _currentTheme.foregroundColor),
                ),
              ],
            ),
          ),
          Expanded(child: _applyLayout(tools)),
        ],
      );
    }

    return _applyLayout(tools);
  }

  // Applies the selected display style to the tool cards.
  Widget _applyLayout(List<Widget> items) {
    switch (_currentLayout) {
      case LayoutType.grid:
        return GridView.count(
          crossAxisCount: 2,
          padding: const EdgeInsets.all(25),
          crossAxisSpacing: 15,
          mainAxisSpacing: 15,
          children: items,
        );
      case LayoutType.geometric:
        return Center(
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 280,
                height: 280,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: _currentTheme.accentColor.withOpacity(0.15)),
                ),
              ),
              ...List.generate(items.length, (index) {
                final double angle = (index * 2 * math.pi / items.length) - (math.pi / 2);
                return Transform.translate(
                  offset: Offset(130 * math.cos(angle), 130 * math.sin(angle)),
                  child: SizedBox(width: 90, height: 90, child: items[index]),
                );
              }),
              Icon(Icons.spa, color: _currentTheme.accentColor, size: 40),
            ],
          ),
        );
      case LayoutType.list:
      default:
        return ListView(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
          children: items,
        );
    }
  }

  // Creates the bottom navigation bar
  Widget _buildBottomNav() {
    final theme = _currentTheme;
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

  // Builds the complete Tools page including App Bar with Keys attached
  @override
  Widget build(BuildContext context) {
    final theme = ref.watch(appThemeProvider);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          key: _moodTrackerKey, // <-- 1. MOOD TRACKER TARGET KEY
          icon: SvgPicture.asset(
            AppIcons.calendar,
            width: 24,
            colorFilter: ColorFilter.mode(theme.foregroundColor, BlendMode.srcIn),
          ),
          onPressed: () {
            ref.read(studioProvider.notifier).completeActivity(StudioNotifier.actMoodTracker);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => MoodTrackerPage(currentTheme: theme)),
            );
          },
        ),
        title: IconButton(
          key: _sosProtocolKey, // <-- 2. SOS PROTOCOL TARGET KEY
          icon: SvgPicture.asset(
            AppIcons.sos,
            width: 36,
            colorFilter: ColorFilter.mode(theme.foregroundColor, BlendMode.srcIn),
          ),
          onPressed: () {
            ref.read(studioProvider.notifier).completeActivity(StudioNotifier.actSosProtocol);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SOSProtocolPage()),
            );
          },
        ),
        centerTitle: true,
        actions: [
          IconButton(
            key: _customizationKey, // <-- 3. CUSTOMIZATION TARGET KEY
            icon: Icon(Icons.tune_rounded, color: theme.foregroundColor, size: 30),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (modalContext) => StatefulBuilder(
                  builder: (context, setModalState) {
                    return ToolsSettingsView(
                      currentTheme: theme,
                      isCategorized: _isCategorized,
                      currentLayout: _currentLayout,
                      toolsRegistry: _toolsRegistry,
                      onCategorizedChanged: (v) {
                        setState(() => _isCategorized = v);
                        setModalState(() => _activeCategoryTitle = null);
                      },
                      onLayoutChanged: (layout) {
                        setState(() => _currentLayout = layout);
                        setModalState(() {});
                      },
                      onThemeChanged: (incomingKey) {
                        final isDark = incomingKey == "Midnight";
                        final accentName = (incomingKey == "Cloud" || incomingKey == "Midnight")
                            ? "Default"
                            : incomingKey;

                        ref.read(appThemeProvider.notifier).state = ToolThemeData(
                          accentName: accentName,
                          themeMode: isDark ? AppCanvasMode.darkMidnight : AppCanvasMode.defaultCloud,
                        );
                        setModalState(() {});
                      },
                      onToolConfigUpdated: (toolKey, isActive, isPinned, customIconPath) {
                        setState(() {
                          _toolsRegistry[toolKey] = ToolMetaConfig(
                            isActive: isActive,
                            isPinned: isPinned,
                            customIconPath: customIconPath,
                          );
                        });
                        setModalState(() {});
                      },
                    );
                  },
                ),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
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
        child: SafeArea(child: _buildMainLayout()),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }
}