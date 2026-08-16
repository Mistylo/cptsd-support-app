import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'skill_models.dart';
import 'package:cptsd_app/config/claude_service_provider.dart';
import 'package:cptsd_app/pages/tools/theme_provider.dart'; 

// Provides a guided AI assisted reflection space where users can apply the
// concepts learned in an interpersonal skills module to their own situations.

class AiSupportWorkspaceView extends ConsumerStatefulWidget {
  final SkillModuleType moduleType;

  const AiSupportWorkspaceView({
    super.key,
    required this.moduleType,
  });

  @override
  ConsumerState<AiSupportWorkspaceView> createState() => _AiSupportWorkspaceViewState();
}

class _AiSupportWorkspaceViewState extends ConsumerState<AiSupportWorkspaceView> {
  late final TextEditingController _scenarioController;
  // Limit user input to encourage concise scenarios
  final int _maxCharacters = 800;
  int _currentCharacterCount = 0;

  @override
  void initState() {
    super.initState();
    _scenarioController = TextEditingController();
    _scenarioController.addListener(_updateCharCount);
  }

  // Updates the live character counter as the user types
  void _updateCharCount() {
    setState(() {
      _currentCharacterCount = _scenarioController.text.length;
    });
  }

  @override
  void dispose() {
    _scenarioController.removeListener(_updateCharCount);
    _scenarioController.dispose();
    super.dispose();
  }

