
import 'package:flutter/material.dart';
import '../widgets/emoji_button.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tiles = [
      ("🗣️", "Speech", "/exercise"),
      ("🤟", "Sign", "/sign_language"),
      ("📈", "Progress", "/progress"),
      ("📊", "Reports", "/reports"),
      ("💬", "Feedback", "/feedback"),
    ];
    return Scaffold(
      appBar: AppBar(title: const Text("Dashboard")),
      bottomNavigationBar: NavigationBar(
        selectedIndex: 0,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), label: "Home"),
          NavigationDestination(icon: Icon(Icons.school_outlined), label: "Learn"),
          NavigationDestination(icon: Icon(Icons.person_outline), label: "Profile"),
        ],
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, mainAxisSpacing: 12, crossAxisSpacing: 12, childAspectRatio: 1.1
        ),
        itemCount: tiles.length,
        itemBuilder: (context, i) {
          final t = tiles[i];
          return Card(
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () => Navigator.pushNamed(context, t.$3),
              child: Center(child: EmojiButton(emoji: t.$1, label: t.$2)),
            ),
          );
        },
      ),
    );
  }
}
