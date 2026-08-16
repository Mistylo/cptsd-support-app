import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'skill_models.dart';
import 'module_content.dart';
import 'skill_state_provider.dart';
import 'reflection_quiz_view.dart';
import 'package:cptsd_app/pages/tools/theme_provider.dart';

// Displays the educational content for the selected interpersonal skills
// module using a card-based learning interface with guided navigation before
// progressing to the reflection quiz.

class LearningCanvasView extends ConsumerWidget {
  final SkillModuleType moduleType;

  const LearningCanvasView({
    super.key,
    required this.moduleType,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(appThemeProvider);
    // Retrieves the learning content associated with the selected module
    final module = InterpersonalSkillsData.modules.firstWhere((m) => m.type == moduleType);
    // Observes the current learning session state, including card progression
    final sessionState = ref.watch(skillSessionProvider(moduleType));
    final currentCardIndex = sessionState.currentCardIndex;
    final activeCard = module.cards[currentCardIndex];
    final sessionNotifier = ref.read(skillSessionProvider(moduleType).notifier);

    final bool isDarkBackground = ThemeData.estimateBrightnessForColor(theme.bottomColor) == Brightness.dark;
    final Color textColor = isDarkBackground ? Colors.white.withOpacity(0.9) : Colors.black87;
    final Color subTextColor = isDarkBackground ? Colors.white60 : Colors.grey.shade600;
    final Color cardBackgroundColor = isDarkBackground ? const Color(0xFF1E1E1E) : Colors.white;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          module.title,
          style: TextStyle(color: theme.accentColor, fontWeight: FontWeight.bold, fontSize: 18),
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
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Visual progress indicator showing the user's position within the learning module
                LinearProgressIndicator(
                  value: (currentCardIndex + 1) / module.cards.length,
                  backgroundColor: isDarkBackground ? Colors.white10 : Colors.grey.shade200,
                  valueColor: AlwaysStoppedAnimation<Color>(theme.accentColor),
                  minHeight: 6,
                  borderRadius: BorderRadius.circular(3),
                ),
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    'Card ${currentCardIndex + 1} of ${module.cards.length}',
                    style: TextStyle(color: subTextColor, fontSize: 12, fontWeight: FontWeight.w500),
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: Card(
                    color: cardBackgroundColor,
                    elevation: isDarkBackground ? 0 : 1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: isDarkBackground ? BorderSide.none : BorderSide(color: Colors.grey.shade100),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Align(
                              alignment: Alignment.center,
                              child: Text(
                                activeCard.title,
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: theme.accentColor),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              activeCard.description,
                              style: TextStyle(height: 1.6, fontSize: 15, color: textColor),
                            ),
                            // Displays optional supplementary learning points when provided.
                            if (activeCard.bulletPoints.isNotEmpty) ...[
                              const SizedBox(height: 20),
                              ...activeCard.bulletPoints.map((bulletText) => Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 6.0),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('• ', style: TextStyle(fontWeight: FontWeight.bold, color: theme.accentColor, fontSize: 18)),
                                        Expanded(
                                          child: Text(
                                            bulletText,
                                            style: TextStyle(
                                              fontStyle: bulletText.startsWith('"') ? FontStyle.italic : FontStyle.normal,
                                              height: 1.5,
                                              fontSize: 14,
                                              color: textColor.withOpacity(0.95),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: currentCardIndex > 0 ? () => sessionNotifier.previousCard() : null,
                      style: TextButton.styleFrom(
                        foregroundColor: theme.accentColor,
                        disabledForegroundColor: subTextColor.withOpacity(0.4),
                      ),
                      child: const Text('Previous', style: TextStyle(fontWeight: FontWeight.w600)),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (currentCardIndex < module.cards.length - 1) {
                          sessionNotifier.nextCard(module.cards.length);
                        } else {
                          // Launches the reflection quiz after all learning cards have been completed
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => ReflectionQuizView(moduleType: moduleType),
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.accentColor,
                        foregroundColor: ThemeData.estimateBrightnessForColor(theme.accentColor) == Brightness.dark
                            ? Colors.white
                            : Colors.black87,
                        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        elevation: 0,
                      ),
                      child: Text(
                        currentCardIndex == module.cards.length - 1 ? 'Start Exercise' : 'Next',
                        style: const TextStyle(fontWeight: FontWeight.bold),
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
}