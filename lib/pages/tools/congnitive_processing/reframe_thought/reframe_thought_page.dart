import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cptsd_app/pages/tools/theme_provider.dart';
import 'package:cptsd_app/config/claude_service_provider.dart';


class ReframeHubPage extends ConsumerWidget {
  const ReframeHubPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(appThemeProvider);
    final bool isDarkBackground = ThemeData.estimateBrightnessForColor(theme.bottomColor) == Brightness.dark;
    final Color textColor = isDarkBackground ? Colors.white.withOpacity(0.9) : Colors.black87;
    final Color subTextColor = isDarkBackground ? Colors.white60 : Colors.black54;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          "Reframing Hub",
          style: TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 16,
            color: theme.accentColor,
          ),
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
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Feature Introduction Card
                Card(
                  elevation: 0,
                  color: theme.accentColor.withOpacity(0.12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.psychology_alt_rounded, color: theme.accentColor, size: 28),
                            const SizedBox(width: 10),
                            Text(
                              "Reframe Thoughts",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: theme.accentColor,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          "Sometimes our inner critic can become much louder than reality, especially during moments of stress or emotional pain. This exercise helps you look at those thoughts from a kinder and more balanced perspective. It isn't about pretending everything is okay, it's about speaking to yourself with the same compassion you might offer someone you care about",
                          style: TextStyle(
                            color: textColor,
                            height: 1.45,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: _buildHubTile(
                        title: "Start Reframing",
                        subtitle: "Challenge harsh internal narratives gently",
                        icon: Icons.edit_note_rounded,
                        iconBg: theme.accentColor.withOpacity(0.15),
                        iconColor: theme.accentColor,
                        textColor: textColor,
                        subTextColor: subTextColor,
                        isDarkBackground: isDarkBackground,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const ReframingInputPage()),
                          );
                        },
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

  Widget _buildHubTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
    required Color textColor,
    required Color subTextColor,
    required bool isDarkBackground,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      shadowColor: Colors.black.withOpacity(0.05),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      color: isDarkBackground ? const Color(0xFF2C2C2C) : Colors.white,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
                child: Icon(icon, color: iconColor, size: 24),
              ),
              const SizedBox(height: 20),
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                subtitle,
                style: TextStyle(
                  color: subTextColor,
                  fontSize: 12,
                  height: 1.25,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ReframingInputPage extends ConsumerStatefulWidget {
  const ReframingInputPage({super.key});

  @override
  ConsumerState<ReframingInputPage> createState() => _ReframingInputPageState();
}

class _ReframingInputPageState extends ConsumerState<ReframingInputPage> {
  final TextEditingController _thoughtController = TextEditingController();

  @override
  void dispose() {
    _thoughtController.dispose();
    super.dispose();
  }

  // Validate the input and navigate to the AI result page if a thought has been entered
  void _submitThought() {
    if (_thoughtController.text.trim().isEmpty) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ReframeResultPage(rawThought: _thoughtController.text.trim()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appTheme = ref.watch(appThemeProvider);
    final bool isDarkBackground = ThemeData.estimateBrightnessForColor(appTheme.bottomColor) == Brightness.dark;
    final Color textColor = isDarkBackground ? Colors.white.withOpacity(0.9) : Colors.black87;
    final Color subTextColor = isDarkBackground ? Colors.white60 : Colors.black54;
    final Color accentColor = appTheme.accentColor ?? const Color(0xFFDFD1F4);

    return Scaffold(
      backgroundColor: appTheme.bottomColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: textColor),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                "Step 1",
                style: TextStyle(color: subTextColor.withOpacity(0.6), fontSize: 14, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                "What is your inner critic saying right now?",
                style: TextStyle(color: textColor, fontSize: 22, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 20),
              
              // Thought Input Box
              Expanded(
                child: TextField(
                  controller: _thoughtController,
                  maxLines: null,
                  expands: true,
                  textAlignVertical: TextAlignVertical.top,
                  style: TextStyle(color: textColor, fontSize: 16),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color.fromARGB(255, 204, 202, 202).withOpacity(isDarkBackground ? 0.05 : 0.4),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(color: accentColor, width: 1.5),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              
              Text(
                "Write exactly what your inner critic is saying. There is no need to soften or edit your words.",
                style: TextStyle(color: subTextColor, fontSize: 13, height: 1.4),
              ),
              const SizedBox(height: 32),
              
              // Enable the submission button only when the user has entered text.
              ValueListenableBuilder<TextEditingValue>(
                valueListenable: _thoughtController,
                builder: (context, value, child) {
                  final bool isNotEmpty = value.text.trim().isNotEmpty;
                  return ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isNotEmpty ? accentColor : Colors.white10,
                      foregroundColor: isNotEmpty ? const Color.fromARGB(255, 220, 219, 219) : Colors.white30,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: isNotEmpty ? _submitThought : null,
                    child: const Text("Reframe Thought", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ReframeResultPage extends ConsumerStatefulWidget {
  final String rawThought;
  const ReframeResultPage({super.key, required this.rawThought});

  @override
  ConsumerState<ReframeResultPage> createState() => _ReframeResultPageState();
}

class _ReframeResultPageState extends ConsumerState<ReframeResultPage> {
  // Automatically request an AI generated reframing response when the page opens
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(globalAIGeneratorProvider.notifier).generate(
            prompt: widget.rawThought,
            systemInstruction: _getSystemPrompt(),
          );
    });
  }
  
  // Defines the system prompt used to guide the language model toward
  // trauma-informed cognitive reframing responses
  String _getSystemPrompt() {
    return """
You are a trauma-informed mental health support assistant.
Your role is to help users gently challenge self-critical thoughts by offering compassionate and balanced alternative perspectives.

Your response should NEVER:
- shame the user
- dismiss their emotions
- make unrealistic positive statements
- promise outcomes
- diagnose mental illness
- encourage dependence on AI

Instead:
1. Acknowledge the emotional pain behind the thought.
2. Identify whether the thought appears overly harsh, absolute, or self-critical.
3. Rewrite it into a compassionate, balanced perspective without denying the user's feelings.
4. Imagine what the user might say to a close friend experiencing the same situation.
5. End with one short, gentle reminder (one sentence only).

Keep the tone warm, calm, supportive, and non-judgmental.
Do not produce long paragraphs.

Output using exactly this structure:
## Your Thought
(repeat the user's thought)

## A Kinder Perspective
...

## If a Friend Said This...
...

## Gentle Reminder
...

Handling Irrelevant Input:
If the user's input does not describe a self-critical thought, negative self-belief, or emotionally difficult internal dialogue, do not attempt to rewrite it.
Instead respond EXACTLY with this:
"It looks like this doesn't describe a self-critical thought yet.
This exercise works best when you write the words your inner critic is saying to you.
For example:
• 'I'm not good enough.'
• 'Everything is my fault.'
• 'I always mess things up.'
Whenever you're ready, try writing the thought exactly as it appears in your mind."
""";
  }

  // Extract individual sections from the structured AI response
  // using predefined markdown headings
  String _extractSection(String text, String startMarker, String? endMarker) {
    if (!text.contains(startMarker)) return "";
    int startIndex = text.indexOf(startMarker) + startMarker.length;
    int endIndex = (endMarker != null && text.contains(endMarker)) ? text.indexOf(endMarker) : text.length;
    return text.substring(startIndex, endIndex).trim();
  }

  @override
  Widget build(BuildContext context) {
    final appTheme = ref.watch(appThemeProvider);
    final bool isDarkBackground = ThemeData.estimateBrightnessForColor(appTheme.bottomColor) == Brightness.dark;
    final Color textColor = isDarkBackground ? Colors.white.withOpacity(0.9) : Colors.black87;
    final Color subTextColor = isDarkBackground ? Colors.white60 : Colors.black54;
    final Color accentColor = appTheme.accentColor ?? const Color(0xFFDFD1F4);

    // Observe the latest AI generation state from the shared Riverpod provider
    final aiState = ref.watch(globalAIGeneratorProvider);
    String kinderPerspective = "";
    String ifFriendSaidThis = "";
    String oneGentleReminder = "";
    bool isIrrelevant = false;
    String fallbackMessage = "";

    // Parse the structured AI response into separate sections for display
    if (aiState.result != null) {
      final String rawOutput = aiState.result!;
      if (rawOutput.contains("doesn't describe a self-critical thought yet")) {
        isIrrelevant = true;
        fallbackMessage = rawOutput.trim();
      } else {
        kinderPerspective = _extractSection(rawOutput, "## A Kinder Perspective", "## If a Friend Said This...");
        ifFriendSaidThis = _extractSection(rawOutput, "## If a Friend Said This...", "## Gentle Reminder");
        oneGentleReminder = _extractSection(rawOutput, "## Gentle Reminder", null);
      }
    }

    return Scaffold(
      backgroundColor: appTheme.bottomColor,
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0, automaticallyImplyLeading: false),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: aiState.isLoading
                      ? SizedBox(
                          height: MediaQuery.of(context).size.height * 0.6,
                          child: Center(child: CircularProgressIndicator(color: accentColor)),
                        )
                      : aiState.errorMessage != null
                          ? Center(
                              child: Text(
                                "An error occurred: ${aiState.errorMessage}",
                                style: TextStyle(color: textColor, fontSize: 16),
                              ),
                            )
                          : isIrrelevant
                              ? Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 24.0),
                                  child: Text(
                                    fallbackMessage,
                                    style: TextStyle(fontSize: 16, color: textColor, height: 1.6),
                                  ),
                                )
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildSectionHeader("A Kinder Perspective", subTextColor),
                                    _buildContentText(kinderPerspective, textColor),
                                    const SizedBox(height: 28),
                                    
                                    _buildSectionHeader("If a Friend Said This...", subTextColor),
                                    _buildContentText(ifFriendSaidThis, textColor),
                                    const SizedBox(height: 28),
                                    
                                    _buildSectionHeader("One Gentle Reminder", subTextColor),
                                    _buildContentText(oneGentleReminder, textColor),
                                    const SizedBox(height: 16),
                                  ],
                                ),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: textColor.withOpacity(0.2)),
                        foregroundColor: textColor,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () {
                        ref.read(globalAIGeneratorProvider.notifier).clear();
                        Navigator.pop(context);
                      },
                      child: Text(isIrrelevant || aiState.errorMessage != null ? "Go Back" : "Try Another"),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: accentColor,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () {
                        ref.read(globalAIGeneratorProvider.notifier).clear();
                        Navigator.of(context).popUntil((route) => route.isFirst);
                      },
                      child: const Text("Close", style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, Color subTextColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(fontSize: 13, color: subTextColor.withOpacity(0.5), fontWeight: FontWeight.bold, letterSpacing: 1.2),
      ),
    );
  }

  Widget _buildContentText(String content, Color textColor) {
    return Text(
      content.isEmpty ? "..." : content,
      style: TextStyle(fontSize: 16, color: textColor, height: 1.5, fontWeight: FontWeight.w300),
    );
  }
}