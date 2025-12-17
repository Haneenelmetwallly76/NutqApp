# Speech-to-Text Implementation Guide

## Overview
This document explains the Speech-to-Text functionality implemented in the NutqApp Flutter project, specifically for the Speech Therapy Screen with Arabic language support.

---

## 1. Dependencies Added

### pubspec.yaml
```yaml
speech_to_text: ^6.6.2
```

**Why?** The `speech_to_text` package provides native bindings to the device's speech recognition APIs (Google Speech Recognition on Android, SpeechFramework on iOS).

---

## 2. Platform Permissions

### Android (AndroidManifest.xml)
```xml
<uses-permission android:name="android.permission.RECORD_AUDIO" />
<uses-permission android:name="android.permission.BLUETOOTH" />
```

**Why?**
- `RECORD_AUDIO`: Required to access the microphone for speech recognition
- `BLUETOOTH`: Optional but recommended for Bluetooth headset compatibility

### iOS (Info.plist)
```xml
<key>NSSpeechRecognitionUsageDescription</key>
<string>This app uses speech recognition to help with speech therapy exercises and learning activities.</string>

<key>NSMicrophoneUsageDescription</key>
<string>Microphone access is required for speech therapy exercises and recording your voice for analysis.</string>
```

**Why?**
- iOS requires explicit privacy descriptions in Info.plist for microphone and speech recognition
- Users will see these messages when first granting permissions
- **Important**: App will crash if these keys are missing!

---

## 3. Implementation Details

### Class Variables
```dart
late stt.SpeechToText _speechToText;
bool _isListening = false;
String _recognizedWords = '';
```

### Initialization (`_initializeSpeechToText()`)
```dart
Future<void> _initializeSpeechToText() async {
  _speechToText = stt.SpeechToText();
  bool available = await _speechToText.initialize(
    onError: (error) {
      print('Error: $error');
      _showErrorSnackBar('Speech recognition error: ${error.errorMsg}');
    },
    onStatus: (status) {
      print('Status: $status');
    },
  );
}
```

**Key Points:**
- Called in `initState()` to set up speech recognition on app startup
- Handles errors and status updates with callbacks
- Shows user-friendly error messages via SnackBar

### Toggle Listening (`_toggleListening()`)
```dart
Future<void> _toggleListening() async {
  if (_isListening) {
    await _speechToText.stop();
    setState(() {
      _isListening = false;
    });
  } else {
    bool available = await _speechToText.listen(
      onResult: (result) {
        setState(() {
          _recognizedWords = result.recognizedWords;
        });
      },
      localeId: 'ar_EG',  // Egyptian Arabic
      listenFor: const Duration(seconds: 30),
      pauseFor: const Duration(seconds: 3),
      partialResults: true,
    );
  }
}
```

**Critical Settings:**
- **`localeId: 'ar_EG'`** - Egyptian Arabic (primary language for your app)
  - Alternative: `'ar_SA'` for Saudi Arabic
  - Other Arabic variants: `'ar'`, `'ar_AE'`, `'ar_BH'`, etc.
- **`listenFor: 30 seconds`** - Maximum listening duration
- **`pauseFor: 3 seconds`** - Auto-stop if no speech detected for 3 seconds
- **`partialResults: true`** - Shows intermediate results as user speaks

### UI Updates
```dart
// Floating Action Button
FloatingActionButton.extended(
  onPressed: _toggleListening,
  backgroundColor: _isListening ? Colors.redAccent : Colors.pinkAccent,
  icon: Icon(_isListening ? Icons.mic : Icons.mic_none),
  label: Text(_isListening ? "Listening..." : "Quick Practice"),
)

// Recognized Text Display
Container(
  decoration: BoxDecoration(
    color: _isListening
        ? Colors.blue.withValues(alpha: 0.1)
        : Colors.green.withValues(alpha: 0.1),
    borderRadius: BorderRadius.circular(12),
    border: Border.all(
      color: _isListening ? Colors.blue : Colors.green,
      width: 2,
    ),
  ),
  child: Column(
    children: [
      Row(
        children: [
          Icon(
            _isListening ? Icons.record_voice_over : Icons.check_circle,
          ),
          Text(_isListening ? 'Listening...' : 'Recognized Text'),
        ],
      ),
      Text(_recognizedWords.isEmpty ? 'Waiting for input...' : _recognizedWords),
    ],
  ),
)
```

**Features:**
- Real-time visual feedback (blue = listening, green = completed)
- Dynamic button label changes
- Displays partial and final results as user speaks
- Beautiful container styling with borders and background

