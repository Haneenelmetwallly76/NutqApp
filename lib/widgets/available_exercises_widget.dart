import 'package:flutter/material.dart';
import 'exercise_card_widget.dart';

class AvailableExercisesWidget extends StatelessWidget {
  const AvailableExercisesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: const [
          ExerciseCard(
            icon: Icons.check_circle,
            iconColor: Colors.green,
            title: 'Letter "R" Sounds',
            subtitle: '5 words',
            progress: '85%',
            isCompleted: true,
          ),
          SizedBox(height: 12),
          ExerciseCard(
            icon: Icons.play_arrow,
            iconColor: Colors.pinkAccent,
            title: 'Letter "S" Sounds',
            subtitle: '5 words',
            progress: null,
            isCompleted: false,
          ),
          SizedBox(height: 12),
          ExerciseCard(
            icon: Icons.play_arrow,
            iconColor: Colors.pinkAccent,
            title: 'Tongue Twisters',
            subtitle: '3 words',
            progress: null,
            isCompleted: false,
          ),
        ],
      ),
    );
  }
}
