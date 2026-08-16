import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'decision_components.dart';
import 'package:cptsd_app/pages/tools/theme_provider.dart';

// This file implements the user interface for the trauma-informed
// decision reflection feature.
//
// The workflow supports users in organising difficult decisions by:
// 1. Identifying possible options
// 2. Exploring personal benefits and concerns
// 3. Reflecting on preferences and important considerations
//
// The feature is designed as a self reflection aid rather than
// an automated decision-making system.
class DecisionFactor {
  final String text;
  final bool isPro;
  final bool isHighIntensity;

  DecisionFactor({
    required this.text,
    required this.isPro,
    required this.isHighIntensity,
  });
}

/// Represents one possible pathway being considered by the user.
class DecisionOption {
  final String id;
  final String title;
  final List<DecisionFactor> factors;

  DecisionOption({
    required this.id,
    required this.title,
    List<DecisionFactor>? factors,
  }) : factors = factors ?? [];

  /// Indicates whether this option contains a particularly meaningful
  /// positive consideration identified by the user
  bool get hasImportantBenefit =>
      factors.any((f) => f.isPro && f.isHighIntensity);

  /// Indicates whether this option contains a particularly important
  /// concern identified by the user
  bool get hasImportantConcern =>
      factors.any((f) => !f.isPro && f.isHighIntensity);

  /// Highlights options containing both meaningful benefits and concerns
  bool get hasImportantTradeOff =>
      hasImportantBenefit && hasImportantConcern;
}

class DecisionMakingPage extends ConsumerStatefulWidget {
  const DecisionMakingPage({super.key});

  @override
  ConsumerState<DecisionMakingPage> createState() =>
      _DecisionMakingPageState();
}

class _DecisionMakingPageState extends ConsumerState<DecisionMakingPage> {
  // Tracks progress through the guided reflection workflow
  int _currentStep = 1;

  // Controllers temporarily store user input before adding it
  // into the current reflection session.
  final TextEditingController _optionController = TextEditingController();
  final TextEditingController _factorController = TextEditingController();

  // Stores user-created options and reflection points during the session
  final List<DecisionOption> _options = [];

  // The option currently being explored during the reflection stage
  int _selectedOptionIndex = 0;

  // Determines whether the next reflection point represents a benefit or a concern
  bool _isAddingPro = true;

  // Allows users to mark particularly meaningful considerations
  bool _isHighIntensity = false;

  // Stores the option selected by the user after completing reflection
  String? _finalChosenOptionId;

  @override
  void dispose() {
    _optionController.dispose();
    _factorController.dispose();
    super.dispose();
  }

