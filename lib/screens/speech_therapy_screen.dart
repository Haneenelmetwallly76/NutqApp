import 'dart:io';
import 'dart:convert';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:record/record.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

import '../widgets/header_widget.dart';
import '../widgets/weekly_progress_widget.dart';
import '../widgets/current_exercise_widget.dart';
import '../widgets/available_exercises_widget.dart';

class SpeechTherapyScreen extends StatefulWidget {
  const SpeechTherapyScreen({super.key});

  @override
  _SpeechTherapyScreenState createState() => _SpeechTherapyScreenState();
}

class _SpeechTherapyScreenState extends State<SpeechTherapyScreen> with SingleTickerProviderStateMixin {
  final record = AudioRecorder();
  bool isRecording = false;
  File? recordedFile;
  String? transcribedText;
  String _recognizedWords = '';
  String _status = 'idle';
  String _log = '';
  bool _onDeviceListening = false;

  static const MethodChannel _methodChannel = MethodChannel('com.example.new_notq_app/speech_methods');
  static const EventChannel _eventChannel = EventChannel('com.example.new_notq_app/speech_events');
  StreamSubscription? _eventSub;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  // Weekly progress data
  List<bool> weeklyProgress = [true, true, true, true, false, false, false];
  List<String> weekDays = ['الاثنين', 'الثلاثاء', 'الأربعاء', 'الخميس', 'الجمعة', 'السبت', 'الأحد'];

