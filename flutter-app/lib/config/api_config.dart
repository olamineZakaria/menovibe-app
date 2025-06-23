/// API Configuration
///
/// Replace the placeholder values with your actual API keys:
/// 1. Get a free OpenWeatherMap API key from: https://openweathermap.org/api
/// 2. Get an OpenAI API key from: https://platform.openai.com/api-keys
///
/// Note: Keep your API keys secure and never commit them to version control.
/// For production apps, consider using environment variables or secure storage.

class ApiConfig {
  // OpenWeatherMap API Configuration
  static const String openWeatherApiKey = '3e178fe988b24800fa476a78092e84fa';

  // OpenAI API Configuration (for personalized advice)
  static const String openAiApiKey =
      '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';

  // Gemini API Configuration (for weather advice)
  static const String geminiApiKey = 'AIzaSyD8BBMCJggJn2KAIycrSrqpJTnELxtpVQQ';
  static const String geminiApiEndpoint =
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent';

  // Alternative: You can use other AI services by changing the endpoint
  static const String aiAdviceEndpoint =
      'https://api.openai.com/v1/chat/completions';

  // Weather API endpoints
  static const String openWeatherBaseUrl =
      'https://api.openweathermap.org/data/2.5';

  /// Check if API keys are configured
  static bool get isConfigured {
    return true; // Both API keys are now configured
  }

  /// Get a warning message if API keys are not configured
  static String get configurationWarning {
    return ''; // No warning needed - both APIs are configured
  }
}
