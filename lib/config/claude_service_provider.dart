import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'claude_service.dart';

// Provides one shared ClaudeService that can be used by the app.
final claudeServiceProvider =
    Provider<ClaudeService>((ref) {
  final String apiKey =
      dotenv.env['CLAUDE_API_KEY'] ?? '';

  // Show a warning during development if the API key is not available.
  if (apiKey.isEmpty) {
    assert(() {
      print(
        'WARNING: CLAUDE_API_KEY is missing.',
      );
      return true;
    }());
  }

  final service = ClaudeService(
    apiKey: apiKey,
  );
  return service;
});

// Keeps track of the current AI generation state.
class AIGenerationState {
  final bool isLoading;
  final String? result;
  final String? errorMessage;

  const AIGenerationState({
    this.isLoading = false,
    this.result,
    this.errorMessage,
  });

  // Creates a new state while keeping the values that have not changed.
  AIGenerationState copyWith({
    bool? isLoading,
    String? result,
    String? errorMessage,
  }) {
    return AIGenerationState(
      isLoading:
          isLoading ?? this.isLoading,
      result:
          result ?? this.result,
      errorMessage:
          errorMessage ?? this.errorMessage,
    );
  }
}

class AIGeneratorNotifier
    extends StateNotifier<AIGenerationState> {
  final ClaudeService _claudeService;

  AIGeneratorNotifier(
      this._claudeService,
  )
      : super(
          const AIGenerationState(),
        );

  // Sends a prompt to Claude and updates the state with the result.
  Future<void> generate({
    required String prompt,
    String? systemInstruction,
    double temperature = 0.7,
    int maxTokens = 1024,
  }) async {
    state = state.copyWith(
      isLoading: true,
      errorMessage: null,
      result: null,
    );

    try {
      print(
        'Calling ClaudeService...',
      );

      final responseText =
          await _claudeService.generateText(
        prompt: prompt,
        systemInstruction:
            systemInstruction,
        temperature:
            temperature,
        maxTokens:
            maxTokens,
      );

      state = state.copyWith(
        isLoading: false,
        result: responseText,
      );
    }
    catch (e) {
      // Store the error so that the UI can show it to the user.
      state = state.copyWith(
        isLoading: false,
        errorMessage:
            e.toString()
             .replaceFirst(
                'ClaudeServiceException: ',
                ''
              ),
      );
    }
  }

  // Clears the current AI result and error state.
  void clear() {
    state =
        const AIGenerationState();
  }
}

// Provides the AI generator to the parts of the app that need it.
final globalAIGeneratorProvider =
    StateNotifierProvider<
        AIGeneratorNotifier,
        AIGenerationState>((ref) {
  final service =
      ref.watch(
        claudeServiceProvider,
      );

  return AIGeneratorNotifier(
    service,
  );
});