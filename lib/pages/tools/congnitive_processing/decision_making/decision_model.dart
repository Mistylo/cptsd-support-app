// This file defines the core data structures used by the trauma-informed
// decision reflection feature.

enum SomaticStatus {
  unselected,
  clear,
  anxiousFrozen,
}

/// Represents a factor that the user identifies as relevant to a decision.
class EvaluationFactor {
  final String text;

  // Indicates that the user considers this factor especially important.
  // It does not represent a system judgement about the factor.
  final bool isHighIntensity;

  const EvaluationFactor({
    required this.text,
    this.isHighIntensity = false,
  });
}

/// Represents one possible choice in the decision reflection process.
class DecisionOption {
  final String id;
  final String text;
  final List<EvaluationFactor> pros;
  final List<EvaluationFactor> cons;

  const DecisionOption({
    required this.id,
    this.text = '',
    this.pros = const [],
    this.cons = const [],
  });

  /// Calculates the number of important factors associated with this option.
  int get reflectionWeight {
    int weight = 0;

    for (var pro in pros) {
      weight += pro.isHighIntensity ? 2 : 1;
    }

    for (var con in cons) {
      weight += con.isHighIntensity ? 2 : 1;
    }

    return weight;
  }

  /// Creates an updated copy of the option while keeping the same identifier.
  DecisionOption copyWith({
    String? text,
    List<EvaluationFactor>? pros,
    List<EvaluationFactor>? cons,
  }) {
    return DecisionOption(
      id: id,
      text: text ?? this.text,
      pros: pros ?? this.pros,
      cons: cons ?? this.cons,
    );
  }
}

/// Stores the user's progress and reflections during the decision activity.
class DecisionSession {
  final String situation;
  final SomaticStatus somaticStatus;
  final List<DecisionOption> options;

  final bool isReversible;
  final List<String> costsOfWaiting;
  final String worstCaseFallback;
  final String? finalChosenOptionId;

  const DecisionSession({
    this.situation = '',
    this.somaticStatus = SomaticStatus.unselected,
    this.options = const [
      DecisionOption(id: 'A'),
      DecisionOption(id: 'B'),
      DecisionOption(id: 'C'),
    ],
    this.isReversible = true,
    this.costsOfWaiting = const [],
    this.worstCaseFallback = '',
    this.finalChosenOptionId,
  });

  /// Creates a modified session while preserving unchanged user progress.
  DecisionSession copyWith({
    String? situation,
    SomaticStatus? somaticStatus,
    List<DecisionOption>? options,
    bool? isReversible,
    List<String>? costsOfWaiting,
    String? worstCaseFallback,
    String? finalChosenOptionId,
  }) {
    return DecisionSession(
      situation: situation ?? this.situation,
      somaticStatus: somaticStatus ?? this.somaticStatus,
      options: options ?? this.options,
      isReversible: isReversible ?? this.isReversible,
      costsOfWaiting: costsOfWaiting ?? this.costsOfWaiting,
      worstCaseFallback: worstCaseFallback ?? this.worstCaseFallback,
      finalChosenOptionId: finalChosenOptionId ?? this.finalChosenOptionId,
    );
  }
}