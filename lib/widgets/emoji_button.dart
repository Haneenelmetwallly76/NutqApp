
import 'package:flutter/material.dart';

class EmojiButton extends StatelessWidget {
  final String emoji;
  final String label;
  final VoidCallback? onPressed;
  final bool outlined;
  const EmojiButton({super.key, required this.emoji, required this.label, this.onPressed, this.outlined=false});

  @override
  Widget build(BuildContext context) {
    final child = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(emoji, style: const TextStyle(fontSize: 24)),
        const SizedBox(height: 6),
        Text(label, style: Theme.of(context).textTheme.labelSmall),
      ],
    );
    return SizedBox(
      height: 64,
      child: outlined
          ? OutlinedButton(onPressed: onPressed, child: child)
          : ElevatedButton(onPressed: onPressed, child: child),
    );
  }
}