  @override
  void initState() {
    super.initState();
    _initSpeech();
    _pulseController = AnimationController(vsync: this, duration: const Duration(milliseconds: 700));
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.15).animate(CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut));
  }

  Future<void> _initSpeech() async {
    try {
      final res = await _methodChannel.invokeMethod('initialize');
      if (res == true) {
        _eventSub = _eventChannel.receiveBroadcastStream().listen((dynamic event) {
          try {
            final Map<dynamic, dynamic> map = event as Map<dynamic, dynamic>;
            final type = map['type'] as String? ?? '';
            if (type == 'partial') {
              setState(() {
                _recognizedWords = map['text'] as String? ?? '';
              });
            } else if (type == 'final') {
              final text = map['text'] as String? ?? '';
              setState(() {
                _recognizedWords = text;
                transcribedText = text;
                _status = 'final';
              });
            } else if (type == 'status') {
              setState(() {
                _status = map['status'] as String? ?? _status;
              });
            } else if (type == 'error') {
              setState(() {
                _log = '${map['error'] ?? 'error'}: ${map['message'] ?? ''}';
                _status = 'error';
              });
            }
          } catch (e) {
            setState(() {
              _log = 'event_parse_error: ${e.toString()}';
            });
          }
        }, onError: (e) {
          setState(() {
            _log = 'event_channel_error: ${e.toString()}';
          });
        });
      }
    } catch (e) {
      setState(() {
        _log = 'init_error: ${e.toString()}';
      });
    }
  }

  
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
        const SnackBar(content: Text('مطلوب إذن استخدام الميكروفون')),
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
    final apiKey = dotenv.env['WHISPER_API_KEY'];

    if (apiKey == null || apiKey.isEmpty) {
      if (!mounted) return;
      setState(() {
        transcribedText = '❌ Missing Whisper API key. Add WHISPER_API_KEY to .env';
      });
      return;
    }

    final url = Uri.parse("https://api.openai.com/v1/audio/transcriptions");

    final request = http.MultipartRequest("POST", url)
      ..headers["Authorization"] = "Bearer $apiKey"
      ..files.add(await http.MultipartFile.fromPath("file", audioFile.path))
      ..fields["model"] = "whisper-1"
      ..fields["language"] = "ar";

    final response = await request.send();
    final body = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      final text = jsonDecode(body)["text"] as String? ?? '';
      if (!mounted) return;
      setState(() {
        transcribedText = text;
      });
    } else {
      debugPrint("Error: ${response.statusCode}, $body");
      if (!mounted) return;
      setState(() {
        transcribedText = "❌ خطأ: لم يتم تحويل التسجيل إلى نص.";
      });
    }
  }

  @override
  void dispose() {
    _eventSub?.cancel();
    _pulseController.dispose();
    record.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                const HeaderWidget(),

              const SizedBox(height: 20),

              // Speech Recognition Widget
                // Transcription display (from Whisper)
                if (transcribedText != null)
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                      color: Colors.green.withValues(alpha: 0.06),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.green,
                        width: 1,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                                const Row(
                                  children: [
                                    Icon(Icons.check_circle, color: Colors.green),
                                    SizedBox(width: 8),
                                    Text(
                                      'النص المكتوب',
                                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.green),
                                    ),
                                  ],
                                ),
                        const SizedBox(height: 8),
                          Text(
                            transcribedText ?? '',
                            style: const TextStyle(fontSize: 22, color: Colors.black87, fontWeight: FontWeight.w600),
                            textAlign: TextAlign.right,
                          ),
                          const SizedBox(height: 12),
                          // On-device quick status and log
                          if (_recognizedWords.isNotEmpty)
                            Text(
                                'جزئيًا: $_recognizedWords',
                                style: const TextStyle(fontSize: 16, color: Colors.black54),
                              ),
                          const SizedBox(height: 6),
                          Text('الحالة: $_status', style: const TextStyle(fontSize: 12, color: Colors.black45)),
                          const SizedBox(height: 6),
                          if (_log.isNotEmpty)
                            Text('سجل: $_log', style: const TextStyle(fontSize: 12, color: Colors.redAccent)),
                      ],
                    ),
                  ),

              const SizedBox(height: 20),

              // This Week's Progress
              WeeklyProgressWidget(
                weeklyProgress: weeklyProgress,
                weekDays: weekDays,
              ),

              const SizedBox(height: 25),

              // On-device STT controls
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    ElevatedButton.icon(
                      onPressed: () async {
                        // Toggle on-device listening
                        if (_onDeviceListening) {
                          try {
                            await _methodChannel.invokeMethod('stopListening');
                            setState(() {
                              _onDeviceListening = false;
                              _status = 'stopped';
                            });
                            try {
                              _pulseController.stop();
                              _pulseController.reset();
                            } catch (_) {}
                          } catch (e) {
                            setState(() {
                              _log = 'stop_error: ${e.toString()}';
                            });
                          }
                        } else {
                          try {
                            setState(() {
                              _log = '';
                            });
                            await _methodChannel.invokeMethod('startListening', {
                              'locale': 'ar-EG',
                              'listenFor': 30,
                              'pauseFor': 3,
                              'onDevice': true,
                            });
                            setState(() {
                              _onDeviceListening = true;
                              _status = 'listening';
                            });
                            _pulseController.repeat(reverse: true);
                          } catch (e) {
                            setState(() {
                              _log = 'start_error: ${e.toString()}';
                              _status = 'error';
                            });
                          }
                        }
                      },
                      icon: ScaleTransition(
                        scale: _pulseAnimation,
                        child: Icon(_onDeviceListening ? Icons.mic : Icons.mic_none, color: Colors.white),
                      ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _onDeviceListening ? Colors.redAccent : Colors.blueAccent,
                        ),
                        label: Text(_onDeviceListening ? 'جاري الاستماع... 🔴' : 'اضغط للتحدث 🎙️'),
                    ),
                    const SizedBox(width: 12),
                    if (_onDeviceListening)
                      const Text('جاري الاستماع على الجهاز', style: TextStyle(color: Colors.green)),
                  ],
                ),
              ),

              // Current Exercise
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'الجلسة الحالية',
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
                  'التمارين المتاحة',
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
          if (isRecording) {
            stopRecording();
          } else {
            startRecording();
          }
        },
        backgroundColor: isRecording ? Colors.redAccent : Colors.pinkAccent,
        icon: Icon(
          isRecording ? Icons.mic : Icons.mic_none,
          color: Colors.white,
        ),
        label: Text(
          isRecording ? 'جاري التسجيل... 🔴' : 'تدريب سريع',
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      )),
    );
  }
}
