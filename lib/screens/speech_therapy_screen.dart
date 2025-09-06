import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:record/record.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

import '../widgets/header_widget.dart';
import '../widgets/weekly_progress_widget.dart';
import '../widgets/current_exercise_widget.dart';
import '../widgets/available_exercises_widget.dart';
import '../widgets/exercise_card_widget.dart';

class SpeechTherapyScreen extends StatefulWidget {
  const SpeechTherapyScreen({super.key});

  @override
  _SpeechTherapyScreenState createState() => _SpeechTherapyScreenState();
}

class _SpeechTherapyScreenState extends State<SpeechTherapyScreen> {
  final record = AudioRecorder();
  bool isRecording = false;
  File? recordedFile;
  String? transcribedText;

  // Weekly progress data
  List<bool> weeklyProgress = [true, true, true, true, false, false, false];
  List<String> weekDays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

  Future<void> startRecording() async {
    if (await record.hasPermission()) {
      final dir = await getTemporaryDirectory();
      final path = '${dir.path}/speech_practice.m4a';

      await record.start(
        const RecordConfig(
          encoder: AudioEncoder.aacLc,
          bitRate: 128000,
          sampleRate: 44100,
        ),
        path: path,
      );

      setState(() {
        isRecording = true;
        transcribedText = null;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Microphone permission is required')),
      );
    }
  }

  Future<void> stopRecording() async {
    final path = await record.stop();
    if (path != null) {
      setState(() {
        isRecording = false;
        recordedFile = File(path);
      });
      await sendToWhisper(recordedFile!);
    } else {
      setState(() {
        isRecording = false;
      });
    }
  }

  Future<void> sendToWhisper(File audioFile) async {
    const apiKey = "YOUR_OPENAI_API_KEY";
    final url = Uri.parse("https://api.openai.com/v1/audio/transcriptions");

    final request = http.MultipartRequest("POST", url)
      ..headers["Authorization"] = "Bearer $apiKey"
      ..files.add(await http.MultipartFile.fromPath("file", audioFile.path))
      ..fields["model"] = "whisper-1"
      ..fields["language"] = "en";

    final response = await request.send();
    final body = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      final text = jsonDecode(body)["text"];
      setState(() {
        transcribedText = text;
      });
    } else {
      print("Error: ${response.statusCode}, $body");
      setState(() {
        transcribedText = "❌ Error: could not transcribe.";
      });
    }
  }

  @override
  void dispose() {
    record.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              const HeaderWidget(),

              const SizedBox(height: 20),

              // This Week's Progress
              WeeklyProgressWidget(
                weeklyProgress: weeklyProgress,
                weekDays: weekDays,
              ),

              const SizedBox(height: 25),

              // Current Exercise
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'Current Exercise',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(height: 15),
              CurrentExerciseWidget(
                isRecording: isRecording,
                transcribedText: transcribedText,
                onRecordPressed: () {
                  if (isRecording) {
                    stopRecording();
                  } else {
                    startRecording();
                  }
                },
              ),

              const SizedBox(height: 25),

              // Available Exercises
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'Available Exercises',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(height: 15),
              const AvailableExercisesWidget(),

              const SizedBox(height: 80),
            ],
          ),
        ),
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _showQuickPracticeDialog(context);
        },
        backgroundColor: Colors.pinkAccent,
        icon: const Icon(Icons.mic, color: Colors.white),
        label: const Text(
          "Quick Practice",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

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
              Icon(Icons.mic, color: Colors.pinkAccent),
              SizedBox(width: 8),
              Text("Quick Practice"),
            ],
          ),
          content: const Text(
            "Choose a quick practice session to improve your speech!",
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
                    backgroundColor: Colors.pinkAccent,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pinkAccent,
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
