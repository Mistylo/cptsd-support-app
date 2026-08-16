import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'skill_models.dart';
import 'module_content.dart';
import 'skill_state_provider.dart';
import 'package:cptsd_app/config/claude_service_provider.dart';
import 'ai_support_workspace_view.dart';
import 'package:cptsd_app/pages/tools/theme_provider.dart';

// Presents interactive reflection questions following the learning content,
// provides educational feedback for each response, and displays a completion
// summary with optional access to AI-assisted reflection.

class ReflectionQuizView extends ConsumerWidget {
  final SkillModuleType moduleType;

  const ReflectionQuizView({
    super.key,
    required this.moduleType,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(appThemeProvider);
    final module = InterpersonalSkillsData.modules.firstWhere((m) => m.type == moduleType);
    final sessionState = ref.watch(skillSessionProvider(moduleType));
    final sessionNotifier = ref.read(skillSessionProvider(moduleType).notifier);

    final bool isDarkBackground = ThemeData.estimateBrightnessForColor(theme.bottomColor) == Brightness.dark;
    final Color textColor = isDarkBackground ? Colors.white.withOpacity(0.9) : Colors.black87;
    final Color subTextColor = isDarkBackground ? Colors.white60 : Colors.grey.shade600;
    final Color cardBackgroundColor = isDarkBackground ? const Color(0xFF1E1E1E) : Colors.white;

    if (sessionState.currentQuizSet.isEmpty) {
      return Scaffold(
        backgroundColor: cardBackgroundColor,
        body: Center(child: Text('No reflection questions loaded.', style: TextStyle(color: textColor))),
      );
    }

   // Display a fallback screen if no quiz questions are available for the selected module
    if (sessionState.isQuizCompleted) {
      return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          title: Text('Reflection Complete', style: TextStyle(color: theme.accentColor, fontWeight: FontWeight.bold, fontSize: 18)),
          elevation: 0,
          backgroundColor: Colors.transparent,
          iconTheme: IconThemeData(color: theme.accentColor),
          automaticallyImplyLeading: true,
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
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Summary Reflection',
                            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: theme.accentColor),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            module.completionReflection,
                            style: TextStyle(height: 1.6, fontSize: 15, color: textColor),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.accentColor,
                      foregroundColor: ThemeData.estimateBrightnessForColor(theme.accentColor) == Brightness.dark 
                          ? Colors.white 
                          : Colors.black87,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 0,
                    ),
                    child: const Text('Back to Dashboard', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 16),

                  // Offer optional AI-assisted reflection after completing the learning activity
                  Card(
                    color: cardBackgroundColor,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                      side: BorderSide(color: isDarkBackground ? Colors.white10 : Colors.grey.shade200),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Text(
                            'Need help applying these ideas to your own situation?',
                            style: TextStyle(color: subTextColor, fontSize: 13, height: 1.4),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 12),
                          OutlinedButton(
                            onPressed: () {
                              ref.read(globalAIGeneratorProvider.notifier).clear();
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => AiSupportWorkspaceView(moduleType: moduleType),
                                ),
                              );
                            },
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: theme.accentColor, width: 1.2),
                              foregroundColor: theme.accentColor,
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                            child: const Text('Open AI Support Room', style: TextStyle(fontWeight: FontWeight.bold)),
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

    // Display the completion summary after all reflection questions have been answered
    final currentIndex = sessionState.currentQuestionIndex;
    final QuizQuestion activeQuestion = sessionState.currentQuizSet[currentIndex] as QuizQuestion;
    // Prevent users from progressing until an answer has been selected
    final hasAnswered = sessionState.selectedAnswerIndex != null;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text('${module.title} Drill', style: TextStyle(color: theme.accentColor, fontWeight: FontWeight.bold, fontSize: 18)),
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
                Text(
                  'Question ${currentIndex + 1} of 3',
                  style: TextStyle(color: subTextColor, fontSize: 13, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 12),
                Text(
                  activeQuestion.questionText,
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18, color: textColor, height: 1.4),
                ),
                const SizedBox(height: 20),

                // Build the list of answer options for the current reflection question
                Expanded(
                  child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: activeQuestion.options.length,
                    itemBuilder: (context, index) {
                      final isThisOptionSelected = sessionState.selectedAnswerIndex == index;
                      final isThisCorrectAnswer = activeQuestion.correctOptionIndex == index;

                      Color dotColor = isDarkBackground ? Colors.white30 : Colors.grey.shade300; 
                      if (hasAnswered) {
                        if (isThisCorrectAnswer) {
                          dotColor = const Color(0xFF2E7D32);
                        } else if (isThisOptionSelected) {
                          dotColor = Colors.grey.shade500;
                        }
                      } else if (isThisOptionSelected) {
                        dotColor = theme.accentColor;
                      }

                      return Container(
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        decoration: BoxDecoration(
                          color: isThisOptionSelected 
                              ? (isDarkBackground ? Colors.white.withOpacity(0.05) : Colors.grey.shade50) 
                              : cardBackgroundColor,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isThisOptionSelected 
                                ? theme.accentColor.withOpacity(0.7)
                                : (isDarkBackground ? Colors.white10 : Colors.grey.shade200),
                            width: isThisOptionSelected ? 1.5 : 1.0,
                          ),
                        ),
                        child: ListTile(
                          onTap: () => sessionNotifier.selectAnswer(index), // The selected answer is locked after the first choice to encourage thoughtful reflection.
                          leading: Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              color: dotColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                          title: Text(
                            activeQuestion.options[index],
                            style: TextStyle(color: textColor, fontSize: 14, height: 1.3),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // Display educational feedback explaining the recommended answer after a selection is made
                if (hasAnswered) ...[
                  Container(
                    padding: const EdgeInsets.all(16),
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: cardBackgroundColor,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: isDarkBackground ? Colors.white10 : Colors.grey.shade100),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          sessionState.selectedAnswerIndex == activeQuestion.correctOptionIndex
                              ? 'Correct Choice'
                              : 'Recommended Choice',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: sessionState.selectedAnswerIndex == activeQuestion.correctOptionIndex
                                ? const Color(0xFF2E7D32)
                                : theme.accentColor,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          activeQuestion.rationale, // Each question provides a rationale to reinforce the learning objective rather than simply indicating correctness
                          style: TextStyle(height: 1.4, fontSize: 13, color: textColor.withOpacity(0.9)),
                        ),
                      ],
                    ),
                  ),
                ],

                // Navigation controls for restarting the quiz or progressing to the next question
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton.icon(
                      onPressed: () => sessionNotifier.restartQuiz(), 
                      style: TextButton.styleFrom(foregroundColor: theme.accentColor),
                      icon: const Icon(Icons.refresh, size: 16),
                      label: const Text('Reshuffle Pool', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                    ),
                    ElevatedButton(
                      onPressed: hasAnswered ? () => sessionNotifier.nextQuestion() : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.accentColor,
                        foregroundColor: ThemeData.estimateBrightnessForColor(theme.accentColor) == Brightness.dark 
                            ? Colors.white 
                            : Colors.black87,
                        disabledBackgroundColor: isDarkBackground ? Colors.white10 : Colors.grey.shade200,
                        disabledForegroundColor: subTextColor.withOpacity(0.5),
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        elevation: 0,
                      ),
                      child: Text(
                        currentIndex == 2 ? 'Finish' : 'Next Question',
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