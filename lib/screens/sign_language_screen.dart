import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:web_socket_channel/io.dart';

class SignLanguageScreen extends StatefulWidget {
  const SignLanguageScreen({super.key});

  @override
  State<SignLanguageScreen> createState() => _SignLanguageScreenState();
}

class _SignLanguageScreenState extends State<SignLanguageScreen>
    with WidgetsBindingObserver {
  // Camera
  late CameraController _cameraController;
  late List<CameraDescription> _cameras;
  bool _isCameraInitialized = false;

  // WebSocket
  IOWebSocketChannel? _channel;
  bool _isConnected = false;
  String _wsServerAddress = '192.168.1.X:8765'; // Change to your PC IP

  // Detection Results
  String _detectedSign = 'جاري المسح...';
  double _confidence = 0.0;
  String _debugLog = 'Initializing camera...';

  // Stream subscription
  StreamSubscription? _wsSubscription;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeAsync();
  }

  Future<void> _initializeAsync() async {
    try {
      await _initializeCamera();
      _updateDebugLog('Camera initialized. Tap "Connect" to connect to gesture server.');
    } catch (e) {
      _updateDebugLog('Initialization error: $e');
    }
  }

  Future<void> _initializeCamera() async {
    try {
      final cameraPermission = await Permission.camera.request();
      if (!cameraPermission.isGranted) {
        _updateDebugLog('Camera permission denied');
        return;
      }

      _cameras = await availableCameras();
      if (_cameras.isEmpty) {
        _updateDebugLog('No cameras found');
        return;
      }

      // Prefer front camera
      final frontCamera = _cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.front,
        orElse: () => _cameras.first,
      );

      debugPrint('[SignLanguage] Found camera: ${frontCamera.name}');
      _updateDebugLog('Camera found: ${frontCamera.name}');

      _cameraController = CameraController(
        frontCamera,
        ResolutionPreset.high,
        enableAudio: false,
      );

      await _cameraController.initialize();
      _isCameraInitialized = true;
      debugPrint('[SignLanguage] Camera initialized');

      if (mounted) {
        setState(() {});
      }
    } catch (e) {
      debugPrint('[SignLanguage] Camera initialization error: $e');
      _updateDebugLog('Camera error: $e');
    }
  }

  void _connectToWebSocket(String serverAddress) {
    if (_isConnected) {
      _disconnectWebSocket();
      return;
    }

    try {
      _updateDebugLog('Connecting to ws://$serverAddress...');
      
      _channel = IOWebSocketChannel.connect(
        Uri.parse('ws://$serverAddress'),
        pingInterval: const Duration(seconds: 10),
      );

      _wsSubscription = _channel!.stream.listen(
        (message) {
          debugPrint('[SignLanguage] Received: $message');
          _onWebSocketMessage(message);
        },
        onError: (error) {
          debugPrint('[SignLanguage] WebSocket error: $error');
          _updateDebugLog('Connection error: $error');
          _isConnected = false;
          if (mounted) {
            setState(() {});
          }
        },
        onDone: () {
          debugPrint('[SignLanguage] WebSocket closed');
          _updateDebugLog('Connection closed');
          _isConnected = false;
          if (mounted) {
            setState(() {});
          }
        },
      );

      _isConnected = true;
      _updateDebugLog('Connected! Listening for gestures...');
      debugPrint('[SignLanguage] Connected to gesture server at ws://$serverAddress');

      if (mounted) {
        setState(() {
          _wsServerAddress = serverAddress;
        });
      }
    } catch (e) {
      debugPrint('[SignLanguage] Connection error: $e');
      _updateDebugLog('Failed to connect: $e');
    }
  }

  void _disconnectWebSocket() {
    try {
      _wsSubscription?.cancel();
      _channel?.sink.close();
      _isConnected = false;
      _updateDebugLog('Disconnected from gesture server');
      debugPrint('[SignLanguage] Disconnected');

      if (mounted) {
        setState(() {});
      }
    } catch (e) {
      debugPrint('[SignLanguage] Disconnect error: $e');
    }
  }

  void _onWebSocketMessage(dynamic message) {
    try {
      final data = jsonDecode(message.toString());
      final label = data['label'] as String? ?? 'Unknown';
      final confidence = (data['confidence'] as num?)?.toDouble() ?? 0.0;

      debugPrint('[SignLanguage] Label: $label, Confidence: $confidence');

      if (mounted) {
        setState(() {
          _detectedSign = label;
          _confidence = confidence;
        });
      }
    } catch (e) {
      debugPrint('[SignLanguage] Parse error: $e');
    }
  }

  void _updateDebugLog(String message) {
    if (mounted) {
      setState(() {
        _debugLog = message;
      });
    }
    debugPrint('[SignLanguage] $message');
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (!_isCameraInitialized) return;

    if (state == AppLifecycleState.paused) {
      _disconnectWebSocket();
    } else if (state == AppLifecycleState.resumed) {
      if (_isConnected) {
        _connectToWebSocket(_wsServerAddress);
      }
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _disconnectWebSocket();
    _cameraController.dispose();
    super.dispose();
  }

  void _showServerAddressDialog() {
    final controller = TextEditingController(text: _wsServerAddress);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Gesture Server Address', textDirection: TextDirection.rtl),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: '192.168.1.X:8765',
            labelText: 'ws://server:port',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _connectToWebSocket(controller.text);
            },
            child: const Text('Connect'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ترجمة لغة الإشارة'),
        backgroundColor: Colors.blue[700],
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Camera Preview
            if (_isCameraInitialized)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.4,
                    color: Colors.black,
                    child: Stack(
                      children: [
                        CameraPreview(_cameraController),
                        // Connection status indicator
                        Positioned(
                          top: 12,
                          right: 12,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: _isConnected ? Colors.green : Colors.red,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              _isConnected ? '🟢 Connected' : '🔴 Disconnected',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            else
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              ),
            const SizedBox(height: 24),
            // Detected Word
            Center(
              child: Column(
                children: [
                  Text(
                    _detectedSign,
                    textDirection: TextDirection.rtl,
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[700],
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Confidence Progress
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: _confidence.clamp(0.0, 1.0),
                        minHeight: 8,
                        backgroundColor: Colors.grey[300],
                        valueColor: AlwaysStoppedAnimation<Color>(
                          _confidence > 0.7
                              ? Colors.green
                              : _confidence > 0.5
                                  ? Colors.orange
                                  : Colors.red,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${(_confidence * 100).toStringAsFixed(1)}%',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Connection Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: ElevatedButton.icon(
                onPressed: _showServerAddressDialog,
                icon: Icon(_isConnected ? Icons.cloud_off : Icons.cloud),
                label: Text(
                  _isConnected
                      ? 'قطع الاتصال (Disconnect)'
                      : 'الاتصال بالخادم (Connect)',
                  textDirection: TextDirection.rtl,
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isConnected ? Colors.red : Colors.green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Debug Log
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  border: Border.all(color: Colors.grey[400]!),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Debug Log:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _debugLog,
                      style: const TextStyle(
                        fontSize: 11,
                        color: Colors.grey,
                        fontFamily: 'Courier',
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Server IP: Change "192.168.1.X" to your PC IP.',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.blueAccent,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
