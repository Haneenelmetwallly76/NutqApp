import 'package:flutter/material.dart';
import 'package:new_notq_app/widgets/daily_learning_header_widget.dart';
import '../widgets/progress_card.dart';
import '../widgets/lesson_card.dart';

class DailyLearningScreen extends StatelessWidget {
  const DailyLearningScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: const SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DailyLearningHeaderWidget(
                title: "Learning Center 📚",
                subtitle: "Choose what you'd like to learn today!",
              ),

              SizedBox(height: 20),

              // ==== Your Progress Section ====
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'Your Progress',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              SizedBox(height: 16),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: ProgressCard(
                            icon: Icons.calculate,
                            iconColor: Colors.blue,
                            subject: 'Math',
                            progress: 75,
                            backgroundColor: Colors.white,
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: ProgressCard(
                            icon: Icons.menu_book,
                            iconColor: Colors.purple,
                            subject: 'Reading',
                            progress: 60,
                            backgroundColor: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: ProgressCard(
                            icon: Icons.science,
                            iconColor: Colors.green,
                            subject: 'Science',
                            progress: 40,
                            backgroundColor: Colors.white,
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: ProgressCard(
                            icon: Icons.palette,
                            iconColor: Colors.pink,
                            subject: 'Art',
                            progress: 90,
                            backgroundColor: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(height: 32),

              // ==== Available Lessons Section ====
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'Available Lessons',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              SizedBox(height: 16),

              LessonCard(
                icon: Icons.check_circle,
                iconColor: Colors.green,
                title: 'Counting to 10',
                difficulty: 'Easy',
                subject: 'Math',
                duration: '5 min',
                stars: 3,
                isCompleted: true,
              ),
              SizedBox(height: 12),

              LessonCard(
                icon: Icons.check_circle,
                iconColor: Colors.green,
                title: 'Letter Sounds A-E',
                difficulty: 'Easy',
                subject: 'Reading',
                duration: '8 min',
                stars: 2,
                isCompleted: true,
              ),
              SizedBox(height: 12),

              LessonCard(
                icon: Icons.play_arrow,
                iconColor: Colors.blue,
                title: 'Addition Basics',
                difficulty: 'Medium',
                subject: 'Math',
                duration: '10 min',
                stars: 0,
                isCompleted: false,
              ),
              SizedBox(height: 12),

              LessonCard(
                icon: Icons.play_arrow,
                iconColor: Colors.blue,
                title: 'Story Time',
                difficulty: 'Medium',
                subject: 'Reading',
                duration: '12 min',
                stars: 0,
                isCompleted: false,
              ),
              SizedBox(height: 12),

              LessonCard(
                icon: Icons.lock,
                iconColor: Colors.grey,
                title: 'Multiplication',
                difficulty: 'Hard',
                subject: 'Math',
                duration: '15 min',
                stars: 0,
                isCompleted: false,
                isLocked: true,
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
