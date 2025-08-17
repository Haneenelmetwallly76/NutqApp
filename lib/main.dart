import 'package:flutter/material.dart';
import 'theme.dart';
import 'screens/welcome_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/exercise_screen.dart';
import 'screens/signlanguagescreen.dart';
import 'screens/reportsscreen.dart';
import 'screens/progresstrackingscreen.dart';
import 'screens/feedbackscreen.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Kids Learning & Speech",
      theme: appTheme(),
      debugShowCheckedModeBanner: false,
      initialRoute: '/welcome',
      routes: {
        '/welcome': (context) => WelcomeScreen(
          onGetStarted: () {
            Navigator.pushReplacementNamed(context, '/dashboard');
          },
        ),
        '/dashboard': (_) => const DashboardScreen(),
        '/exercise': (_) => const ExerciseScreen(),
        '/sign_language': (_) => const SignLanguageScreen(),
        '/reports': (_) => const ReportsScreen(),
        '/progress': (_) => const ProgressTrackingScreen(),
        '/feedback': (_) => const FeedbackScreen(),
      },
    );
  }
}
