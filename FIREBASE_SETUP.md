# Firebase Setup Guide for Luna Care App

## Current Issue: Firebase Data Connect API Error

You're encountering an error because the Firebase Data Connect API is not enabled for your project `menovibe-a1b9a`.

## ✅ Android Configuration Status

**COMPLETED:**
- ✅ Project ID: `menovibe-a1b9a`
- ✅ Project Number: `628289211775`
- ✅ Android App ID: `1:628289211775:android:261df8eedbe1ce21e01e4a`
- ✅ Package Name: `com.example.ask`
- ✅ Storage Bucket: `menovibe-a1b9a.firebasestorage.app`
- ✅ Android API Key: `AIzaSyDn3CxTShhSZkMxXfQNcmZVvNSuNxhHgp4`
- ✅ Google Services plugin configured in `android/app/build.gradle`
- ✅ `google-services.json` configured
- ✅ `firebase_options.dart` updated

**STILL NEEDED:**
- ⏳ Enable Data Connect APIs

## 🎉 Android Configuration Complete!

Your Android Firebase configuration is now fully set up and ready to use!

### Next Steps:

#### 1. Enable Required APIs (2 minutes)

**Firebase Data Connect API:**
- Visit: https://console.developers.google.com/apis/api/firebasedataconnect.googleapis.com/overview?project=menovibe-a1b9a
- Click "Enable"

**SQL Admin API:**
- Visit: https://console.developers.google.com/apis/api/sqladmin.googleapis.com/overview?project=menovibe-a1b9a
- Click "Enable"

#### 2. Test Your Configuration

```bash
flutter clean
flutter pub get
flutter run
```

#### 3. Retry Your Original Firebase Data Connect Command

After enabling the APIs, retry your original Firebase Data Connect setup command.

## 🚀 QUICK SETUP - Manual Steps

### Step 1: Get Your Android API Key (5 minutes)

1. **Open Firebase Console:**
   - Go to: https://console.firebase.google.com/project/menovibe-a1b9a

2. **Go to Project Settings:**
   - Click the gear icon (⚙️) next to "Project Overview" in the left sidebar
   - Click "Project settings"

3. **Find Your Android App:**
   - In the "General" tab, scroll down to "Your apps" section
   - Look for Android app with package name `com.example.ask`
   - Click on the Android app

4. **Copy the API Key:**
   - You'll see a section called "API Key" 
   - Copy the key (starts with `AIzaSy...`)

### Step 2: Update Configuration Files

**Replace `YOUR-ANDROID-API-KEY` in `lib/firebase_options.dart`:**
```dart
static const FirebaseOptions android = FirebaseOptions(
  apiKey: 'AIzaSyC...', // ← Paste your API key here
  appId: '1:628289211775:android:261df8eedbe1ce21e01e4a',
  messagingSenderId: '628289211775',
  projectId: 'menovibe-a1b9a',
  storageBucket: 'menovibe-a1b9a.appspot.com',
);
```

**Replace `YOUR_ANDROID_API_KEY` in `android/app/google-services.json`:**
```json
{
  "api_key": [
    {
      "current_key": "AIzaSyC..." // ← Paste your API key here
    }
  ]
}
```

### Step 3: Enable Required APIs

**Firebase Data Connect API:**
- Visit: https://console.developers.google.com/apis/api/firebasedataconnect.googleapis.com/overview?project=menovibe-a1b9a
- Click "Enable"

**SQL Admin API:**
- Visit: https://console.developers.google.com/apis/api/sqladmin.googleapis.com/overview?project=menovibe-a1b9a
- Click "Enable"

### Step 4: Test Your Configuration

```bash
flutter clean
flutter pub get
flutter run
```

## Step-by-Step Resolution

### 1. Enable Required APIs

**Firebase Data Connect API:**
- Visit: https://console.developers.google.com/apis/api/firebasedataconnect.googleapis.com/overview?project=menovibe-a1b9a
- Click "Enable"

**SQL Admin API:**
- Visit: https://console.developers.google.com/apis/api/sqladmin.googleapis.com/overview?project=menovibe-a1b9a
- Click "Enable"

### 2. Get Your Android API Key

1. Go to Firebase Console: https://console.firebase.google.com/project/menovibe-a1b9a
2. Click on the gear icon (⚙️) next to "Project Overview" to open Project Settings
3. Go to the "General" tab
4. Scroll down to "Your apps" section
5. Find your Android app (`com.example.ask`)
6. Click on the Android app
7. In the app details, you'll see:
   - **API Key**: Copy this value
   - **App ID**: `1:628289211775:android:261df8eedbe1ce21e01e4a` (already configured)

### 3. Update Configuration Files

#### Update `android/app/google-services.json`:
Replace `YOUR_ANDROID_API_KEY` with your actual API key:

```json
{
  "api_key": [
    {
      "current_key": "AIzaSyC..." // Your actual Android API key
    }
  ]
}
```

#### Update `lib/firebase_options.dart`:
Replace `YOUR-ANDROID-API-KEY` with your actual API key:

```dart
static const FirebaseOptions android = FirebaseOptions(
  apiKey: 'AIzaSyC...', // Your actual Android API key
  appId: '1:628289211775:android:261df8eedbe1ce21e01e4a',
  messagingSenderId: '628289211775',
  projectId: 'menovibe-a1b9a',
  storageBucket: 'menovibe-a1b9a.appspot.com',
);
```

### 4. Test Android Configuration

After updating the API key, test your configuration:

```bash
flutter clean
flutter pub get
flutter run
```

### 5. Complete Other Platform Configurations

#### For Web:
1. In Firebase Console, go to Project Settings > General
2. Click "Add app" > "Web"
3. Register app with nickname (e.g., "ask-web")
4. Copy the API key and App ID
5. Update `lib/firebase_options.dart` web section

#### For iOS:
1. In Firebase Console, go to Project Settings > General
2. Click "Add app" > "iOS"
3. Register app with bundle ID `com.example.ask`
4. Copy the API key and App ID
5. Update `lib/firebase_options.dart` ios section

#### For macOS:
1. In Firebase Console, go to Project Settings > General
2. Click "Add app" > "macOS"
3. Register app with bundle ID `com.example.ask`
4. Copy the API key and App ID
5. Update `lib/firebase_options.dart` macos section

### 6. Retry Your Original Command

After completing the configuration, retry your original Firebase Data Connect setup command.

## Current Configuration Summary

```dart
// Android Configuration (✅ COMPLETE!)
static const FirebaseOptions android = FirebaseOptions(
  apiKey: 'AIzaSyDn3CxTShhSZkMxXfQNcmZVvNSuNxhHgp4', // ✅ Complete
  appId: '1:628289211775:android:261df8eedbe1ce21e01e4a', // ✅ Complete
  messagingSenderId: '628289211775', // ✅ Complete
  projectId: 'menovibe-a1b9a', // ✅ Complete
  storageBucket: 'menovibe-a1b9a.firebasestorage.app', // ✅ Complete
);
```

## Troubleshooting

- **403 Error**: Make sure you've enabled the APIs and waited for propagation
- **Authentication Issues**: Ensure you're logged into the correct Google account
- **Project Access**: Verify you have the necessary permissions for the project
- **API Key Issues**: Make sure you're using the correct API key for each platform

## Next Steps

Once the APIs are enabled and configuration is complete:
1. Test your Firebase connection
2. Set up your database rules
3. Configure authentication if needed
4. Set up any additional Firebase services you plan to use