### Cleanup (`dispose()`)
```dart
@override
void dispose() {
  record.dispose();
  if (_isListening) {
    _speechToText.stop();
  }
  super.dispose();
}
```

---

## 4. Supported Arabic Locales

| Locale ID | Language | Region |
|-----------|----------|--------|
| `ar_EG` | Arabic | Egypt (Recommended) |
| `ar_SA` | Arabic | Saudi Arabia |
| `ar_AE` | Arabic | United Arab Emirates |
| `ar` | Arabic | Generic |
| `ar_BH` | Arabic | Bahrain |
| `ar_DZ` | Arabic | Algeria |
| `ar_IQ` | Arabic | Iraq |
| `ar_JO` | Arabic | Jordan |
| `ar_KW` | Arabic | Kuwait |
| `ar_LB` | Arabic | Lebanon |

To change the locale, modify the `localeId` parameter in `_toggleListening()`:
```dart
localeId: 'ar_SA', // Change this to your preferred locale
```

---

## 5. How to Use

### For End Users
1. Open the Speech Therapy Screen
2. Tap the **"Quick Practice"** button (FAB with microphone icon)
3. Start speaking in Arabic
4. Watch the recognized text appear in real-time in the container above
5. Tap the button again (now labeled **"Listening..."**) to stop

### For Developers - Extending Functionality

#### Add a Function to Process Recognized Text
```dart
void _processRecognizedText() {
  // Send to API for analysis
  // Save to database
  // Compare with expected answer
  // Calculate score
}
```

#### Add Language Selection
```dart
Future<void> _switchLanguage(String locale) async {
  await _speechToText.stop();
  setState(() {
    _isListening = false;
    _recognizedWords = '';
  });
}
```

#### Add Sound Level Feedback
```dart
onSoundLevelChange: (level) {
  setState(() {
    soundLevel = level; // Use for animated visual feedback
  });
}
```

---

## 6. Testing

### Android Testing
1. Use Android emulator or physical device with microphone
2. Ensure **Google Play Services** is installed
3. Grant microphone permission when prompted
4. Test with: Settings > Apps > NutqApp > Permissions > Microphone

### iOS Testing
1. Use **physical device** (simulator may have limited speech recognition)
2. Grant microphone permission when prompted
3. Test with: Settings > NutqApp > Microphone

---

## 7. Troubleshooting

### Speech Recognition Not Working
- [ ] Check microphone permissions granted
- [ ] Verify `localeId` is supported on device
- [ ] Ensure internet connection (required for speech API)
- [ ] Restart app and device
- [ ] Check logcat/console for error messages

### Arabic Recognition Not Working
- [ ] Confirm `localeId` is set to `'ar_EG'` or `'ar_SA'`
- [ ] Device language settings should include Arabic
- [ ] Try generic `'ar'` locale instead

### iOS Issues
- [ ] Verify Info.plist has `NSSpeechRecognitionUsageDescription`
- [ ] Verify Info.plist has `NSMicrophoneUsageDescription`
- [ ] Run `pod install` after adding dependency
- [ ] Build clean: `flutter clean` then `flutter run`

### Android Issues
- [ ] Verify AndroidManifest.xml has `RECORD_AUDIO` permission
- [ ] Check `android/app/build.gradle` compatibility
- [ ] Clear app cache: Settings > Apps > NutqApp > Storage > Clear Cache

---

## 8. Advanced Configuration

### Increasing Listening Duration
```dart
listenFor: const Duration(seconds: 60), // 60 seconds
```

### Disabling Partial Results
```dart
partialResults: false, // Only final results
```

### Custom Error Handling
```dart
onError: (error) {
  if (error.permanent) {
    // Permanent error - disable feature
  } else {
    // Temporary error - allow retry
  }
}
```

---

## 9. Related Files Modified

1. **pubspec.yaml** - Added `speech_to_text` dependency
2. **android/app/src/main/AndroidManifest.xml** - Added microphone permissions
3. **ios/Runner/Info.plist** - Added privacy descriptions
4. **lib/screens/speech_therapy_screen.dart** - Implemented speech recognition logic

---

## 10. References

- [speech_to_text Package](https://pub.dev/packages/speech_to_text)
- [Flutter Internationalization](https://flutter.dev/docs/development/accessibility-and-localization/internationalization)
- [Android Microphone Permissions](https://developer.android.com/guide/topics/permissions/overview)
- [iOS Speech Recognition](https://developer.apple.com/documentation/speech)

---

**Last Updated**: December 17, 2025
**Implementation Status**: ✅ Complete and Ready for Production
