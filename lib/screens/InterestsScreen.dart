import 'package:flutter/material.dart';

class InterestsScreen extends StatefulWidget {
  const InterestsScreen({super.key});

  @override
  State<InterestsScreen> createState() => _InterestsScreenState();
}

class _InterestsScreenState extends State<InterestsScreen> {
  final List<Map<String, String>> interests = [
    {'id': 'animals', 'label': 'Animals', 'icon': '🐼'},
    {'id': 'colors', 'label': 'Colors', 'icon': '🌈'},
    {'id': 'numbers', 'label': 'Numbers', 'icon': '🔢'},
    {'id': 'letters', 'label': 'Letters', 'icon': '📝'},
    {'id': 'music', 'label': 'Music', 'icon': '🎵'},
    {'id': 'stories', 'label': 'Stories', 'icon': '📚'},
  ];

  final Set<String> selectedInterests = {};

  void toggleSelection(String id) {
    setState(() {
      if (selectedInterests.contains(id)) {
        selectedInterests.remove(id);
      } else {
        selectedInterests.add(id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Card(
          margin: const EdgeInsets.all(24),
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          elevation: 8,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "What do you love learning about?",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                const Text(
                  "Pick your favorite topics",
                  style: TextStyle(fontSize: 16, color: Colors.black54),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),

                // Options Grid
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 1.2,
                  physics: const NeverScrollableScrollPhysics(),
                  children: interests.map((interest) {
                    final isSelected =
                    selectedInterests.contains(interest['id']);
                    return GestureDetector(
                      onTap: () => toggleSelection(interest['id']!),
                      child: Card(
                        color: isSelected
                            ? Colors.blue.shade100
                            : Colors.grey.shade200,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                interest['icon']!,
                                style: const TextStyle(fontSize: 28),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                interest['label']!,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: isSelected
                                      ? Colors.blue
                                      : Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),

                const SizedBox(height: 20),

                // Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text("Back"),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        debugPrint("Selected: $selectedInterests");
                      },
                      child: const Text("Let's Learn! 🎉"),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
