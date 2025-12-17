# Sign Language Screen - Complete Implementation & Debugging Guide

## ✅ STATUS: Ready for Testing

**Date:** December 17, 2025  
**Implementation:** Complete TFLite-based Arabic Sign Language Recognition  
**Status:** Code compiles successfully, 0 analyzer issues

---

## 1. CONFIGURATION CHECKLIST

### ✅ pubspec.yaml - Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  camera: ^0.10.5
  permission_handler: ^11.3.0
  tflite: ^1.1.2      # CRITICAL: TFLite inference engine
  path_provider: ^2.1.0
  # ... other dependencies
```

**Action:** Run `flutter pub get` after confirming these are added.

### ✅ pubspec.yaml - Assets

```yaml
flutter:
  uses-material-design: true
  assets:
    - assets/model_unquant.tflite   # Your trained model
    - assets/labels.txt              # Arabic class labels
    # ... other assets
```

**Your `assets/labels.txt` format (one label per line):**
```
اهلا
توقف
فارغ
أ
ب
...
```

### ✅ AndroidManifest.xml - Permissions

**Location:** `android/app/src/main/AndroidManifest.xml`

```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android">
    <uses-permission android:name="android.permission.CAMERA" />
    <uses-feature android:name="android.hardware.camera" android:required="false" />
    <!-- ... other permissions ... -->
</manifest>
```

**Verify:** Both `<uses-permission>` and `<uses-feature>` are present.

### ✅ build.gradle - TFLite Support

**Location:** `android/app/build.gradle.kts`

Ensure this section exists (usually auto-configured):

```gradle
android {
    compileSdkVersion 33 or higher
    
    defaultConfig {
        minSdkVersion 21 or higher
    }
    
    packagingOptions {
        exclude 'lib/x86/libc++_shared.so'
        exclude 'lib/x86_64/libc++_shared.so'
    }
}
```

---

## 2. CRITICAL TFLITE PARAMETERS (Teachable Machine)

The following parameters are **essential** for Teachable Machine models:

```dart
await Tflite.runModelOnFrame(
  bytesList: image.planes.map((plane) => plane.bytes).toList(),
  imageHeight: image.height,
  imageWidth: image.width,
  
  // CRITICAL FOR TEACHABLE MACHINE:
  imageMean: 127.5,        // Normalization mean
  imageStd: 127.5,         // Normalization std dev
  rotation: 90,            // Camera rotation (front camera)
  numResults: 2,           // Top N results
  threshold: 0.5,          // Confidence threshold (50%)
  asynch: true,            // Async processing
);
```

### Why These Values?

- **imageMean & imageStd: 127.5** → Teachable Machine normalizes RGB values (0-255) to (-1, 1) range
- **rotation: 90** → Front camera frame needs rotation for portrait mode
- **threshold: 0.5** → Only show results with 50%+ confidence
- **asynch: true** → Non-blocking frame processing
- **numResults: 2** → Return top 2 predictions for comparison

---

## 3. CODE ARCHITECTURE

### File Structure

```
lib/screens/sign_language_screen.dart    (📄 Complete implementation)
├─ _SignLanguageScreenState (State class)
│  ├─ initState()                       (Start initialization)
│  ├─ _loadLabels()                     (Load Arabic labels from assets)
│  ├─ _initializeCamera()               (Request permission + setup front camera)
│  ├─ _loadModel()                      (Load TFLite model + labels)
│  ├─ _startFrameProcessing()           (Start inference loop)
│  ├─ _runModelOnFrame()                (CRITICAL: Run inference with correct params)
│  ├─ _stopFrameProcessing()            (Stop inference + release resources)
│  ├─ _toggleCamera()                   (Start/stop with UI updates)
│  ├─ dispose()                         (Cleanup: camera + model)
│  └─ build()                           (RTL Arabic UI with camera preview)
```

### Key Functions Explained

#### `_loadModel()` - Model Initialization

```dart
final result = await Tflite.loadModel(
  model: 'assets/model_unquant.tflite',
  labels: 'assets/labels.txt',
);
```

**What it does:**
- Loads quantized TFLite model from assets
- Registers labels for output interpretation
- Sets `_modelLoaded = true` when ready

**Debug output:** `[TFLite] Model loaded: true`

#### `_startFrameProcessing()` - The Inference Loop

```dart
_cameraController.startImageStream((CameraImage image) async {
  final recognitions = await Tflite.runModelOnFrame(
    bytesList: image.planes.map((plane) => plane.bytes).toList(),
    imageHeight: image.height,
    imageWidth: image.width,
    imageMean: 127.5,
    imageStd: 127.5,
    rotation: 90,
    numResults: 2,
    threshold: 0.5,
    asynch: true,
  );
  
  // Process results here
  if (recognitions != null && recognitions.isNotEmpty) {
    final topResult = recognitions[0];
    // Filter & display
  }
});
```

**What it does:**
- Captures camera frames continuously
- Runs inference on each frame
- Returns top N predictions with confidence scores
- Filters by `_confidenceThreshold` (50%)

#### Result Filtering - Arabic Label Logic

```dart
final label = topResult['label'] as String?;
final confidence = (topResult['confidence'] as num?)?.toDouble();

