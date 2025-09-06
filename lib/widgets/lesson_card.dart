import 'package:flutter/material.dart';

class LessonCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String difficulty;
  final String subject;
  final String duration;
  final int stars;
  final bool isCompleted;
  final bool isLocked;

  const LessonCard({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.difficulty,
    required this.subject,
    required this.duration,
    required this.stars,
    required this.isCompleted,
    this.isLocked = false,
  });

  Color get difficultyColor {
    switch (difficulty.toLowerCase()) {
      case 'easy':
        return Colors.green;
      case 'medium':
        return Colors.orange;
      case 'hard':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: isLocked ? Colors.grey : Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: difficultyColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        difficulty,
                        style: TextStyle(
                          fontSize: 12,
                          color: difficultyColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      subject,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                    Text(
                      ' • $duration',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (stars > 0)
            Row(
              children: List.generate(3, (index) {
                return Icon(
                  Icons.star,
                  size: 16,
                  color: index < stars ? Colors.amber : Colors.grey[300],
                );
              }),
            ),
        ],
      ),
    );
  }
}
