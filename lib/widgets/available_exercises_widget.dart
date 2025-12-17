import 'package:flutter/material.dart';
import 'exercise_card_widget.dart';

class AvailableExercisesWidget extends StatelessWidget {
  const AvailableExercisesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          ExerciseCard(
            icon: Icons.check_circle,
            iconColor: Colors.green,
            title: 'حرف الراء',
            subtitle: '5 كلمات',
            progress: '85%',
            isCompleted: true,
          ),
          SizedBox(height: 12),
          ExerciseCard(
            icon: Icons.play_arrow,
            iconColor: Colors.pinkAccent,
            title: 'حرف السين',
            subtitle: '5 كلمات',
            progress: null,
            isCompleted: false,
          ),
          SizedBox(height: 12),
          ExerciseCard(
            icon: Icons.play_arrow,
            iconColor: Colors.pinkAccent,
            title: 'جمل تحدي',
            subtitle: '3 كلمات',
            progress: null,
            isCompleted: false,
          ),
        ],
      ),
    );
  }
}
