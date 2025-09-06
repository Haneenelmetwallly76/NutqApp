import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final exerciseProvider = StateProvider<String>((ref) => "Exercise");

class ExerciseScreen extends ConsumerWidget {
  const ExerciseScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final exerciseName = ref.watch(exerciseProvider);

    final args = ModalRoute.of(context)!.settings.arguments as String?;
    if (args != null && args.isNotEmpty && args != exerciseName) {
      ref.read(exerciseProvider.notifier).state = args;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(exerciseName),
      ),
      body: Center(
        child: Text(
          "Exercise screen for $exerciseName",
          style: const TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
