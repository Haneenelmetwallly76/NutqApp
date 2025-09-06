import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:new_notq_app/widgets/child_card.dart';
import 'package:new_notq_app/widgets/stat_parent_card.dart';
import 'package:new_notq_app/widgets/activity_card.dart';
import 'package:new_notq_app/screens/user_provider.dart';
import 'package:new_notq_app/screens/settings_page.dart';

class DoctorDashboard extends ConsumerStatefulWidget {
  const DoctorDashboard({super.key});

  @override
  _DoctorDashboardState createState() => _DoctorDashboardState();
}

class _DoctorDashboardState extends ConsumerState<DoctorDashboard> {
  int selectedBottomIndex = 0;

  List<int> weeklyActivity = [30, 45, 20, 35, 15, 0, 0];
  List<String> weekDays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);

    // Null-safety & cast fixes
    final childName = user.childName as String? ?? 'Unknown';
    final avatarUrl = user.avatarUrl as String? ??
        'https://www.gravatar.com/avatar/placeholder';
    final childAge = user.childAge as int? ?? 6;
    final childLevel = user.childLevel as String? ?? '1';
    final lastActivity = user.lastActivity as String? ?? 'Just Joined';
    final weeklyTime = user.weeklyTime as int? ?? 0;
    final weeklyGoal = user.weeklyGoal as int? ?? 5;
    final goalProgress = user.goalProgress as double? ?? 0.0;
    final totalMinutes = user.totalMinutes as int? ?? 0;
    final totalLessons = user.totalLessons as int? ?? 0;
    final averageScore = user.averageScore as String? ?? '0%';

    // Theme colors
    final primaryColor = Color(0xFF2E3A59); // Dark Blue
    final accentColor = Color(0xFFF5A623);  // Gold
    final backgroundColor = Color(0xFFF2F2F7); // Light Grey
    final cardBackground = Colors.white;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Doctor Dashboard',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.settings, color: primaryColor),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SettingsPage(),
                        ),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Child Info
              ChildCard(
                childName: childName,
                imageUrl: avatarUrl,
                age: childAge,
                level: childLevel,
                lastActivity: lastActivity,
                weeklyTime: weeklyTime,
                weeklyGoal: weeklyGoal,
                goalProgress: goalProgress,
              ),
              const SizedBox(height: 32),

              // This Week's Activity
              Text(
                "This Week's Activity",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 120,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: List.generate(7, (index) {
                    final maxHeight =
                    weeklyActivity.reduce((a, b) => a > b ? a : b).toDouble();
                    final height = weeklyActivity[index] == 0
                        ? 8.0
                        : (weeklyActivity[index] / maxHeight) * 80 + 8;

                    return Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          width: 32,
                          height: height,
                          decoration: BoxDecoration(
                            color: weeklyActivity[index] == 0
                                ? Colors.grey[300]
                                : accentColor,
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          weekDays[index],
                          style: TextStyle(
                              fontSize: 12, color: Colors.grey[600]),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${weeklyActivity[index]}m',
                          style: TextStyle(
                              fontSize: 10, color: Colors.grey[500]),
                        ),
                      ],
                    );
                  }),
                ),
              ),
              const SizedBox(height: 32),

              // Stats
              Row(
                children: [
                  Expanded(
                    child: StatParentCard(
                      title: 'Minutes',
                      value: totalMinutes.toString(),
                      icon: Icons.timer,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: StatParentCard(
                      title: 'Lessons',
                      value: totalLessons.toString(),
                      icon: Icons.menu_book,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: StatParentCard(
                      title: 'Average Score',
                      value: averageScore,
                      icon: Icons.star,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Recent Activity (dummy examples)
              Text(
                'Recent Activity',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
              const SizedBox(height: 16),
              ActivityCard(
                title: 'Completed Speech Therapy - Letter "R"',
                subtitle: '$childName • 85% • 2 hours ago',
                icon: Icons.mic,
                onTap: () {},
              ),
              const SizedBox(height: 12),
              ActivityCard(
                title: 'Finished Math lesson - Addition Basics',
                subtitle: '$childName • 92% • 3 hours ago',
                icon: Icons.calculate,
                onTap: () {},
              ),
              const SizedBox(height: 12),
              ActivityCard(
                title: 'Earned Badge - Quick Learner',
                subtitle: '$childName • 1 day ago',
                icon: Icons.emoji_events,
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: accentColor,
        unselectedItemColor: Colors.grey[500],
        currentIndex: selectedBottomIndex,
        onTap: (index) {
          setState(() {
            selectedBottomIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.school), label: 'Learn'),
          BottomNavigationBarItem(icon: Icon(Icons.mic), label: 'Speech'),
          BottomNavigationBarItem(icon: Icon(Icons.emoji_events), label: 'Awards'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Doctor'),
        ],
      ),
    );
  }
}
