Gesture Recognizer Server (MediaPipe + WebSocket)
===============================================

Overview
--------
This script runs a MediaPipe-based hand gesture recognizer and broadcasts recognized
labels and confidences over a WebSocket server so other apps (e.g., your Flutter app)
can consume live predictions.

Files
-----
- `tools/gesture_recognizer_ws.py`  — The main Python server script
- `tools/requirements.txt`         — Python dependencies

Install
-------
Create a virtual environment (recommended) and install requirements:

```bash
python -m venv .venv
source .venv/bin/activate
pip install -r tools/requirements.txt
```

Run
---
Start the server (opens camera 0):

```bash
python tools/gesture_recognizer_ws.py
```

You should see a local OpenCV window named "Gesture Server" and a WebSocket server listening
on `ws://0.0.0.0:8765`.

Connect from Flutter
--------------------
Use a WebSocket client (e.g., `web_socket_channel` package) and connect to the server.
Replace `<PC_IP>` with your machine's IP reachable by the phone/emulator.

Dart example:

```dart
import 'package:web_socket_channel/io.dart';
import 'dart:convert';

final channel = IOWebSocketChannel.connect('ws://<PC_IP>:8765');

channel.stream.listen((msg) {
  final data = json.decode(msg);
  print('Label: ${data['label']} - Confidence: ${data['confidence']}');
});
```

Notes
-----
- Mobile device and PC must be on the same network for the device to connect to the server's IP.
- The script broadcasts recognized labels as JSON messages: `{"label": "اهلا", "confidence": 0.92}`.
- Press `q` in the OpenCV window to stop the camera loop.

Next steps
----------
- Integrate a WebSocket client in the Flutter app to receive and display labels in `sign_language_screen.dart`.
- Optionally, convert this recognition logic into a TFLite model for on-device inference.
