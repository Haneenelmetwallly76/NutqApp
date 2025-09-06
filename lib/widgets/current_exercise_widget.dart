import 'package:flutter/material.dart';

class CurrentExerciseWidget extends StatelessWidget {
  final bool isRecording;
  final String? transcribedText;
  final VoidCallback onRecordPressed;

  const CurrentExerciseWidget({
    super.key,
    required this.isRecording,
    required this.transcribedText,
    required this.onRecordPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 4,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const Text(
                'Letter "R" Sounds',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Practice saying words with the "R" sound',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 24),
              GestureDetector(
                onTap: onRecordPressed,
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isRecording ? Colors.red : Colors.pinkAccent,
                    boxShadow: [
                      BoxShadow(
                        color: (isRecording ? Colors.red : Colors.pinkAccent).withOpacity(0.3),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Icon(
                    isRecording ? Icons.stop : Icons.mic,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                isRecording ? 'Recording...' : 'Tap to start recording',
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
              if (transcribedText != null) ...[
                const SizedBox(height: 20),
                const Text(
                  "Recognized Text:",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  transcribedText!,
                  style: const TextStyle(fontSize: 15, color: Colors.black87),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
