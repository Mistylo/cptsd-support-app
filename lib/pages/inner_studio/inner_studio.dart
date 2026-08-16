import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cptsd_app/resources.dart';
import 'package:cptsd_app/pages/tools/tools_page.dart';
import 'inner_studio_provider.dart';
import 'sticker_book.dart';
import 'custom_sticker_creator_page.dart'; 
import 'package:cptsd_app/pages/tools/theme_provider.dart';
import 'package:cptsd_app/pages/sos_function/sos_protocol_page.dart';
import 'package:cptsd_app/pages/profile/profile_page.dart';
import 'package:cptsd_app/pages/education/education_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cptsd_app/onboarding/onboarding_registry.dart'; 
import 'package:cptsd_app/onboarding/static_intro_dialog.dart';

// Provides additional display information based on the current progress stage.
// The labels and images are updated according to the user's completion progress
extension StudioStateX on StudioState {
  String get canvasPhaseLabel {
    if (percentage <= 0.25) return "Blueprint Phasing";
    if (percentage <= 0.50) return "Inking Canvas Linework";
    if (percentage <= 0.75) return "Color Refinement";
    return "Polishing Surface Details";
  }

  String get phaseImageAsset {
    if (percentage <= 0.25) return AppImages.phase1;
    if (percentage <= 0.50) return AppImages.phase2;
    if (percentage <= 0.75) return AppImages.phase3;
    return AppImages.phase4;
  }
}

// Displays a popup notification when the user unlocks a new sticker.
// The dialog provides feedback and allows the user to view the sticker collection.
void showUnlockDialog(BuildContext context, StudioState state, WidgetRef ref) {
  final newestSticker = state.collectedStickers.isNotEmpty ? state.collectedStickers.first : null;
  final String assetPath = newestSticker?.imagePath ?? AppImages.rewardStickers[0];
  final String titleText = newestSticker?.isMilestone == true ? "Milestone Achieved!" : "Souvenir Completed!";

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (dialogContext) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      content: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.stars, color: Colors.amber, size: 48),
            const SizedBox(height: 16),
            Text(titleText, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, letterSpacing: 0.5), textAlign: TextAlign.center),
            const SizedBox(height: 12),
            Text(
              state.congratulationsMessage ?? "Congratulations! You've unlocked a new sticker through your continuous practice.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[700], fontSize: 14, height: 1.4),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.purple[50]?.withValues(alpha: 0.5), borderRadius: BorderRadius.circular(16)),
              child: Image.asset(assetPath, height: 120, fit: BoxFit.contain),
            ),
          ],
        ),
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Column(
            children: [
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple[200],
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: () {
                    ref.read(studioProvider.notifier).clearCongratulationsMessage();
                    Navigator.pop(dialogContext);
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const StickerBook()));
                  },
                  child: const Text("Open Sticker Book", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () {
                    ref.read(studioProvider.notifier).clearCongratulationsMessage();
                    Navigator.pop(dialogContext);
                  },
                  child: Text("Keep Crafting", style: TextStyle(color: Colors.grey[600], fontWeight: FontWeight.w600)),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

// Main page of the Inner Studio feature.
// This page visualises progress, displays the current workbench state,
// and provides access to sticker-related functions.
class InnerStudioPage extends ConsumerStatefulWidget {
  const InnerStudioPage({super.key});

  @override
  ConsumerState<InnerStudioPage> createState() => _InnerStudioPageState();
}

class _InnerStudioPageState extends ConsumerState<InnerStudioPage> {
  final int _selectedIndex = 1;

  @override
  void initState() {
    super.initState();

    // Trigger onboarding dialog ONLY on first visit
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final prefs = await SharedPreferences.getInstance();
      
      // Check if Inner Studio onboarding has already been completed or seen
      final bool alreadySeen = prefs.getBool('seen_onboarding_${OnboardingRegistry.keyInnerStudio}') ?? false;
      if (!alreadySeen && mounted) {
        final config = OnboardingRegistry.getConfig(OnboardingRegistry.keyInnerStudio);
        if (config != null) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => StaticIntroDialog(
              config: config,
              onDismissed: () async {
                // 2. Save preference when dismissed
                await prefs.setBool('seen_onboarding_${OnboardingRegistry.keyInnerStudio}', true);
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
    final studioState = ref.watch(studioProvider);
    final theme = ref.watch(appThemeProvider);
    final double completionPercent = studioState.percentage;
    final bool isReady = studioState.isReady; 

    ref.listen<StudioState>(studioProvider, (previous, next) {
      if (next.congratulationsMessage != null && 
          next.congratulationsMessage != previous?.congratulationsMessage && 
          mounted) {
        showUnlockDialog(context, next, ref);
      }
    });

    Widget workbenchImage = isReady 
        ? Image.asset(AppImages.phase5, key: const ValueKey('ready'), fit: BoxFit.contain)
        : studioState.isShowingMilestone
            ? Image.asset(AppImages.milestoneStickers[studioState.pendingMilestoneActivityId] ?? AppImages.rewardStickers[0], fit: BoxFit.contain)
            : Image.asset(studioState.phaseImageAsset, fit: BoxFit.contain);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.collections_bookmark_rounded, color: Color(0xFF262626), size: 26),
          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const StickerBook())),
        ),
        title: IconButton(
          icon: SvgPicture.asset(AppIcons.sos, width: 36),
          onPressed: () {
            ref.read(studioProvider.notifier).completeActivity(StudioNotifier.actSosProtocol);
            Navigator.push(context, MaterialPageRoute(builder: (context) => const SOSProtocolPage()));
          },
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.auto_awesome, color: Color(0xFF262626), size: 26),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const CustomStickerCreatorPage())),
          ),
        ],
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          Positioned.fill(child: Image.asset(AppImages.workspace, fit: BoxFit.cover)),
          Center(
            child: GestureDetector(
              onTap: isReady ? () => ref.read(studioProvider.notifier).handleWorkbenchCollection("") : null,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: MediaQuery.of(context).size.width * 0.8,
                height: MediaQuery.of(context).size.width * 0.9,
                decoration: BoxDecoration(
                  color: isReady ? Colors.white : Colors.white.withValues(alpha: 0.92),
                  borderRadius: BorderRadius.circular(24),
                  border: isReady ? Border.all(color: Colors.purple[200]!, width: 2) : null,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      studioState.isShowingMilestone ? "MILESTONE UNLOCKED" : (isReady ? "STICKER COMPLETED" : studioState.canvasPhaseLabel.toUpperCase()),
                      style: TextStyle(letterSpacing: 2, fontSize: 11, fontWeight: FontWeight.bold, color: isReady ? Colors.purple[300] : Colors.black87),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(height: 180, child: AnimatedSwitcher(duration: const Duration(milliseconds: 400), child: workbenchImage)),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 30,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.85,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.95), borderRadius: BorderRadius.circular(30)),
              child: Row(
                children: [
                  Icon(Icons.brush, size: 18, color: isReady ? Colors.purple[200] : Colors.brown),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: LinearProgressIndicator(value: completionPercent, backgroundColor: Colors.grey[200], color: isReady ? Colors.green[300] : Colors.purple[100], minHeight: 8),
                    ),
                  ),
                  Icon(Icons.check_circle, size: 22, color: isReady ? Colors.green : Colors.grey[300]),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNav(theme),
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