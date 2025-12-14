import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CameraPracticeScreen extends ConsumerStatefulWidget {
  final String token;
  const CameraPracticeScreen({super.key, required this.token});

  @override
  _CameraPracticeScreenState createState() => _CameraPracticeScreenState();
}

class _CameraPracticeScreenState extends ConsumerState<CameraPracticeScreen> {
  CameraController? _controller;
  bool _isLoading = false;
  String? _recognizedLetter;

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    final cameras = await availableCameras();
    final firstCamera = cameras.first;

    _controller = CameraController(firstCamera, ResolutionPreset.medium);
    await _controller!.initialize();
    if (mounted) setState(() {});
  }

  Future<void> _captureAndSend() async {
    if (_controller == null || !_controller!.value.isInitialized) return;

    final picture = await _controller!.takePicture();
    setState(() => _isLoading = true);

    final url = Uri.parse("https://nutq.runasp.net/api/SignLanguage/SignLanguage");

    final request = http.MultipartRequest("GET", url)
      ..headers["Authorization"] = "Bearer ${widget.token}";

    // ⚠️ لو الـ API محتاج صورة، نخليها POST ونرفع الملف:
    // request.files.add(await http.MultipartFile.fromPath("image", picture.path));

    final response = await request.send();
    final body = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      final data = jsonDecode(body);
      setState(() {
        _recognizedLetter = data["result"]["letter"];
      });
    } else {
      setState(() {
        _recognizedLetter = "❌ Error ${response.statusCode}";
      });
    }

    setState(() => _isLoading = false);
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null || !_controller!.value.isInitialized) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Camera Practice")),
      body: Column(
        children: [
          Expanded(
            child: CameraPreview(_controller!),
          ),
          if (_recognizedLetter != null)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "Detected Sign: $_recognizedLetter",
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          if (_isLoading) const CircularProgressIndicator(),
          ElevatedButton.icon(
            onPressed: _captureAndSend,
            icon: const Icon(Icons.camera),
            label: const Text("Capture Sign"),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
