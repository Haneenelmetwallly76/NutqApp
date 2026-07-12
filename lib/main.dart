import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'theme.dart';

// Screens
import 'screens/welcome_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/exercise_screen.dart';
import 'screens/signlanguagescreen.dart';
import 'screens/progresstrackingscreen.dart';
import 'screens/feedbackscreen.dart';
import 'screens/sign_in_screen.dart';
import 'screens/sign_up_child.dart';
import 'screens/sign_up_parent.dart';
import 'screens/sign_up_doctor.dart';
import 'screens/daily_learning_screen.dart';
import 'screens/parent_dashboard.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  runApp(const ProviderScope(child: App()));
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
        '/dashboard': (context) => const DashboardScreen(),
        '/exercise': (_) => const ExerciseScreen(),
        '/sign_language': (_) => const SignLanguageScreen(),
        // '/reports': (_) => const ReportsScreen(), // ❌ متشال عشان يمنع التعارض
        '/progress': (_) => const ProgressTrackingScreen(),
        '/feedback': (_) => const FeedbackScreen(),
        '/sign_in': (context) => const SignInScreen(),
        '/sign_up_child': (_) => const SignUpChild(),
        '/sign_up_parent': (_) => const SignUpParent(),
        '/sign_up_doctor': (_) => const SignUpDoctor(),
        '/daily-learning': (_) => const DailyLearningScreen(),
        '/parent': (context) => const ParentDashboard(),
      },
    );
  }
}
