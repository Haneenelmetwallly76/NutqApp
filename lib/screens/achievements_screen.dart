import 'package:flutter/material.dart';
import '../widgets/achievements_header_widget.dart';
import '../widgets/achievement_score_widget.dart';
import '../widgets/achievement_card.dart';


class AchievementsScreen extends StatefulWidget {
  const AchievementsScreen({super.key});

  @override
  _AchievementsScreenState createState() => _AchievementsScreenState();
}

class _AchievementsScreenState extends State<AchievementsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: const SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AchievementsHeaderWidget(),


              SizedBox(height: 20),
              AchievementScoreWidget(),

              SizedBox(height: 25),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Recent Achievements',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              SizedBox(height: 16),

              AchievementCard(
                icon: Icons.emoji_events,
                iconColor: Colors.amber,
                title: 'Math Master',
                description: 'Complete 10 math lessons',
                dateEarned: '2 days ago',
                isUnlocked: true,
                backgroundColor: Color(0xFFFFF3CD),
              ),
              SizedBox(height: 12),

              AchievementCard(
                icon: Icons.local_fire_department,
                iconColor: Colors.red,
                title: 'Week Warrior',
                description: 'Study for 7 days straight',
                dateEarned: '1 week ago',
                isUnlocked: true,
                backgroundColor: Color(0xFFFFE5E5),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
