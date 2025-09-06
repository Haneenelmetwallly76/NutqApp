// widgets/child_card.dart
import 'package:flutter/material.dart';

class ChildCard extends StatelessWidget {
  final String childName;
  final String avatarUrl;
  final String imageUrl;

  final int age;
  final String level;
  final String lastActivity;
  final int weeklyTime;   // بالدقايق أو الساعات
  final int weeklyGoal;   // الهدف
  final double goalProgress; // نسبة الإنجاز (0 → 1)

  const ChildCard({
    Key? key,
    required this.childName,
    this.avatarUrl = 'https://i.pravatar.cc/150?img=3', // افتراضي
    this.imageUrl ='',
    this.age = 6,
    this.level = 'Beginner',
    this.lastActivity = 'Just Joined',
    this.weeklyTime = 0,
    this.weeklyGoal = 5,
    this.goalProgress = 0.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 32,
              backgroundImage: NetworkImage(avatarUrl),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(childName,
                      style: Theme.of(context).textTheme.titleMedium),
                  Text("Age: $age"),
                  Text("Level: $level"),
                  Text("Last Activity: $lastActivity"),
                  Text("Weekly: $weeklyTime / $weeklyGoal mins"),
                  LinearProgressIndicator(value: goalProgress),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
