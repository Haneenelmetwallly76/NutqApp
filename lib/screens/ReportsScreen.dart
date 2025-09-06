import 'package:flutter/material.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // ✅ Banner بالـ Gradient (موف + سهم رجوع)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 40, left: 20, right: 20, bottom: 20),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF8E24AA), Color(0xFFBA68C8)], // تدرج موف
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Row(
              children: [
                // سهم رجوع
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                const Spacer(),
                const Text(
                  "Your Reports Overview",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(flex: 2), // علشان الكلام يبقى في النص تقريبًا
              ],
            ),
          ),

          // ✅ باقي المحتوى
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                children: [
                  _buildReportCard(
                    title: "Daily Learning",
                    subtitle: "Completed 5 lessons this week",
                    icon: Icons.book,
                    color: Colors.purple.shade100,
                  ),
                  _buildReportCard(
                    title: "Exercises",
                    subtitle: "Solved 12 practice questions",
                    icon: Icons.fitness_center,
                    color: Colors.blue.shade100,
                  ),
                  _buildReportCard(
                    title: "Games",
                    subtitle: "Played 8 educational games",
                    icon: Icons.videogame_asset,
                    color: Colors.green.shade100,
                  ),
                  _buildReportCard(
                    title: "Sign Language",
                    subtitle: "Learned 3 new signs",
                    icon: Icons.gesture,
                    color: Colors.orange.shade100,
                  ),
                  _buildReportCard(
                    title: "AI Help",
                    subtitle: "Asked 4 questions",
                    icon: Icons.smart_toy,
                    color: Colors.pink.shade100,
                  ),
                  _buildReportCard(
                    title: "Feedback",
                    subtitle: "Shared 2 feedbacks with parents",
                    icon: Icons.feedback,
                    color: Colors.teal.shade100,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 🔹 كروت التقارير
  Widget _buildReportCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color,
          child: Icon(icon, color: Colors.black87),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios, size: 18),
        onTap: () {
          // 👈 هنا ممكن يفتح تفاصيل أكتر لكل تقرير
        },
      ),
    );
  }
}
