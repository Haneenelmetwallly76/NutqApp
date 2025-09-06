import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:new_notq_app/widgets/child_card.dart';
import 'package:new_notq_app/widgets/stat_parent_card.dart';
import 'package:new_notq_app/widgets/activity_card.dart';
import 'package:new_notq_app/widgets/action_button.dart';
import 'package:new_notq_app/screens/settings_page.dart';
import 'package:new_notq_app/screens/user_provider.dart';

class ParentDashboard extends ConsumerStatefulWidget {
  const ParentDashboard({super.key});

  @override
  _ParentDashboardState createState() => _ParentDashboardState();
}

class _ParentDashboardState extends ConsumerState<ParentDashboard> {
  int selectedBottomIndex = 4; // Parent tab selected

  List<int> weeklyActivity = [30, 30, 20, 35, 15, 0, 0];
  List<String> weekDays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);

    return Scaffold(
      backgroundColor: Colors.grey[50],
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Parent Dashboard',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Welcome ${user.name ?? "Parent"} 👋',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: Icon(Icons.settings, color: Colors.grey[600]),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const SettingsPage()),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Children
              const Text(
                'Children',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 16),

              if (user.childName != null) ...[
                ChildCard(
                  childName: user.childName!,
                  imageUrl: user.avatarUrl ??
                      'https://www.gravatar.com/avatar/placeholder',
                  age: user.childAge ?? 6,
                  level: user.childLevel ?? 'Beginner',
                  lastActivity: user.lastActivity ?? 'Just Joined',
                  weeklyTime: user.weeklyTime ?? 0,
                  weeklyGoal: user.weeklyGoal ?? 5,
                  goalProgress: user.goalProgress ?? 0.0,
                ),
              ] else
                const Text(
                  'No child registered yet.',
                  style: TextStyle(color: Colors.grey),
                ),

              const SizedBox(height: 32),

              // This Week's Activity
              const Text(
                'This Week\'s Activity',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 20),

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
                            color:
                            weeklyActivity[index] == 0 ? Colors.grey[300] : Colors.blue,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          weekDays[index],
                          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          weeklyActivity[index] == 0 ? '0m' : '${weeklyActivity[index]}m',
                          style: TextStyle(fontSize: 10, color: Colors.grey[500]),
                        ),
                      ],
                    );
                  }),
                ),
              ),
              const SizedBox(height: 24),

              // Stats
              Row(
                children: [
                  Expanded(
                    child: StatParentCard(
                      title: 'Minutes',
                      value: (user.totalMinutes ?? 0).toString(),
                      icon: Icons.timer,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: StatParentCard(
                      title: 'Lessons',
                      value: (user.totalLessons ?? 0).toString(),
                      icon: Icons.menu_book,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: StatParentCard(
                      title: 'Average Score',
                      value: user.averageScore ?? '0%',
                      icon: Icons.star,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Recent Activity
              const Text(
                'Recent Activity',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 16),

              ActivityCard(
                title: 'Completed Speech Therapy - Letter "R" Sounds',
                subtitle: '${user.childName ?? 'Emma'} • 85% • 2 hours ago',
                icon: Icons.mic,
                onTap: () {},
              ),
              const SizedBox(height: 12),

              ActivityCard(
                title: 'Finished Math lesson - Addition Basics',
                subtitle: '${user.childName ?? 'Emma'} • 92% • 3 hours ago',
                icon: Icons.calculate,
                onTap: () {},
              ),
              const SizedBox(height: 12),

              ActivityCard(
                title: 'Earned Badge - Quick Learner',
                subtitle: '${user.childName ?? 'Jack'} • 1 day ago',
                icon: Icons.emoji_events,
                onTap: () {},
              ),
              const SizedBox(height: 32),

              // Quick Actions
              const Text(
                'Quick Actions',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: ActionButton(
                      icon: Icons.schedule,
                      label: 'Set Schedule',
                      onPressed: () {},
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ActionButton(
                      icon: Icons.assessment,
                      label: 'View Reports',
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    child: ActionButton(
                      icon: Icons.settings,
                      label: 'App Settings',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const SettingsPage()),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ActionButton(
                      icon: Icons.person_add,
                      label: 'Add Child',
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
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
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Parent'),
        ],
      ),
    );
  }
}
