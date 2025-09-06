import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'user_provider.dart';

import 'package:new_notq_app/screens/daily_learning_screen.dart';
import 'package:new_notq_app/screens/speech_therapy_screen.dart';
import 'package:new_notq_app/screens/achievements_screen.dart';
import 'package:new_notq_app/screens/sign_language_screen.dart';
import 'package:new_notq_app/screens/ReportsScreen.dart';
import 'package:new_notq_app/screens/setting.dart';

// Widgets
import '../widgets/dashboard_header_widget.dart';
import '../widgets/stat_card_widget.dart';
import '../widgets/quick_card_widget.dart';
import '../widgets/profile_card_widget.dart';

final pointsProvider = StateProvider<int>((ref) => 0);

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);
    final points = ref.watch(pointsProvider);

    if (user.role.isEmpty) {
      return const Scaffold(
        body: Center(
          child: Text('Role is not set! Please go back and select a role.'),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // ==== Header ====
              DashboardHeaderWidget(
                name: user.name ?? user.username ?? "User",
                role: user.role,
              ),

              const SizedBox(height: 20),

              // ==== Stats Section ====
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  children: const [
                    StatCardWidget(
                        title: "Streak",
                        value: "7 days",
                        icon: Icons.local_fire_department,
                        color: Colors.red),
                    StatCardWidget(
                        title: "Time Today",
                        value: "25 min",
                        icon: Icons.access_time,
                        color: Colors.blue),
                    StatCardWidget(
                        title: "Goals",
                        value: "3/5",
                        icon: Icons.flag,
                        color: Colors.yellow),
                    StatCardWidget(
                        title: "Awards",
                        value: "12",
                        icon: Icons.emoji_events,
                        color: Colors.orange),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // ==== Quick Start ====
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  "Quick Start",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 12),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    QuickCardWidget(
                      title: "Daily Learning",
                      icon: Icons.book,
                      color: Color(0xFF9C27B0),
                      page: DailyLearningScreen(),
                    ),
                    QuickCardWidget(
                      title: "Speech Practice",
                      icon: Icons.mic,
                      color: Colors.pinkAccent,
                      page: SpeechTherapyScreen(),
                    ),
                    QuickCardWidget(
                      title: "Sign Language",
                      icon: Icons.waving_hand,
                      color: Color(0xFF00BCD4),
                      page: SignLanguageScreen(),
                    ),
                    QuickCardWidget(
                      title: "View Achievements",
                      icon: Icons.star,
                      color: Colors.amber,
                      page: AchievementsScreen(),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // ==== Profile Card ====
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ProfileCardWidget(
                  name: user.name ?? user.username ?? "User",
                  role: user.role,
                  points: points,
                  level: 8,
                ),
              ),

              const SizedBox(height: 80),
            ],
          ),
        ),
      ),

      // ==== Bottom Navigation ====
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        onTap: (index) {
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => DailyLearningScreen()),
            );
          } else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AchievementsScreen()),
            );
          } else if (index == 3) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ReportsScreen()),
            );
          } else if (index == 4) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SettingsScreen()),
            );
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: "Learn"),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: "Progress"),
          BottomNavigationBarItem(icon: Icon(Icons.receipt), label: "Reports"),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Settings"),
        ],
        selectedItemColor: Colors.purple,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
      ),
    );
  }
}