  // Returns a module specific system prompt to constrain AI responses within the selected learning topic
  String _getSystemInstruction() {
    // Each learning module uses a dedicated prompt so the AI provides context specific reflective guidance
    switch (widget.moduleType) {
      case SkillModuleType.boundaries:
        return """
          You are a trauma-informed self-help assistant designed to support users who have completed a learning module about healthy boundaries.

          Your purpose is to help users apply the concepts they have learned to their own real-life situations. Your role is to encourage reflection, emotional awareness, and healthier communication. You are not a therapist, and you should never make decisions for the user.

          Before generating a response, first determine whether the user's input is relevant to this module.

          Relevant inputs include situations involving:
          - setting or maintaining personal boundaries
          - saying no
          - people-pleasing
          - feeling guilty for refusing requests
          - respecting personal needs
          - difficulty expressing limits
          - similar interpersonal situations

          If the user's message is unrelated to these topics, is random text, asks an unrelated factual question, or does not describe a personal situation, do not answer the unrelated request.

          Instead, politely respond with:
          "It looks like your message isn't related to this learning activity. Try describing a real-life situation involving boundaries, saying no, or respecting your own needs, and I'll help you reflect on it using the ideas from this module."

          If the input is relevant, structure your response as follows:
          1. Briefly acknowledge the user's feelings with empathy.
          2. Explain how healthy boundaries may relate to the situation.
          3. Identify any people-pleasing or boundary challenges if appropriate.
          4. Suggest one or two healthy approaches the user could consider.
          5. Provide an example of respectful wording if helpful.
          6. End with two reflective questions that encourage the user to think for themselves.

          Do not:
          - judge the user
          - diagnose mental health conditions
          - tell the user exactly what they must do
          - encourage confrontation or revenge
          - make absolute statements

          If the user describes immediate danger, abuse, self-harm, suicidal thoughts, or risk of violence, stop the normal reflection and instead encourage them to seek immediate support from trusted people or emergency services appropriate to their location.

          Maintain a calm, validating, supportive, and empowering tone throughout.
          """;

      case SkillModuleType.unhealthyRelationships:
        return """
          You are a trauma-informed self-help assistant supporting users who have completed a learning module about recognising unhealthy relationship patterns.

          Your goal is to help users reflect on behaviours they experience in relationships without making definitive judgments about people.

          Before responding, determine whether the user's input is relevant.

          Relevant topics include:
          - unhealthy relationships
          - manipulation
          - gaslighting
          - guilt-tripping
          - excessive criticism
          - controlling behaviour
          - disrespect
          - emotional safety
          - trust
          - relationship concerns

          If the user's message is unrelated to these topics or is not describing a personal relationship situation, politely reply:
          "It looks like your message isn't related to this learning activity. Try describing a relationship situation or behaviour you'd like to better understand, and I'll help you reflect on it using the ideas from this module."

          If the input is relevant:
          1. Acknowledge the user's experience.
          2. Identify behaviours that may be concerning.
          3. Explain why these behaviours may affect emotional wellbeing.
          4. Encourage looking for patterns rather than judging isolated events.
          5. Suggest healthy next steps such as reflection, communication, or seeking trusted support.
          6. Finish with two reflective questions.

          Do not diagnose abuse based on a single event.
          Do not tell users to end relationships.
          Do not make decisions for them.

          If the user describes immediate danger or abuse that places them at risk, prioritise encouraging them to seek appropriate professional or emergency support.

          Use a warm, balanced, trauma-informed tone.
          """;

      case SkillModuleType.assertiveCommunication:
        return """
          You are a trauma-informed self-help assistant supporting users who have completed a learning module about assertive communication.

          Your purpose is to help users practise expressing their needs respectfully and confidently.

          Before responding, determine whether the user's input is relevant.

          Relevant topics include:
          - communication difficulties
          - expressing needs
          - disagreements
          - conflict
          - asking for help
          - saying no
          - difficult conversations
          - fear of speaking up
          - passive, aggressive, or assertive communication

          If the user's input is unrelated or does not describe a communication situation, politely respond:
          "It looks like your message isn't related to this learning activity. Try describing a conversation or communication situation you'd like help reflecting on, and I'll apply the ideas from this module."

          If the input is relevant:
          1. Validate the user's feelings.
          2. Explain how assertive communication may help.
          3. Describe the difference between passive, aggressive, and assertive responses if appropriate.
          4. Provide one example of respectful assertive wording.
          5. End with two reflective questions.

          Avoid:
          - making decisions for the user
          - encouraging confrontation
          - judgemental language
          - therapy-style diagnosis

          If the user describes immediate danger, abuse, self-harm, suicidal thoughts, or risk of violence, encourage them to seek immediate support instead of focusing on communication strategies.

          Maintain a calm, encouraging, and empowering tone.
          """;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = ref.watch(appThemeProvider);
    final aiState = ref.watch(globalAIGeneratorProvider);
    final aiNotifier = ref.read(globalAIGeneratorProvider.notifier);

    final bool isDarkBackground = ThemeData.estimateBrightnessForColor(theme.bottomColor) == Brightness.dark;
    final Color textColor = isDarkBackground ? Colors.white.withOpacity(0.9) : Colors.black87;
    final Color subTextColor = isDarkBackground ? Colors.white60 : Colors.grey.shade600;
    final Color cardBackgroundColor = isDarkBackground ? const Color(0xFF1E1E1E) : Colors.white;

    return Scaffold(
      backgroundColor: isDarkBackground ? theme.bottomColor : Colors.grey.shade50,
      appBar: AppBar(
        title: Text(
          'Apply This to My Situation',
          style: TextStyle(color: theme.accentColor, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: false,
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: theme.accentColor),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                "Describe a real situation you're facing.",
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
              ),
              const SizedBox(height: 6),
              Text(
                "The AI will respond using the principles from this module. Its purpose is to help you reflect, not to tell you exactly what to do.",
                style: TextStyle(
                  color: subTextColor,
                  fontSize: 13,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 20),

              TextField(
                controller: _scenarioController,
                maxLength: _maxCharacters,
                maxLines: 6,
                minLines: 4,
                textInputAction: TextInputAction.newline,
                style: TextStyle(color: textColor),
                decoration: InputDecoration(
                  hintText: "For example:\n• My manager often messages me after work and I feel guilty if I don't reply.\n• My friend gets upset every time I say no.",
                  hintStyle: TextStyle(
                    color: isDarkBackground ? Colors.white30 : Colors.grey.shade400, 
                    height: 1.5, 
                    fontSize: 14,
                  ),
                  fillColor: cardBackgroundColor,
                  filled: true,
                  counterText: "",
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: isDarkBackground ? Colors.white10 : Colors.grey.shade200),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: theme.accentColor, width: 1.5),
                  ),
                ),
              ),
              const SizedBox(height: 8),

              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  '$_currentCharacterCount / $_maxCharacters',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: _currentCharacterCount >= _maxCharacters 
                            ? Colors.red 
                            : subTextColor,
                      ),
                ),
              ),
              const SizedBox(height: 20),

              aiState.isLoading
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(theme.accentColor)),
                      ),
                    )
                  : ElevatedButton(
                      onPressed: _currentCharacterCount == 0
                          ? null
                          : () {
                              aiNotifier.generate(
                                prompt: _scenarioController.text,
                                systemInstruction: _getSystemInstruction(),
                              );
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.accentColor,
                        foregroundColor: ThemeData.estimateBrightnessForColor(theme.accentColor) == Brightness.dark 
                            ? Colors.white 
                            : Colors.black87,
                        disabledBackgroundColor: isDarkBackground ? Colors.white10 : Colors.grey.shade200,
                        disabledForegroundColor: subTextColor.withOpacity(0.4),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 0,
                      ),
                      child: const Text('Generate Reflection', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
              const SizedBox(height: 16),

              Text(
                'AI responses are intended for reflection and self-help only. They do not replace professional mental health or legal advice.',
                style: TextStyle(
                  color: isDarkBackground ? Colors.white30 : Colors.grey.shade500,
                  fontSize: 11,
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
              // Display either the generated reflection or an error message after the request completes
              if (aiState.result != null || aiState.errorMessage != null) ...[
                const SizedBox(height: 28),
                Divider(color: isDarkBackground ? Colors.white10 : Colors.grey.shade200),
                const SizedBox(height: 20),
                Text(
                  'Structured Feedback',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: aiState.errorMessage != null 
                        ? (isDarkBackground ? const Color(0x20D32F2F) : Colors.red.shade50) 
                        : cardBackgroundColor,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: aiState.errorMessage != null 
                          ? Colors.red.shade400 
                          : (isDarkBackground ? Colors.white10 : Colors.grey.shade200),
                    ),
                  ),
                  child: Text(
                    aiState.errorMessage ?? aiState.result!,
                    style: TextStyle(
                      color: aiState.errorMessage != null 
                          ? (isDarkBackground ? Colors.red.shade300 : Colors.red.shade900) 
                          : textColor,
                      height: 1.5,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}