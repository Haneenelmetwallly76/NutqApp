import 'package:flutter/material.dart';

class ProfileCardWidget extends StatelessWidget {
  final String name;
  final String role;
  final int points;
  final int level;

  const ProfileCardWidget({
    super.key,
    required this.name,
    required this.role,
    required this.points,
    required this.level,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: Colors.purple.withOpacity(0.2),
              child: const Icon(Icons.person, color: Colors.purple, size: 30),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    role,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 18),
                      const SizedBox(width: 4),
                      Text("Points: $points"),
                      const SizedBox(width: 12),
                      const Icon(Icons.upgrade, color: Colors.blue, size: 18),
                      const SizedBox(width: 4),
                      Text("Level: $level"),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