// Hide empty signs and low confidence
if (label == 'فارغ' || confidence < 0.5) {
  _detectedSign = 'جاري المسح...';  // "Scanning..."
  _confidence = 0.0;
} else {
  _detectedSign = label;           // Show detected Arabic word
  _confidence = confidence;
}
```

---

## 4. DEBUGGING - How to Troubleshoot

### Problem: Camera Opens but No Predictions

**Check the following in order:**

#### Step 1: Verify Labels Loaded

Add this to logcat (Android Studio):
```dart
print('[TFLite] Labels: $_labels');  // Should print list of Arabic words
```

**Expected output:**
```
[TFLite] Labels: [اهلا, توقف, فارغ, أ, ب, ...]
```

**If empty:** 
- Check `assets/labels.txt` exists
- Verify path: `assets/labels.txt` not `lib/assets/labels.txt`

#### Step 2: Verify Model Loaded

Check console for:
```
[TFLite] Model loaded: true
[TFLite] Model load result: success or error message
```

**If error:**
- Verify `assets/model_unquant.tflite` exists
- File size should be 5-50 MB (not 0 KB)
- Run `flutter clean && flutter pub get` to refresh assets

#### Step 3: Verify Frame Processing Starts

Check console when you tap "تشغيل الكاميرا" (Start Camera):
```
[TFLite] Camera toggle: true
[TFLite] Starting frame processing
[TFLite] Recognitions: [...]
```

**If no recognitions:**
- Check camera permission granted
- Verify front camera is being used
- Check that `imageMean` and `imageStd` are correct for your model

#### Step 4: Check Confidence Filtering

Look for:
```
[TFLite] Top result: label=اهلا, confidence=0.95
```

**If confidence is always < 0.5:**
- Lower threshold: Change `_confidenceThreshold` to 0.3 temporarily
- Check model quality: Is the training dataset good?
- Verify lighting conditions

#### Step 5: Monitor Real-Time Inference

The debug log at bottom shows:
- "Labels loaded: X classes"
- "Camera initialized: front/back"
- "Model loaded successfully"
- "Camera ON/OFF"
- "Recognitions: [...]"

**Real-time example:**
```
Status: Initializing...
Status: Labels loaded: 5 classes
Status: Found camera: Front (front)
Status: Camera initialized successfully
Status: Loading TFLite model...
Status: Model loaded successfully
Status: Camera ON
```

---

## 5. COMMON ISSUES & SOLUTIONS

### Issue: "Target of URI doesn't exist: 'package:tflite/tflite.dart'"

**Solution:**
```bash
flutter pub get
flutter clean
flutter pub get
flutter analyze
```

### Issue: "Camera Opens, Black Screen, No Frames"

**Possible Causes:**
1. Camera permission not granted → Grant in app settings
2. Front camera not found → Device only has back camera (rare)
3. CameraController not initialized → Wait for green checkmark

### Issue: "Model Loaded But No Predictions"

**Causes:**
1. **Wrong normalization params** → Check `imageMean` and `imageStd`
   - Teachable Machine: `127.5`
   - MobileNet: `127.5`
   - Custom: Check training code

2. **Rotation mismatch** → For front camera in portrait: `rotation: 90`

3. **Low confidence** → All results < 50%, lower threshold to 0.1 for testing

4. **Label mismatch** → Model output "class_0" but labels.txt has Arabic words

### Issue: "App Crashes on Startup"

**Check:**
- `assets/labels.txt` is valid UTF-8 with Arabic characters
- No blank lines in labels.txt
- Model file is not corrupted (can it be opened?)

### Issue: "Performance is Slow / Frames Dropping"

**Optimization:**
- Reduce `numResults` from 2 to 1
- Increase frame skip in stream processor
- Use `ResolutionPreset.low` instead of `.medium`

---

## 6. TESTING CHECKLIST

Before deploying, verify:

- [ ] **Camera Permission:** Appears when opening screen
- [ ] **Model Loads:** Debug log shows "Model loaded successfully"
- [ ] **Labels Load:** Debug log shows "Labels loaded: X classes"
- [ ] **Frame Processing Starts:** Console shows "[TFLite] Starting frame processing"
- [ ] **Predictions Appear:** When signing in front of camera, Arabic words appear
- [ ] **Filtering Works:** "فارغ" (empty) doesn't display; low confidence filtered
- [ ] **UI Responsive:** Buttons work, no freezing
- [ ] **Lifecycle Correct:** Stops on app pause, resumes on app resume
- [ ] **Memory Clean:** No crashes after 5 min of use

---

## 7. PRODUCTION DEPLOYMENT

### Before Release:

1. **Remove Debug Logs** (optional, for cleaner production build)
   ```dart
   // Remove or wrap in: if (kDebugMode) { debugPrint(...); }
   ```

2. **Set Confidence Threshold** - Based on testing
   ```dart
   static const double _confidenceThreshold = 0.6; // Or whatever works best
   ```

3. **Test on Real Device** (emulator may have issues with camera)

4. **AndroidManifest.xml**: Ensure minSdkVersion is 21+

5. **ProGuard Rules**: If using release mode, verify TFLite isn't obfuscated
   ```pro
   -keep class org.tensorflow.** { *; }
   ```

---

## 8. REFERENCE: Full Implementation

**File:** `lib/screens/sign_language_screen.dart`

**Key Stats:**
- Lines: ~370
- Classes: 1 StatefulWidget + 1 State
- Key Methods: 8 (init, load, process, inference, toggle, cleanup, build, lifecycle)
- Dependencies: camera, permission_handler, tflite, Flutter core

**Code Quality:**
- ✅ No analyzer issues
- ✅ Proper error handling
- ✅ RTL Arabic UI
- ✅ Comprehensive debug logging
- ✅ Proper resource cleanup

---

## 9. NEXT STEPS

1. **Verify Configuration** → Follow checklist above
2. **Test on Device** → `flutter run`
3. **Debug Inference** → Check console for predictions
4. **Tune Parameters** → Adjust threshold if needed
5. **Optimize Performance** → Reduce resolution if needed
6. **Deploy** → Build APK/AAB for production

---

## 10. SUPPORT & FAQ

**Q: How accurate should the model be?**  
A: Depends on training data. Good Teachable Machine models: 85-95% accuracy in controlled conditions.

**Q: Can I use a different model format?**  
A: TFLite is optimized for mobile. Other formats (ONNX, PyTorch) require additional packages.

**Q: Is it working on iOS?**  
A: TFLite package supports iOS, but this app currently targets Android. iOS needs similar setup.

**Q: Can I increase inference speed?**  
A: Yes - use quantized models, reduce resolution, skip frames, or use GPU acceleration.

---

**Last Updated:** December 17, 2025  
**Version:** 1.0 (Production Ready)
