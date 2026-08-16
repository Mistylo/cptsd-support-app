import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'skill_models.dart';
import 'skill_state_provider.dart';
import 'learning_canvas_view.dart';
import 'ai_support_workspace_view.dart';
import 'package:cptsd_app/config/claude_service_provider.dart';
import 'package:cptsd_app/pages/tools/theme_provider.dart';
import 'package:cptsd_app/pages/inner_studio/inner_studio_provider.dart';

// Hub page for user to enter the Interpersonal Skills Function and select a module
class SkillHubPage extends ConsumerWidget {
  const SkillHubPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(appThemeProvider);
    final isDark = ThemeData.estimateBrightnessForColor(theme.bottomColor) == Brightness.dark;
    final textColor = isDark ? Colors.white.withOpacity(0.9) : Colors.black87;
    final subTextColor = isDark ? Colors.white60 : Colors.black54;

    // Defines the learning modules displayed in the hub page.
    // Each module contains its title, description, icon, and corresponding learning workflow.
    final modules = [
      (
        type: SkillModuleType.boundaries,
        title: 'Module 1: Boundaries',
        subtitle: 'Understanding personal limits and learning how to say no safely.',
        icon: Icons.shield_outlined,
      ),
      (
        type: SkillModuleType.unhealthyRelationships,
        title: 'Module 2: Unhealthy Relationships',
        subtitle: 'Identifying common unhealthy relationship patterns like manipulation or gaslighting.',
        icon: Icons.warning_amber_rounded,
      ),
      (
        type: SkillModuleType.assertiveCommunication,
        title: 'Module 3: Assertive Communication',
        subtitle: 'Learning how to express needs respectfully and handle conflicts.',
        icon: Icons.chat_bubble_outline,
      ),
    ];

    // Initializes a new learning session, records the activity for progress tracking,
    // and navigates to the selected learning module.
    void openModule(SkillModuleType type) {
      ref.read(studioProvider.notifier).completeActivity(StudioNotifier.actInterpersonalSkills, "Interpersonal Skills");
      ref.read(skillSessionProvider(type).notifier).restartQuiz();
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => LearningCanvasView(moduleType: type)),
      );
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text('Interpersonal Skills', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: theme.accentColor)),
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: theme.accentColor),
      ),
      body: Container(
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
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ...modules.map((m) => Card(
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  elevation: isDark ? 0 : 2,
                  color: isDark ? const Color(0xFF2C2C2C) : Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: isDark ? BorderSide.none : BorderSide(color: Colors.grey.shade200),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    leading: Icon(m.icon, color: theme.accentColor),
                    title: Text(m.title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: textColor)),
                    subtitle: Text(m.subtitle, style: TextStyle(color: subTextColor, fontSize: 13)),
                    trailing: Icon(Icons.arrow_forward_ios, size: 14, color: theme.accentColor),
                    onTap: () => openModule(m.type),
                  ),
                )),
                
                const SizedBox(height: 20),
                Divider(color: textColor.withOpacity(0.15)),
                const SizedBox(height: 20),

                // AI Support Workspace Card
                Card(
                  elevation: 0,
                  color: theme.accentColor.withOpacity(0.12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                    side: BorderSide(color: theme.accentColor.withOpacity(0.2)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.psychology, color: theme.accentColor, size: 28),
                            const SizedBox(width: 12),
                            Text('AI Support Workspace', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: theme.accentColor)),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text('Need help applying these ideas to your own situation?', style: TextStyle(color: textColor, fontSize: 13)),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            // Clears any previous AI conversation to ensure each support session starts with a fresh context
                            ref.read(globalAIGeneratorProvider.notifier).clear();
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (_) => const AiSupportWorkspaceView(moduleType: SkillModuleType.boundaries)),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: theme.accentColor,
                            foregroundColor: ThemeData.estimateBrightnessForColor(theme.accentColor) == Brightness.dark ? Colors.white : Colors.black87,
                            minimumSize: const Size.fromHeight(44),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            elevation: 0,
                          ),
                          child: const Text('Need More Support?', style: TextStyle(fontWeight: FontWeight.bold)),
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
}