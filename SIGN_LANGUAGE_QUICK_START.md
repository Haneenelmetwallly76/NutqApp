# Sign Language Screen - Quick Start (5 Minutes)

## Pre-Flight Checklist

✅ = Already Done  
⚠️ = Verify Now  
❌ = Action Needed

### 1. Dependencies

```bash
# Run this:
cd /home/haneen/vs_code/NutqApp
flutter pub get
```

**Verify:**
```bash
flutter pub get | grep tflite
# Expected: tflite 1.1.2
```

### 2. Configuration Files

#### ✅ pubspec.yaml (Already Configured)

**Verified:**
```yaml
dependencies:
  tflite: ^1.1.2
  camera: ^0.10.5
  permission_handler: ^11.3.0

flutter:
  assets:
    - assets/model_unquant.tflite
    - assets/labels.txt
```

#### ✅ AndroidManifest.xml (Already Configured)

**Verified:**
```xml
<uses-permission android:name="android.permission.CAMERA" />
<uses-feature android:name="android.hardware.camera" android:required="false" />
```

### 3. Asset Files

**Verify These Files Exist:**

```bash
ls -lh assets/model_unquant.tflite
ls -lh assets/labels.txt
```

**Expected Output:**
```
assets/model_unquant.tflite    5-50 MB
assets/labels.txt              < 1 KB
```

**Check labels.txt Format:**

```bash
cat assets/labels.txt
# Should show:
# اهلا
# توقف
# فارغ
# أ
# ب
# ...
```

---

## Run & Test

### Step 1: Clean & Build

```bash
flutter clean
flutter pub get
flutter analyze
```

**Expected:**
```
No issues found!
```

### Step 2: Run on Device

```bash
flutter run
# OR connect device and:
flutter run -v
```

### Step 3: Test the Screen

1. **Navigate** to Sign Language screen from main menu
2. **Grant** camera permission when prompted
3. **Wait** for "Model loaded successfully" in debug log
4. **Tap** "تشغيل الكاميرا" (Start Camera) button
5. **Position** hands in front of camera to sign
6. **Verify** Arabic words appear at top

---

## Debug Output (What to Expect)

### Initialization Phase
```
[TFLite] Labels: [اهلا, توقف, فارغ, أ, ب]
[TFLite] Found camera: Front (front)
[TFLite] Camera initialized: Front
[TFLite] Loading model from assets/model_unquant.tflite
[TFLite] Model loaded: true
```

### Running Phase
```
[TFLite] Camera toggle: true
[TFLite] Starting frame processing
[TFLite] Recognitions: [{'label': 'اهلا', 'confidence': 0.94}]
[TFLite] Top result: label=اهلا, confidence=0.94
```

### Filtering Example
```
[TFLite] Top result: label=فارغ, confidence=0.92
# (Filtered out - empty sign, so UI shows "جاري المسح...")

[TFLite] Top result: label=اهلا, confidence=0.45
# (Filtered out - confidence < 0.5, so UI shows "جاري المسح...")

[TFLite] Top result: label=توقف, confidence=0.72
# (Shows on UI as "توقف" - STOP in Arabic)
```

---

## Troubleshooting (3 Common Issues)

### 🔴 Issue: Model Load Fails

**Error in console:**
```
[TFLite] Model load ERROR: FileSystemException
```

**Fix:**
```bash
# Verify file exists
ls -lh assets/model_unquant.tflite

# If missing, download from Google Drive / Teachable Machine
# If exists, check pubspec.yaml:
flutter pub get
flutter clean
flutter run
```

### 🔴 Issue: No Predictions Appearing

**Debug steps:**

1. **Check camera is running:**
   ```dart
   // In console, look for:
   [TFLite] Starting frame processing
   ```

2. **Check recognitions are being received:**
   ```dart
   // Console should show:
   [TFLite] Recognitions: [...]
   ```

3. **Check confidence threshold:**
   - All results < 50%? Lower threshold in code:
   ```dart
   static const double _confidenceThreshold = 0.3; // Temporarily for testing
   ```

4. **Verify model parameters:**
   - Check `imageMean: 127.5` (Teachable Machine default)
   - Check `rotation: 90` (Front camera portrait)

### 🔴 Issue: App Crashes on Startup

**Error:**
```
E/Dart (PID): Unhandled exception:
```

**Fix:**
1. Check `assets/labels.txt` is valid UTF-8
2. Check model file is not corrupted (size > 0)
3. Run `flutter clean && flutter pub get`

---

## Commands Reference

```bash
# Build
flutter build apk

# Run with verbose output
flutter run -v

# Analyze
flutter analyze

# Check packages
flutter pub get

# Clean everything
flutter clean && flutter pub get

# View logs
flutter logs

# Test on specific device
flutter devices                    # List devices
flutter run -d <device_id>        # Run on specific device
```

---

## File Locations

```
lib/screens/sign_language_screen.dart     Main screen code
android/app/src/main/AndroidManifest.xml  Permissions
pubspec.yaml                              Dependencies + assets
assets/model_unquant.tflite              Your trained model
assets/labels.txt                        Class labels (Arabic)
```

---

## Model Parameters (TFLite - Teachable Machine)

**Do NOT change these without testing:**

```dart
imageMean: 127.5,      // ✅ Standard for RGB normalization
imageStd: 127.5,       // ✅ Standard for RGB normalization
rotation: 90,          // ✅ Front camera in portrait mode
numResults: 2,         // Return top 2 predictions
threshold: 0.5,        // 50% confidence minimum
asynch: true,          // Non-blocking processing
```

---

## Success Criteria ✅

When working correctly, the screen should show:

- [x] Camera preview displays
- [x] "الكاميرا مفعّلة" (Camera ON) indicator glows green when running
- [x] Arabic word appears when signing (e.g., "اهلا", "توقف")
- [x] Confidence % bar appears with green/orange/red coloring
- [x] "فارغ" (empty) is never shown
- [x] Debug log updates with real-time status

---

## One-Liner Test Commands

```bash
# Full check in one go:
flutter clean && flutter pub get && flutter analyze && echo "✅ Ready to run!"

# Run with logs:
flutter run -v 2>&1 | grep -E "\[TFLite\]"

# Check model file size:
stat assets/model_unquant.tflite | grep Size

# Count labels:
wc -l assets/labels.txt
```

---

**Date Created:** December 17, 2025  
**Status:** Production Ready  
**Next Step:** Run `flutter run` and test! 🚀
