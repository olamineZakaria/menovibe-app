# Weather & AI Advice Feature Setup Guide

This guide will help you set up the weather-based personalized advice feature for your wellness app.

## Features

- **Location Detection**: Automatically detects user's location (with permission)
- **Weather Data**: Fetches current weather from OpenWeatherMap API
- **AI-Powered Advice**: Generates personalized wellness tips based on weather conditions
- **Fallback System**: Provides local advice when AI service is unavailable
- **Beautiful UI**: Modern, animated weather widget with gradient design

## Setup Instructions

### 1. Get API Keys

#### OpenWeatherMap API (Free)
1. Go to [OpenWeatherMap](https://openweathermap.org/api)
2. Sign up for a free account
3. Navigate to "API keys" section
4. Copy your API key

#### OpenAI API (Optional - for AI advice)
1. Go to [OpenAI Platform](https://platform.openai.com/api-keys)
2. Sign up or log in
3. Create a new API key
4. Copy your API key

### 2. Configure API Keys

1. Open `lib/config/api_config.dart`
2. Replace the placeholder values:

```dart
class ApiConfig {
  // Replace with your actual OpenWeatherMap API key
  static const String openWeatherApiKey = 'YOUR_ACTUAL_OPENWEATHER_API_KEY';
  
  // Replace with your actual OpenAI API key
  static const String openAiApiKey = 'YOUR_ACTUAL_OPENAI_API_KEY';
}
```

### 3. Install Dependencies

The required dependencies are already included in `pubspec.yaml`:

```yaml
dependencies:
  http: ^1.1.0
  geolocator: ^10.1.0
  weather: ^3.1.1
```

Run the following command to install dependencies:

```bash
flutter pub get
```

### 4. Platform Permissions

#### Android
Add the following permissions to `android/app/src/main/AndroidManifest.xml`:

```xml
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
```

#### iOS
Add the following to `ios/Runner/Info.plist`:

```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>This app needs access to location to provide weather-based wellness advice.</string>
<key>NSLocationAlwaysAndWhenInUseUsageDescription</key>
<string>This app needs access to location to provide weather-based wellness advice.</string>
```

## How It Works

### 1. Location Detection
- App requests location permission from user
- Uses device GPS to get current coordinates
- Handles permission denial gracefully

### 2. Weather API Call
- Sends coordinates to OpenWeatherMap API
- Receives current weather data (temperature, humidity, wind, etc.)
- Formats data for display

### 3. AI Advice Generation
- Sends weather data to OpenAI API
- AI generates personalized wellness advice
- Falls back to local advice if AI service fails

### 4. Display
- Shows weather information in a beautiful card
- Displays personalized advice prominently
- Includes loading and error states

## Customization

### Weather Widget Styling
The weather widget uses the `AppColors.weatherGradient` for styling. You can customize this in `lib/constants/app_colors.dart`:

```dart
static const LinearGradient weatherGradient = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [
    Color(0xFF74B9FF), // Sky blue
    Color(0xFF0984E3), // Deeper blue
  ],
);
```

### AI Prompt Customization
Modify the AI prompt in `lib/services/weather_service.dart` to change the type of advice generated:

```dart
String _createAdvicePrompt(WeatherData weatherData) {
  return '''
  Current weather conditions:
  - Temperature: ${weatherData.temperature}°C
  - Weather: ${weatherData.description}
  - Humidity: ${weatherData.humidity}%
  - Wind Speed: ${weatherData.windSpeed} m/s
  
  // Customize this prompt for your specific needs
  Please provide a short, personalized wellness tip...
  ''';
}
```

### Local Advice Fallback
Customize the local advice logic in the `_getLocalAdvice` method:

```dart
String _getLocalAdvice(WeatherData weatherData) {
  final temp = weatherData.temperature;
  
  if (temp > 25) {
    return "Your custom hot weather advice here";
  } else if (temp > 15) {
    return "Your custom mild weather advice here";
  }
  // Add more conditions as needed
}
```

## Troubleshooting

### Common Issues

1. **Location Permission Denied**
   - App will show an error state
   - User can retry by tapping the refresh button
   - Check that permissions are properly configured

2. **Weather API Errors**
   - Verify your OpenWeatherMap API key is correct
   - Check your internet connection
   - Ensure the API key has the correct permissions

3. **AI Service Errors**
   - Verify your OpenAI API key is correct
   - Check your API usage limits
   - App will fall back to local advice automatically

4. **Build Errors**
   - Run `flutter clean` and `flutter pub get`
   - Ensure all dependencies are properly installed
   - Check that platform permissions are configured

### Testing

1. **Test Location Permission**
   - Deny permission and verify error handling
   - Grant permission and verify weather loading

2. **Test API Keys**
   - Use invalid keys to test error states
   - Verify fallback behavior works

3. **Test Network Conditions**
   - Test with poor internet connection
   - Verify loading states display correctly

## Security Notes

- Never commit API keys to version control
- Use environment variables in production
- Consider implementing API key rotation
- Monitor API usage to avoid unexpected charges

## Support

If you encounter issues:

1. Check the troubleshooting section above
2. Verify all setup steps are completed
3. Test with a simple API call first
4. Check the console for error messages

## API Costs

- **OpenWeatherMap**: Free tier includes 1,000 calls/day
- **OpenAI**: Pay-per-use, typically $0.002 per 1K tokens
- Monitor usage to avoid unexpected charges 