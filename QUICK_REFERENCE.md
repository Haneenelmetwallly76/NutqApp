# Speech-to-Text Quick Reference

## Quick Start Code

### Initialize Speech-to-Text
```dart
import 'package:speech_to_text/speech_to_text.dart' as stt;

late stt.SpeechToText _speechToText;

@override
void initState() {
  super.initState();
  _initializeSpeechToText();
}

Future<void> _initializeSpeechToText() async {
  _speechToText = stt.SpeechToText();
  await _speechToText.initialize(
    onError: (error) => print('Error: $error'),
    onStatus: (status) => print('Status: $status'),
  );
}
```

### Start Listening (Arabic)
```dart
await _speechToText.listen(
  onResult: (result) {
    setState(() {
      recognizedText = result.recognizedWords;
    });
  },
  localeId: 'ar_EG',  // Egyptian Arabic
  listenFor: Duration(seconds: 30),
  pauseFor: Duration(seconds: 3),
  partialResults: true,
);
```

### Stop Listening
```dart
await _speechToText.stop();
```

### Check if Listening
```dart
if (_speechToText.isListening) {
  // User is speaking
}
```

---

## Common Locale IDs

```dart
// Arabic Variants
'ar'      // Generic Arabic
'ar_EG'   // Egyptian Arabic ⭐ Recommended
'ar_SA'   // Saudi Arabic
'ar_AE'   // UAE Arabic
'ar_BH'   // Bahrain
'ar_DZ'   // Algeria
'ar_IQ'   // Iraq
'ar_JO'   // Jordan
'ar_KW'   // Kuwait
'ar_LB'   // Lebanon

// Other Languages
'en_US'   // English - USA
'en_GB'   // English - UK
'fr_FR'   // French
'es_ES'   // Spanish
'de_DE'   // German
'it_IT'   // Italian
'ja_JP'   // Japanese
'zh_CN'   // Chinese - Mandarin
```

---

## Permissions Required

### Android (AndroidManifest.xml)
```xml
<uses-permission android:name="android.permission.RECORD_AUDIO" />
<uses-permission android:name="android.permission.BLUETOOTH" />
```

### iOS (Info.plist)
```xml
<key>NSSpeechRecognitionUsageDescription</key>
<string>Your app needs speech recognition to work.</string>

<key>NSMicrophoneUsageDescription</key>
<string>Your app needs microphone access to record audio.</string>
```

---

## Dependency

Add to `pubspec.yaml`:
```yaml
dependencies:
  speech_to_text: ^6.6.2
```

---

## Full Implementation Example

```dart
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class SpeechScreen extends StatefulWidget {
  @override
  _SpeechScreenState createState() => _SpeechScreenState();
}

class _SpeechScreenState extends State<SpeechScreen> {
  late stt.SpeechToText _speechToText;
  bool _isListening = false;
  String _recognizedWords = '';

  @override
  void initState() {
    super.initState();
    _initSpeech();
  }

  void _initSpeech() async {
    _speechToText = stt.SpeechToText();
    await _speechToText.initialize(
      onError: (error) => print('Error: $error'),
      onStatus: (status) => print('Status: $status'),
    );
  }

  void _startListening() async {
    if (!_isListening) {
      bool available = await _speechToText.listen(
        onResult: (result) {
          setState(() {
            _recognizedWords = result.recognizedWords;
          });
        },
        localeId: 'ar_EG',
      );
      
      if (available) {
        setState(() => _isListening = true);
      }
    }
  }

  void _stopListening() async {
    if (_isListening) {
      await _speechToText.stop();
      setState(() => _isListening = false);
    }
  }

  @override
  void dispose() {
    _speechToText.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Speech-to-Text')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(20),
            child: Text(
              _recognizedWords.isEmpty 
                ? 'Tap microphone to start' 
                : _recognizedWords,
              style: TextStyle(fontSize: 24),
              textAlign: TextAlign.center,
            ),
          ),
          FloatingActionButton(
            onPressed: _isListening ? _stopListening : _startListening,
            child: Icon(_isListening ? Icons.mic : Icons.mic_none),
          ),
        ],
      ),
    );
  }
}
```

---

## Error Handling

