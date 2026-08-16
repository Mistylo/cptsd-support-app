import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'skill_models.dart';
import 'module_content.dart';

// Manages the runtime state of each learning session, including lesson
// navigation, quiz progression, answer selection, and randomized question
// generation using Riverpod state management.

/// Stores the immutable UI state for an individual learning module session
class SkillSessionState {
  // Randomly selects a subset of quiz questions to provide variation
  // across repeated learning sessions
  final List<QuizQuestion> currentQuizSet;
  final int currentCardIndex;
  final int currentQuestionIndex;
  final int? selectedAnswerIndex;
  final bool isQuizCompleted;

  const SkillSessionState({
    required this.currentQuizSet,
    this.currentCardIndex = 0,
    this.currentQuestionIndex = 0,
    this.selectedAnswerIndex,
    this.isQuizCompleted = false,
  });

  SkillSessionState copyWith({
    List<QuizQuestion>? currentQuizSet,
    int? currentCardIndex,
    int? currentQuestionIndex,
    int? selectedAnswerIndex,
    bool clearSelectedAnswer = false,
    bool? isQuizCompleted,
  }) {
    return SkillSessionState(
      currentQuizSet: currentQuizSet ?? this.currentQuizSet,
      currentCardIndex: currentCardIndex ?? this.currentCardIndex,
      currentQuestionIndex: currentQuestionIndex ?? this.currentQuestionIndex,
      selectedAnswerIndex: clearSelectedAnswer ? null : (selectedAnswerIndex ?? this.selectedAnswerIndex),
      isQuizCompleted: isQuizCompleted ?? this.isQuizCompleted,
    );
  }
}

/// Manages learning module progression, quiz state, and user interactions
class SkillSessionNotifier extends FamilyNotifier<SkillSessionState, SkillModuleType> {
  @override
  SkillSessionState build(SkillModuleType arg) {
    return SkillSessionState(
      currentQuizSet: _getRandomQuestions(arg),
    );
  }

  List<QuizQuestion> _getRandomQuestions(SkillModuleType moduleType) {
    final module = InterpersonalSkillsData.modules.firstWhere((m) => m.type == moduleType);
    final questions = List<QuizQuestion>.from(module.quizQuestions);
    if (questions.isEmpty) return [];
    
    questions.shuffle();
    return questions.take(3).toList();
  }

  // Learning card navigation
  void setCardIndex(int index) {
    state = state.copyWith(currentCardIndex: index);
  }

  void nextCard(int maxCards) {
    if (state.currentCardIndex < maxCards - 1) {
      state = state.copyWith(currentCardIndex: state.currentCardIndex + 1);
    }
  }

  void previousCard() {
    if (state.currentCardIndex > 0) {
      state = state.copyWith(currentCardIndex: state.currentCardIndex - 1);
    }
  }

  // Quiz progression and answer handling
  void selectAnswer(int index) {
    if (state.selectedAnswerIndex != null) return; // Prevents users from changing their answer after making a selection
    state = state.copyWith(selectedAnswerIndex: index);
  }

  void nextQuestion() {
    final totalQuestions = state.currentQuizSet.length;
    if (state.currentQuestionIndex < totalQuestions - 1) {
      state = state.copyWith(
        currentQuestionIndex: state.currentQuestionIndex + 1,
        clearSelectedAnswer: true,
      );
    } else {
      state = state.copyWith(isQuizCompleted: true);
    }
  }

  // Starts a new quiz session while preserving the user's current
  // position within the learning content.
  void restartQuiz() {
    state = SkillSessionState(
      currentQuizSet: _getRandomQuestions(arg),
      currentCardIndex: state.currentCardIndex,
    );
  }
}

final skillSessionProvider = NotifierProvider.family<SkillSessionNotifier, SkillSessionState, SkillModuleType>(
  SkillSessionNotifier.new,
);