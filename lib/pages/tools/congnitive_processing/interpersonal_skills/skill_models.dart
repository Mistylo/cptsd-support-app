// Defines the core data structures used throughout the Interpersonal Skills
// feature, including learning modules, educational cards, reflection questions,
// and module metadata.

// Identifies the available interpersonal skills learning modules
enum SkillModuleType {
  boundaries,
  unhealthyRelationships,
  assertiveCommunication,
}

// Represents a single educational card within a learning module
class LearningCard {
  final String title;
  final String description;
  // Optional supplementary points displayed beneath the main learning content.
  final List<String> bulletPoints; 

  const LearningCard({
    required this.title,
    required this.description,
    this.bulletPoints = const [],
  });
}

// Represents an individual knowledge-check question for a learning module
class QuizQuestion {
  final String questionText;
  final List<String> options;
  final int correctOptionIndex;
  final String rationale;

  const QuizQuestion({
    required this.questionText,
    required this.options,
    required this.correctOptionIndex,
    required this.rationale,
  });
}

// Represents the complete content structure of a learning module, including
// educational material, quiz questions, and completion reflection
class SkillModule {
  final SkillModuleType type;
  final String title;
  final String description;
  final List<LearningCard> cards;
  final List<QuizQuestion> quizQuestions;
  // Reflection message displayed after completing the learning module
  final String completionReflection; 

  const SkillModule({
    required this.type,
    required this.title,
    required this.description,
    required this.cards,
    required this.quizQuestions,
    required this.completionReflection,
  });
}