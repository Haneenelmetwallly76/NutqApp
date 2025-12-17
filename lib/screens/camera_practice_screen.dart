import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CameraPracticeScreen extends ConsumerStatefulWidget {
  final String token;
  const CameraPracticeScreen({super.key, required this.token});

  @override
  _CameraPracticeScreenState createState() => _CameraPracticeScreenState();
}

class _CameraPracticeScreenState extends ConsumerState<CameraPracticeScreen> {
  bool _isLoading = false;
  String? _recognizedLetter;

  Future<void> _sendRequest() async {
    setState(() => _isLoading = true);

    try {
      final url = Uri.parse("https://nutq.runasp.net/api/SignLanguage/SignLanguage");

      final request = http.MultipartRequest("POST", url)
        ..headers["Authorization"] = "Bearer ${widget.token}";

      // Add image file if available:
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
    } catch (e) {
      setState(() {
        _recognizedLetter = "❌ Error: $e";
      });
    }

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Camera Practice")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.camera_alt, size: 80, color: Colors.grey),
          const SizedBox(height: 20),
          const Text(
            "Camera Practice",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 30),
          if (_recognizedLetter != null)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "Detected Sign: $_recognizedLetter",
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          if (_isLoading) 
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: CircularProgressIndicator(),
            ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: _isLoading ? null : _sendRequest,
            icon: const Icon(Icons.camera),
            label: const Text("Capture Sign"),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
