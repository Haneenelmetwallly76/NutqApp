import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Provider for tracking sign language progress
final signLanguageProgressProvider = StateProvider<Map<String, dynamic>>((ref) => {
  'lettersLearned': 12,
  'wordsLearned': 45,
  'practiceTime': 180, // in minutes
  'currentStreak': 5,
  'totalSessions': 23,
  'accuracy': 87.5,
});

class SignLanguageScreen extends ConsumerWidget {
  const SignLanguageScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progress = ref.watch(signLanguageProgressProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ==== Header ====
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF00BCD4), Color(0xFF00E5FF)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.arrow_back, color: Colors.white),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          "Sign Language Learning 🤟",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Master the art of visual communication",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // ==== Progress Stats ====
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 1.1,
                  children: [
                    _buildStatCard(
                      "Letters Learned",
                      "${progress['lettersLearned']}/26",
                      Icons.abc,
                      const Color(0xFF4CAF50),
                    ),
                    _buildStatCard(
                      "Words Mastered",
                      "${progress['wordsLearned']}",
                      Icons.text_fields,
                      const Color(0xFF2196F3),
                    ),
                    _buildStatCard(
                      "Practice Time",
                      "${progress['practiceTime']} min",
                      Icons.access_time,
                      const Color(0xFFF44336),
                    ),
                    _buildStatCard(
                      "Accuracy",
                      "${progress['accuracy']}%",
                      Icons.trending_up,
                      const Color(0xFFFF9800),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              // ==== Learning Categories ====
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  "Learning Categories",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 15),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    _buildCategoryCard(
                      context,
                      "Alphabet & Numbers",
                      "Learn basic signs for letters and numbers",
                      Icons.format_list_numbered,
                      const Color(0xFF9C27B0),
                      "12/36 completed",
                    ),
                    _buildCategoryCard(
                      context,
                      "Common Words",
                      "Everyday vocabulary and phrases",
                      Icons.chat_bubble,
                      const Color(0xFF00BCD4),
                      "45/120 learned",
                    ),
                    _buildCategoryCard(
                      context,
                      "Family & Friends",
                      "Signs for people and relationships",
                      Icons.family_restroom,
                      const Color(0xFF4CAF50),
                      "8/25 mastered",
                    ),
                    _buildCategoryCard(
                      context,
                      "Emotions & Feelings",
                      "Express emotions through signs",
                      Icons.sentiment_satisfied,
                      const Color(0xFFF44336),
                      "15/30 learned",
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              // ==== Practice Tools ====
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  "Practice Tools",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 15),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    _buildToolCard(
                      context,
                      "Camera Practice",
                      "Use camera to practice signs",
                      Icons.camera_alt,
                      Colors.indigo,
                    ),
                    _buildToolCard(
                      context,
                      "Quiz Mode",
                      "Test your sign language knowledge",
                      Icons.quiz,
                      Colors.orange,
                    ),
                    _buildToolCard(
                      context,
                      "Video Lessons",
                      "Watch expert demonstrations",
                      Icons.play_circle_filled,
                      Colors.red,
                    ),
                    _buildToolCard(
                      context,
                      "Dictionary",
                      "Browse sign language dictionary",
                      Icons.menu_book,
                      const Color(0xFF795548),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              // ==== Recent Activity ====
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Recent Activity",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 15),
                        _buildActivityItem(
                          "Completed Alphabet Quiz",
                          "2 hours ago",
                          Icons.quiz,
                          Colors.green,
                        ),
                        _buildActivityItem(
                          "Practiced Family Signs",
                          "Yesterday",
                          Icons.family_restroom,
                          Colors.blue,
                        ),
                        _buildActivityItem(
                          "Watched 'Greetings' Video",
                          "2 days ago",
                          Icons.play_arrow,
                          Colors.red,
                        ),
                        _buildActivityItem(
                          "Learned 5 New Words",
                          "3 days ago",
                          Icons.star,
                          Colors.amber,
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 25),

              // ==== Daily Goal Progress ====
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Daily Goal",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "15/20 min",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),
                        LinearProgressIndicator(
                          value: 0.75,
                          backgroundColor: Colors.grey[200],
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            Color(0xFF00BCD4),
                          ),
                          minHeight: 8,
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          "You're almost there! 5 more minutes to reach your daily goal.",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 80),
            ],
          ),
        ),
      ),

      // ==== Floating Action Button ====
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _showQuickPracticeDialog(context);
        },
        backgroundColor: const Color(0xFF00BCD4),
        icon: const Icon(Icons.waving_hand, color: Colors.white),
        label: const Text(
          "Quick Practice",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  // ==== Stat Card Widget ====
  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 30, color: color),
            const SizedBox(height: 10),
            Text(
              value,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  // ==== Category Card Widget ====
  Widget _buildCategoryCard(
      BuildContext context,
      String title,
      String description,
      IconData icon,
      Color color,
      String progress,
      ) {
    return InkWell(
      onTap: () {
        _navigateToCategory(context, title);
      },
      child: Card(
        margin: const EdgeInsets.only(bottom: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 5,
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              CircleAvatar(
                radius: 25,
                backgroundColor: color,
                child: Icon(icon, color: Colors.white, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      progress,
                      style: TextStyle(
                        color: color,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios, color: Colors.grey[400], size: 16),
            ],
          ),
        ),
      ),
    );
  }

  // ==== Tool Card Widget ====
  Widget _buildToolCard(
      BuildContext context,
      String title,
      String description,
      IconData icon,
      Color color,
      ) {
    return InkWell(
      onTap: () {
        _navigateToTool(context, title);
      },
      child: Card(
        margin: const EdgeInsets.only(bottom: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 3,
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          leading: CircleAvatar(
            backgroundColor: color.withOpacity(0.1),
            child: Icon(icon, color: color, size: 24),
          ),
          title: Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          subtitle: Text(
            description,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
          trailing: Icon(Icons.arrow_forward_ios, color: Colors.grey[400], size: 16),
        ),
      ),
    );
  }

  // ==== Activity Item Widget ====
  Widget _buildActivityItem(String title, String time, IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: color.withOpacity(0.1),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
                Text(
                  time,
                  style: TextStyle(
                    color: Colors.grey[500],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==== Navigation Functions ====
  void _navigateToCategory(BuildContext context, String category) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Opening $category...'),
        backgroundColor: const Color(0xFF00BCD4),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _navigateToTool(BuildContext context, String tool) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Opening $tool...'),
        backgroundColor: const Color(0xFF00BCD4),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  // ==== Quick Practice Dialog ====
  void _showQuickPracticeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Row(
            children: [
              Icon(Icons.waving_hand, color: Color(0xFF00BCD4)),
              SizedBox(width: 8),
              Text("Quick Practice"),
            ],
          ),
          content: const Text(
            "Choose a quick practice session to improve your sign language skills!",
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Starting quick practice session...'),
                    backgroundColor: Color(0xFF00BCD4),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00BCD4),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text("Start Practice"),
            ),
          ],
        );
      },
    );
  }
}