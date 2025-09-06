import 'package:flutter/material.dart';

class WeeklyProgressWidget extends StatelessWidget {
  final List<bool> weeklyProgress;
  final List<String> weekDays;

  const WeeklyProgressWidget({
    super.key,
    required this.weeklyProgress,
    required this.weekDays,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'This Week\'s Progress',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 20),
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(7, (index) {
                      return Column(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: weeklyProgress[index]
                                  ? Colors.green
                                  : (index == 4
                                  ? Colors.pinkAccent.withOpacity(0.3)
                                  : Colors.grey[300]),
                            ),
                            child: weeklyProgress[index]
                                ? const Icon(Icons.check, color: Colors.white, size: 20)
                                : (index == 4
                                ? Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.pinkAccent,
                              ),
                            )
                                : null),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            weekDays[index],
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      );
                    }),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Average Score: 83%',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
