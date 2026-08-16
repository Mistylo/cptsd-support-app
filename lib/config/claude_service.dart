import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';


// Custom exception used for errors returned by the Claude service.
class ClaudeServiceException implements Exception {
  final String message;
  final int? statusCode;

  ClaudeServiceException(
    this.message, {
    this.statusCode,
  });

  @override
  String toString() {
    if (statusCode != null) {
      return 'ClaudeServiceException: $message (Status: $statusCode)';
    }
    return 'ClaudeServiceException: $message';
  }
}

class ClaudeService {
  static const String _baseUrl =
      'https://api.anthropic.com';

  // Default model used for the AI-assisted features.
  static const String defaultModel =
      'claude-sonnet-4-6';

  final String _apiKey;
  late final Dio _dio;

  ClaudeService({
    String? apiKey,
  }) :
      _apiKey =
          apiKey ??
          dotenv.env['CLAUDE_API_KEY'] ??
          '' {
    // Set up Dio with the API settings and required headers.
    _dio = Dio(
      BaseOptions(
        baseUrl: _baseUrl,
        connectTimeout:
            const Duration(seconds: 20),
        receiveTimeout:
            const Duration(seconds: 30),
        headers: {
          'content-type':
              'application/json',
          'accept':
              'application/json',
          'x-api-key':
              _apiKey.trim(),
          'anthropic-version':
              '2023-06-01',
        },
        validateStatus: (status) {
          // Handle API errors in this service instead of Dio.
          return true;
        },
      ),
    );
  }

  // Sends a prompt to Claude and returns the generated text.
  Future<String> generateText({
    required String prompt,
    String? systemInstruction,
    String model = defaultModel,
    int maxTokens = 1024,
    double temperature = 0.7,
  }) async {
    if (_apiKey.trim().isEmpty) {
      throw ClaudeServiceException(
        'API Key is empty.',
      );
    }

    final body = {
      'model':
          model,
      'max_tokens':
          maxTokens,
      'temperature':
          temperature,
      'messages': [
        {
          'role':
              'user',
          'content':
              prompt,
        }
      ],
    };

    // Add the system instruction only when one is provided.
    if (
      systemInstruction != null &&
      systemInstruction.trim().isNotEmpty
    ) {
      body['system'] =
          systemInstruction.trim();
    }

    try {
      final response =
          await _dio.post(
            '/v1/messages',
            data: body,
          );

      // Check for a successful response and extract the generated text.
      if (
        response.statusCode == 200 &&
        response.data != null
      ) {
        final data =
            response.data;

        if (
          data is Map &&
          data['content'] is List
        ) {
          final content =
              data['content'] as List;

          if (
            content.isNotEmpty &&
            content.first['text'] != null
          ) {
            return content.first['text']
                .toString()
                .trim();
          }
        }
      }

      // Extract the error message returned by the Anthropic API.
      if (
        response.data is Map &&
        response.data['error'] != null
      ) {
        final error =
            response.data['error'];

        if (
          error is Map &&
          error['message'] != null
        ) {
          throw ClaudeServiceException(
            error['message'].toString(),
            statusCode:
                response.statusCode,
          );
        }
      }

      // Handle responses that do not match the expected format.
      throw ClaudeServiceException(
        'Unexpected API response.',
        statusCode:
            response.statusCode,
      );
    }
    catch(e) {
      // Keep the original service exception instead of wrapping it again.
      if (e is ClaudeServiceException) {
        rethrow;
      }

      throw ClaudeServiceException(
        e.toString(),
      );
    }
  }
}