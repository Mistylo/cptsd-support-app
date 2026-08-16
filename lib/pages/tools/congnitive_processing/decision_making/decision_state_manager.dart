import 'dart:math';
import 'package:flutter/material.dart';
import 'decision_model.dart';

/// Manages the application state for the Decision Making module.
///
/// This class stores the user's progress through the guided decision workflow.
/// It keeps track of user-entered options, reflection factors, emotional
/// awareness checks, and the final choice selected by the user.
class DecisionStateManager extends ChangeNotifier {
  int _currentStep = 0;

  int get currentStep => _currentStep;

  DecisionSession _session = const DecisionSession();

  DecisionSession get session => _session;

  int _currentAxiomIndex = 0;

  int get currentAxiomIndex => _currentAxiomIndex;

  /// These prompts are intended to reduce cognitive overload and encourage
  /// users to consider different perspectives when feeling uncertain.
  final List<String> decisionAxioms = const [
    "There is no perfect decision. There is only making a choice and building a reality around it.",
    "Always avoid the pathway that exposes you to a consequence you cannot survive or adapt to.",
    "Indecision is a choice. Every hour spent freezing is a choice to keep suffering the exact same way.",
    "If the best reward and worst risk live in the same option, ask: Am I willing to pay the anxiety tax for this prize?",
    "You cannot out-think the future. You can only choose a direction and trust your future self to handle the fallout."
  ];

  String get currentAxiom => decisionAxioms[_currentAxiomIndex];


  /// Checks whether an option contains both a highly positive factor and a
  /// highly concerning factor.
  ///
  /// This does not indicate that the option is good or bad. Instead, it helps
  /// identify choices where the user may benefit from additional reflection.
  bool get hasHighStakesConflict {
    for (final option in _session.options) {
      final hasHighPro = option.pros.any((p) => p.isHighIntensity);
      final hasHighCon = option.cons.any((c) => c.isHighIntensity);

      if (hasHighPro &&
          hasHighCon &&
          option.text.trim().isNotEmpty) {
        return true;
      }
    }

    return false;
  }


  /// Updates the user's selected final option.
  void selectOption(String? id) {
    final newId =
        (_session.finalChosenOptionId == id) ? null : id;

    _session = _session.copyWith(
      finalChosenOptionId: newId,
    );

    notifyListeners();
  }


  /// Clears the current decision session and returns the workflow to the
  /// initial state.
  void resetSession() {
    _session = const DecisionSession();
    _currentStep = 0;

    notifyListeners();
  }


  /// Displays another reflection prompt.
  ///
  /// A random prompt is selected to provide variety when users need additional
  /// grounding during the decision process.
  void cycleAxiom() {
    if (decisionAxioms.length <= 1) return;

    final random = Random();

    int newIndex;

    do {
      newIndex = random.nextInt(decisionAxioms.length);
    } while (newIndex == _currentAxiomIndex);

    _currentAxiomIndex = newIndex;

    notifyListeners();
  }

  /// Stores the user's current emotional awareness state
  void updateSomaticStatus(SomaticStatus status) {
    _session = _session.copyWith(
      somaticStatus: status,
    );

    notifyListeners();
  }


  /// Updates the situation the user wants to reflect on.
  void updateSituation(String situation) {
    _session = _session.copyWith(
      situation: situation,
    );

    notifyListeners();
  }


  /// Updates the description of one possible choice.
  void updateOptionText(int index, String text) {
    final updatedOptions =
        List<DecisionOption>.from(_session.options);

    updatedOptions[index] =
        updatedOptions[index].copyWith(
          text: text,
        );

    _session = _session.copyWith(
      options: updatedOptions,
    );

    notifyListeners();
  }


  /// Updates the advantages and concerns associated with an option.
  ///
  /// These factors are stored to help users compare their own thoughts and
  /// values during reflection.
  void updateOptionFactors(
    int index,
    List<EvaluationFactor> pros,
    List<EvaluationFactor> cons,
  ) {
    final updatedOptions =
        List<DecisionOption>.from(_session.options);

    updatedOptions[index] =
        updatedOptions[index].copyWith(
          pros: pros,
          cons: cons,
        );

    _session = _session.copyWith(
      options: updatedOptions,
    );

    notifyListeners();
  }


  /// Stores additional reflection questions about uncertainty and planning.
  ///
  /// These include whether a choice can be changed later, possible costs of
  /// waiting, and possible coping strategies if difficulties occur.
  void updateGroundingChecks({
    required bool isReversible,
    required List<String> costs,
    required String fallback,
  }) {
    _session = _session.copyWith(
      isReversible: isReversible,
      costsOfWaiting: costs,
      worstCaseFallback: fallback,
    );

    notifyListeners();
  }

  /// Moves to the next stage of the guided decision workflow.
  void nextStep() {
    _currentStep++;

    notifyListeners();
  }


  /// Returns to the previous stage of the workflow.
  void prevStep() {
    if (_currentStep > 0) {
      _currentStep--;

      notifyListeners();
    }
  }


  /// Saves the user's final selected option and moves to the summary stage.
  ///
  /// The application records the user's reflection outcome but does not judge
  /// whether the decision is correct.
  void commitFinalChoice(String optionId) {
    _session = _session.copyWith(
      finalChosenOptionId: optionId,
    );

    _currentStep = 6;

    notifyListeners();
  }
}