  void _addOption() {
    final text = _optionController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _options.add(
        DecisionOption(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          title: text,
        ),
      );
      _optionController.clear();
    });
  }

  void _addFactor() {
    final text = _factorController.text.trim();
    if (text.isEmpty || _options.isEmpty) return;

    setState(() {
      _options[_selectedOptionIndex].factors.add(
        DecisionFactor(
          text: text,
          isPro: _isAddingPro,
          isHighIntensity: _isHighIntensity,
        ),
      );

      _factorController.clear();
      // Reset importance marker after adding a factor
      // so each reflection point is considered independently
      _isHighIntensity = false;
    });
  }

  void _nextStep() {
    if (_currentStep == 1 && _options.length < 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please add at least 2 options to compare."),
        ),
      );
      return;
    }

    if (_currentStep < 3) {
      setState(() {
        _currentStep++;
      });
    }
  }

  void _prevStep() {
    if (_currentStep > 1) {
      setState(() {
        _currentStep--;
      });
    }
  }

  void _completeDecision() {
    // Ensure the user selected a decision path before closing
    if (_finalChosenOptionId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please select an option before completing."),
        ),
      );
      return;
    }
    Navigator.of(context).pop(_finalChosenOptionId);
  }

  @override
  Widget build(BuildContext context) {
    // Retrieve shared theme settings so this tool follows
    // the visual style of the rest of the application
    final theme = ref.watch(appThemeProvider);

    final Color accentColor = theme.accentColor;
    final Color textColor = theme.foregroundColor;
    final Color subTextColor = theme.subtitleColor;
    final Color cardBgColor = theme.cardColor;

    final Color cardBorderColor =
        theme.isDarkMode ? Colors.white12 : Colors.black12;

    // Detects options containing competing important factors
    final bool hasTradeOff =
        _options.any((option) => option.hasImportantTradeOff);

    return Container(
      decoration: BoxDecoration(
        gradient: theme.backgroundGradient,
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text(
            "Decision Reflection",
            style: TextStyle(color: textColor),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: IconThemeData(color: textColor),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                DecisionStepHeader(
                  currentStep: _currentStep,
                  onBack: _prevStep,
                ),
                const GroundingBanner(),
                const SizedBox(height: 16),

                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Stage 1: Identifying possible options
                        if (_currentStep == 1) ...[
                          Text(
                            "What options are you considering?",
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: textColor,
                                ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: _optionController,
                                  style: TextStyle(color: textColor),
                                  decoration: InputDecoration(
                                    hintText:
                                        "Enter an option (e.g. Accept Job A)",
                                    hintStyle: TextStyle(color: subTextColor),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: cardBorderColor),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: accentColor),
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 12,
                                    ),
                                  ),
                                  onSubmitted: (_) => _addOption(),
                                ),
                              ),
                              const SizedBox(width: 8),
                              IconButton(
                                style: IconButton.styleFrom(
                                  backgroundColor: accentColor,
                                  foregroundColor: theme.buttonTextColor,
                                ),
                                onPressed: _addOption,
                                icon: const Icon(Icons.add),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: _options.length,
                            itemBuilder: (context, index) {
                              final option = _options[index];
                              return Card(
                                color: cardBgColor,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  side: BorderSide(color: cardBorderColor),
                                ),
                                child: ListTile(
                                  leading: CircleAvatar(
                                    backgroundColor: theme.accentHighlightColor,
                                    child: Text(
                                      "${index + 1}",
                                      style: TextStyle(
                                        color: accentColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  title: Text(
                                    option.title,
                                    style: TextStyle(color: textColor),
                                  ),
                                  trailing: IconButton(
                                    icon: Icon(
                                      Icons.delete_outline,
                                      color:
                                          Theme.of(context).colorScheme.error,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _options.removeAt(index);
                                      });
                                    },
                                  ),
                                ),
                              );
                            },
                          ),
                        ],

                        // Stage 2: Exploring benefits and concerns
                        if (_currentStep == 2) ...[
                          Text(
                            "Explore benefits and concerns",
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: textColor,
                                ),
                          ),
                          const SizedBox(height: 12),

                          // Switch between options while adding reflections
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: List.generate(_options.length, (index) {
                                final selected = _selectedOptionIndex == index;
                                return Padding(
                                  padding: const EdgeInsets.only(right: 8),
                                  child: ChoiceChip(
                                    label: Text(_options[index].title),
                                    selected: selected,
                                    selectedColor: theme.accentHighlightColor,
                                    backgroundColor: cardBgColor,
                                    labelStyle: TextStyle(
                                      color: selected ? accentColor : textColor,
                                      fontWeight: selected
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                    ),
                                    onSelected: (_) {
                                      setState(() {
                                        _selectedOptionIndex = index;
                                      });
                                    },
                                  ),
                                );
                              }),
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Benefit or Concern toggle
                          Row(
                            children: [
                              FilterChip(
                                label: const Text("Benefit (+)"),
                                selected: _isAddingPro,
                                selectedColor: Colors.green.withOpacity(0.2),
                                backgroundColor: cardBgColor,
                                onSelected: (_) {
                                  setState(() {
                                    _isAddingPro = true;
                                  });
                                },
                              ),
                              const SizedBox(width: 8),
                              FilterChip(
                                label: const Text("Concern (-)"),
                                selected: !_isAddingPro,
                                selectedColor: Colors.red.withOpacity(0.2),
                                backgroundColor: cardBgColor,
                                onSelected: (_) {
                                  setState(() {
                                    _isAddingPro = false;
                                  });
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),

                          FactorInputRow(
                            controller: _factorController,
                            isHighIntensity: _isHighIntensity,
                            isPro: _isAddingPro,
                            onIntensityToggle: () {
                              setState(() {
                                _isHighIntensity = !_isHighIntensity;
                              });
                            },
                            onSubmitted: _addFactor,
                          ),
                          const SizedBox(height: 16),

                          if (_options.isNotEmpty) ...[
                            Text(
                              "Reflection points for '${_options[_selectedOptionIndex].title}':",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                                color: textColor,
                              ),
                            ),
                            const SizedBox(height: 8),

                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: _options[_selectedOptionIndex]
                                  .factors
                                  .length,
                              itemBuilder: (context, index) {
                                final factor = _options[_selectedOptionIndex]
                                    .factors[index];

                                return ListTile(
                                  dense: true,
                                  leading: Icon(
                                    factor.isPro
                                        ? (factor.isHighIntensity
                                            ? Icons.local_fire_department
                                            : Icons.add_circle_outline)
                                        : (factor.isHighIntensity
                                            ? Icons.gpp_bad
                                            : Icons.remove_circle_outline),
                                    color: factor.isPro
                                        ? Colors.green
                                        : Colors.red,
                                  ),
                                  title: Text(
                                    factor.text,
                                    style: TextStyle(color: textColor),
                                  ),
                                );
                              },
                            ),
                          ],
                        ],

                        // Stage 3: Summary & Preference Selection
                        if (_currentStep == 3) ...[
                          Text(
                            "Review & Choose a Direction",
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: textColor,
                                ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Which path feels most aligned with your current needs?",
                            style: TextStyle(color: subTextColor),
                          ),
                          if (hasTradeOff) ...[
                            const SizedBox(height: 12),
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: theme.accentHighlightColor,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.info_outline, color: accentColor),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      "Notice: You marked important benefits and concerns. It's normal to feel conflicted.",
                                      style: TextStyle(
                                        color: textColor,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                          const SizedBox(height: 16),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: _options.length,
                            itemBuilder: (context, index) {
                              final option = _options[index];
                              final isSelected =
                                  _finalChosenOptionId == option.id;

                              return Card(
                                color: isSelected
                                    ? theme.accentHighlightColor
                                    : cardBgColor,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  side: BorderSide(
                                    color: isSelected
                                        ? accentColor
                                        : cardBorderColor,
                                    width: isSelected ? 2 : 1,
                                  ),
                                ),
                                child: RadioListTile<String>(
                                  title: Text(
                                    option.title,
                                    style: TextStyle(
                                      color: textColor,
                                      fontWeight: isSelected
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                    ),
                                  ),
                                  subtitle: Text(
                                    "${option.factors.where((f) => f.isPro).length} pros, ${option.factors.where((f) => !f.isPro).length} cons",
                                    style: TextStyle(color: subTextColor),
                                  ),
                                  value: option.id,
                                  groupValue: _finalChosenOptionId,
                                  activeColor: accentColor,
                                  onChanged: (val) {
                                    setState(() {
                                      _finalChosenOptionId = val;
                                    });
                                  },
                                ),
                              );
                            },
                          ),
                        ],
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: accentColor,
                      foregroundColor: theme.buttonTextColor,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: _currentStep < 3 ? _nextStep : _completeDecision,
                    child: Text(
                      _currentStep == 1
                          ? "Next: Explore Options"
                          : _currentStep == 2
                              ? "Next: Review & Select"
                              : "I've Made My Decision",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
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