import 'package:flutter/material.dart';

class ExerciseScreen extends StatelessWidget {
  const ExerciseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as String? ?? "Exercise";

    return Scaffold(
      appBar: AppBar(
        title: Text(args),
      ),
      body: Center(
        child: Text(
          "Exercise screen for $args",
          style: const TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
