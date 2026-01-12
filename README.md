# 🎯 NutqApp - Kids Learning & Speech Therapy

> Professional speech therapy and sign language learning platform for children with AI-powered recognition.

![Flutter](https://img.shields.io/badge/Flutter-3.3.0-02569B?logo=flutter)
![Dart](https://img.shields.io/badge/Dart-3.3.0-0175C2?logo=dart)
![License](https://img.shields.io/badge/License-MIT-green)
![Status](https://img.shields.io/badge/Status-Production%20Ready-success)

---

## 📱 Screenshots

### Welcome & Authentication
![Welcome Screen](screenshots/01-welcome.png) | ![Sign Up](screenshots/02-signup.png) | ![Sign In](screenshots/03-signin.png)
---|---|---

### Main Features
![Dashboard](screenshots/04-dashboard.png) | ![Speech Therapy](screenshots/05-speech-therapy.png) | ![Sign Language](screenshots/06-sign-language.png)
---|---|---

### Progress & Analytics
![Progress Tracking](screenshots/07-progress.png) | ![Daily Learning](screenshots/08-daily-learning.png) | ![Parent Dashboard](screenshots/09-parent-dashboard.png)
---|---|---

---

## ✨ Key Features

### 🎤 Speech Therapy
- Real-time speech recognition with Arabic support
- Interactive pronunciation exercises
- Instant feedback and transcription
- Weekly progress tracking

### 🖐️ Sign Language Recognition
- AI-powered gesture detection (TensorFlow Lite)
- Live camera stream processing
- Arabic sign language support
- Confidence scoring

### 📊 Progress & Analytics
- Visual performance charts
- Achievement tracking
- Daily learning goals
- Detailed reports

### 👥 Multi-Role Platform
- Child-friendly interactive interface
- Parent activity monitoring
- Doctor professional dashboard
- Role-based access control

---

## 🛠️ Tech Stack

- **Frontend**: Flutter 3.3.0 + Dart 3.3.0
- **State Management**: Riverpod
- **AI/ML**: TensorFlow Lite, Speech-to-Text APIs
- **Backend**: Google Sign-In, HTTP APIs
- **Storage**: Path Provider
- **Camera & Audio**: Camera, Record, Permission Handler

---

## 📦 Installation & Setup

### Prerequisites
```bash
Flutter SDK >= 3.3.0
Dart SDK >= 3.3.0
Android Studio / Xcode
```

### Quick Start
```bash
# Clone repository
git clone https://github.com/Haneenelmetwallly76/NutqApp.git
cd NutqApp

# Install dependencies
flutter pub get

# Configure native dependencies
cd android && ./gradlew build && cd ..
cd ios && pod install && cd ..

# Run app
flutter run

# Build release
flutter build apk --release
```

---

## 🚀 Usage

### Speech Therapy
1. Open app → Dashboard → Speech Therapy
2. Select exercise and tap microphone
3. Speak naturally for up to 30 seconds
4. Get instant transcription feedback
5. Earn points and track progress

### Sign Language
1. Go to Sign Language screen
2. Grant camera permission
3. Perform gestures in front of camera
4. View detected signs with confidence scores
5. Track your improvement

### Parent/Doctor Roles
- Monitor child/patient progress
- Access detailed analytics and reports
- Set learning goals and milestones
- Export performance data

---

## 📁 Project Structure

```
lib/
├── screens/           # UI screens
├── services/          # Business logic
├── widgets/           # Reusable components
└── providers/         # State management

assets/
├── images/            # App assets
├── model_unquant.tflite
└── labels.txt
```

---

## 📚 Key Dependencies

| Package | Purpose |
|---------|---------|
| `google_fonts` | Typography |
| `google_sign_in` | Authentication |
| `flutter_riverpod` | State management |
| `camera` | Real-time video |
| `record` | Audio recording |
| `permission_handler` | Runtime permissions |
| `http` | API requests |
| `web_socket_channel` | Real-time communication |

See [pubspec.yaml](pubspec.yaml) for all dependencies.

---

## 📱 App Screens

1. **Welcome** - Onboarding with role selection
2. **Dashboard** - Navigation hub  
3. **Speech Therapy** - Interactive pronunciation practice
4. **Sign Language** - Real-time AI gesture detection
5. **Exercise Screen** - Browse exercises
6. **Progress Tracking** - Analytics & metrics
7. **Daily Learning** - Structured learning plan
8. **Parent Dashboard** - Activity monitoring
9. **Doctor Dashboard** - Professional tools
10. **Settings** - User preferences

---

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit changes (`git commit -m 'Add feature'`)
4. Push to branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

---

## 📝 License

MIT License - See [LICENSE](LICENSE) for details

---

## 👨‍💼 Author

**Haneen Elmetwalley**  
GitHub: [@Haneenelmetwallly76](https://github.com/Haneenelmetwallly76)

---

## 📞 Support

- 🐛 [Report Issues](https://github.com/Haneenelmetwallly76/NutqApp/issues)
- 📖 [Documentation](SIGN_LANGUAGE_IMPLEMENTATION.md)

---

**Last Updated**: January 2026 | **Status**: ✅ Production Ready