```dart
Future<void> _toggleListening() async {
  try {
    if (!_speechToText.isAvailable) {
      _showError('Speech recognition not available');
      return;
    }

    if (_isListening) {
      await _speechToText.stop();
      setState(() => _isListening = false);
    } else {
      bool available = await _speechToText.listen(
        onResult: (result) => setState(() {
          _recognizedWords = result.recognizedWords;
        }),
        localeId: 'ar_EG',
      );

      if (!available) {
        _showError('Could not start listening');
      } else {
        setState(() => _isListening = true);
      }
    }
  } catch (e) {
    _showError('Error: $e');
  }
}

void _showError(String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(message), backgroundColor: Colors.red),
  );
}
```

---

## Advanced Features

### Sound Level Detection
```dart
await _speechToText.listen(
  onResult: (result) => print('Result: ${result.recognizedWords}'),
  onSoundLevelChange: (level) {
    print('Sound level: $level');
    // Use for visual feedback (progress bar, animation, etc.)
  },
  localeId: 'ar_EG',
);
```

### Partial Results Only (No Final Results)
```dart
await _speechToText.listen(
  onResult: (result) => print(result.recognizedWords),
  partialResults: false,  // Only final results
  localeId: 'ar_EG',
);
```

### Custom Timeout
```dart
await _speechToText.listen(
  onResult: (result) => print(result.recognizedWords),
  listenFor: Duration(seconds: 60),  // Listen for up to 60 seconds
  pauseFor: Duration(seconds: 5),    // Stop if silent for 5 seconds
  localeId: 'ar_EG',
);
```

### Check Available Locales
```dart
List<LocaleName> locales = await _speechToText.locales();
for (var locale in locales) {
  print('${locale.name} - ${locale.localeId}');
}
```

---

## Platform-Specific Notes

### Android
- Requires Google Play Services
- Uses Android Speech Recognition API
- Works on API level 21+
- Requires internet connection for best results

### iOS
- Requires iOS 14.5+
- Uses native SFSpeechRecognizer
- Physical device recommended (simulator limitations)
- Requires Speech Framework
- Privacy descriptions mandatory in Info.plist

---

## Common Issues & Solutions

### Problem: "Speech recognition not available"
```dart
// Solution: Check initialization
if (!_speechToText.isAvailable) {
  print('Speech recognition unavailable on this device');
  // Disable feature or show alternative UI
}
```

### Problem: Not recognizing Arabic
```dart
// Solution: Verify locale
// ❌ Wrong
localeId: 'ar',

// ✅ Correct
localeId: 'ar_EG',  // or 'ar_SA', etc.
```

### Problem: Crashes on iOS
```dart
// Solution: Check Info.plist has both keys
/*
<key>NSSpeechRecognitionUsageDescription</key>
<string>App needs speech recognition</string>

<key>NSMicrophoneUsageDescription</key>
<string>App needs microphone access</string>
*/
```

### Problem: Memory leak
```dart
// Solution: Always dispose properly
@override
void dispose() {
  _speechToText.stop();
  super.dispose();
}
```

---

## Testing Checklist

- [ ] Test on Android device
- [ ] Test on iOS device (physical, not simulator)
- [ ] Test Arabic speech recognition
- [ ] Test silence handling (3-second pause)
- [ ] Test permissions dialog
- [ ] Test permission denied scenario
- [ ] Test with background noise
- [ ] Test with Bluetooth headset
- [ ] Test network disconnection
- [ ] Test UI updates during recognition
- [ ] Verify proper resource cleanup
- [ ] Check for memory leaks

---

## Performance Tips

1. **Initialize once** - Do it in `initState()`, not on every tap
2. **Use `late`** - Initialize late to lazy-load when needed
3. **Stop when done** - Always call `stop()` to free resources
4. **Handle errors** - Gracefully handle speech API failures
5. **Partial results** - Enable for responsive real-time feedback
6. **Dispose properly** - Clean up in `dispose()` method

---

## Useful Links

- [speech_to_text Package](https://pub.dev/packages/speech_to_text)
- [Flutter Docs](https://flutter.dev/docs)
- [Android Speech Recognition](https://developer.android.com/reference/android/speech/SpeechRecognizer)
- [iOS Speech Framework](https://developer.apple.com/documentation/speech)

---

**Last Updated**: December 17, 2025
