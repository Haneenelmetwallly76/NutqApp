"""
Real-time Gesture Recognizer using MediaPipe + OpenCV
Broadcasts recognized label and confidence over WebSocket to connected clients.

Run:
  pip install -r requirements.txt
  python tools/gesture_recognizer_ws.py

Connect from Flutter (example):
  import 'package:web_socket_channel/io.dart';
  final channel = IOWebSocketChannel.connect('ws://<PC_IP>:8765');
  channel.stream.listen((msg) { /* parse JSON */ });

The script uses a background thread for OpenCV capture and an asyncio websocket server
that broadcasts messages in JSON: {"label": "اهلا", "confidence": 0.92}
"""

import asyncio
import json
import threading
import math
import os
from typing import List

import websockets

# Optional imports (MediaPipe/OpenCV). If they're not available we fall back
# to a simulated mode so the server can run for client testing.
try:
    import cv2
except Exception:
    cv2 = None

try:
    import mediapipe as mp
    # Some broken/partial installs expose a mediapipe module without the
    # expected 'solutions' submodule. Verify presence before enabling MP mode.
    if hasattr(mp, 'solutions'):
        HAS_MEDIAPIPE = True
    else:
        print('mediapipe imported but has no attribute solutions — falling back to simulation')
        mp = None
        HAS_MEDIAPIPE = False
except Exception:
    mp = None
    HAS_MEDIAPIPE = False

# --- Configuration ---
WEBSOCKET_HOST = '0.0.0.0'
WEBSOCKET_PORT = 8765
MAX_CLIENTS = 10
HEADLESS = os.environ.get('HEADLESS', '0').lower() in ('1', 'true', 'yes')

# MediaPipe setup
if HAS_MEDIAPIPE:
    mp_hands = mp.solutions.hands
    mp_drawing = mp.solutions.drawing_utils

    hands = mp_hands.Hands(
        static_image_mode=False,
        max_num_hands=1,
        min_detection_confidence=0.7,
        min_tracking_confidence=0.5,
    )
else:
    hands = None

# Queue for messages to broadcast
_broadcast_queue: asyncio.Queue = asyncio.Queue()
_clients = set()


def calculate_distance(p1, p2):
    return math.sqrt((p1[0] - p2[0]) ** 2 + (p1[1] - p2[1]) ** 2)


def get_fingers_status(lm_list: List[List[int]]):
    fingers = []

    # Thumb Logic (simple orientation-based)
    # thumb: tip id 4, id 3 is lower joint
    if lm_list[4][1] < lm_list[3][1]:
        fingers.append(1)
    else:
        fingers.append(0)

    # Other fingers: tip ids [8,12,16,20]
    finger_tips = [8, 12, 16, 20]
    for tip in finger_tips:
        if lm_list[tip][2] < lm_list[tip - 2][2]:
            fingers.append(1)
        else:
            fingers.append(0)
    return fingers


def recognize_from_landmarks(lm_list: List[List[int]]):
    # Default
    message = "Show Gesture..."
    box_color = (200, 200, 200)
    confidence = 0.0

    if not lm_list:
        return message, confidence

    fingers = get_fingers_status(lm_list)

    # Distances needed for complex gestures
    dist_index_thumb = calculate_distance(lm_list[8][1:], lm_list[4][1:])
    dist_index_middle = calculate_distance(lm_list[8][1:], lm_list[12][1:])
    dist_middle_ring = calculate_distance(lm_list[12][1:], lm_list[16][1:])
    dist_ring_pinky = calculate_distance(lm_list[16][1:], lm_list[20][1:])

    # --- GESTURE LOGIC (same as provided) ---
    # 1. VULCAN SALUTE (🖖)
    if fingers[1] == 1 and fingers[2] == 1 and fingers[3] == 1 and fingers[4] == 1:
        if dist_middle_ring > 35 and dist_index_middle < 30 and dist_ring_pinky < 30:
            message = "Live Long and Prosper 🖖"
            confidence = 0.95
            box_color = (200, 200, 0)
            return message, confidence

    # 2. DISLIKE (👎)
    if fingers[1:] == [0, 0, 0, 0] and lm_list[4][2] > lm_list[3][2] and lm_list[4][2] > lm_list[20][2]:
        message = "DISLIKE"
        confidence = 0.9
        box_color = (0, 0, 139)
        return message, confidence

    # 4. LETTER I / PINKY PROMISE
    if fingers == [0, 0, 0, 0, 1]:
        message = "Letter I / PROMISE"
        confidence = 0.9
        box_color = (255, 105, 180)
        return message, confidence

    # 5. LETTER U
    if fingers == [0, 1, 1, 0, 0] and dist_index_middle < 35:
        message = "Letter U"
        confidence = 0.92
        box_color = (100, 0, 255)
        return message, confidence

    # 6. VICTORY (V)
    if fingers == [0, 1, 1, 0, 0]:
        message = "V (Victory)"
        confidence = 0.9
        box_color = (255, 0, 255)
        return message, confidence

    # 7. LIKE (👍)
    if fingers == [1, 0, 0, 0, 0]:
        message = "LIKE"
        confidence = 0.9
        box_color = (0, 150, 255)
        return message, confidence

    # 8. FIST / A
    if fingers == [0, 0, 0, 0, 0] or fingers == [1, 0, 0, 0, 0]:
        if message != "LIKE":
            message = "A / STOP"
            confidence = 0.9
            box_color = (0, 0, 255)
            return message, confidence

    # 9. HELLO / B
    if fingers == [1, 1, 1, 1, 1]:
        message = "HELLO / B"
        confidence = 0.9
        box_color = (0, 255, 0)
        return message, confidence

    # 10. POINT / D
    if fingers == [0, 1, 0, 0, 0]:
        message = "D / POINT"
        confidence = 0.9
        box_color = (0, 255, 255)
        return message, confidence

    # 11. ROCK (🤘)
    if fingers == [0, 1, 0, 0, 1]:
        message = "ROCK ON"
        confidence = 0.9
        box_color = (50, 50, 50)
        return message, confidence

    # 12. OK / F
    if dist_index_thumb < 30 and fingers[2] == 1:
        message = "F / OK"
        confidence = 0.9
        box_color = (0, 128, 128)
        return message, confidence

    # 13. NUMBER 4
    if fingers == [0, 1, 1, 1, 1]:
        message = "Number 4"
        confidence = 0.9
        box_color = (255, 165, 0)
        return message, confidence

    # default: scanning
    return message, confidence


async def websocket_handler(websocket, path):
    # Register client
    _clients.add(websocket)
    print(f"Client connected: {websocket.remote_address}")
    try:
        # Keep the connection open. This simple server doesn't expect messages from clients.
        await websocket.wait_closed()
    finally:
        _clients.remove(websocket)
        print(f"Client disconnected: {websocket.remote_address}")


async def broadcaster_loop():
    """Broadcast messages placed on the _broadcast_queue to all connected clients."""
    while True:
        msg = await _broadcast_queue.get()
        if not _clients:
            # nothing to do
            continue
        data = json.dumps(msg, ensure_ascii=False)
        webs = list(_clients)
        for ws in webs:
            try:
                await ws.send(data)
            except Exception:
                # client may have disconnected
                pass


def camera_loop(loop: asyncio.AbstractEventLoop):
    """Runs in a background thread. If MediaPipe is available it uses camera+MP,
    otherwise it runs a simulated generator that broadcasts random labels so
    clients can be tested without installing MediaPipe/OpenCV.
    """
    import random, time

    if HAS_MEDIAPIPE and cv2 is not None and hands is not None:
        cap = cv2.VideoCapture(0)
        if not cap.isOpened():
            print("ERROR: Unable to open camera")
            return

        try:
            while cap.isOpened():
                success, image = cap.read()
                if not success:
                    continue

                image = cv2.flip(image, 1)
                image_rgb = cv2.cvtColor(image, cv2.COLOR_BGR2RGB)
                results = hands.process(image_rgb)
                image_bgr = cv2.cvtColor(image_rgb, cv2.COLOR_RGB2BGR)

                message = "Show Gesture..."
                confidence = 0.0

                if results and getattr(results, 'multi_hand_landmarks', None):
                    for hand_landmarks in results.multi_hand_landmarks:
                        mp_drawing.draw_landmarks(image_bgr, hand_landmarks, mp_hands.HAND_CONNECTIONS)

                        lm_list = []
                        for id, lm in enumerate(hand_landmarks.landmark):
                            h, w, c = image_bgr.shape
                            cx, cy = int(lm.x * w), int(lm.y * h)
                            lm_list.append([id, cx, cy])

                        if len(lm_list) != 0:
                            message, confidence = recognize_from_landmarks(lm_list)

                # Show UI locally too (skip if running headless)
                if not HEADLESS and cv2 is not None:
                    cv2.rectangle(image_bgr, (15, 20), (520, 90), (0, 0, 0), -1)
                    cv2.putText(image_bgr, message, (30, 70), cv2.FONT_HERSHEY_SIMPLEX, 1, (255, 255, 255), 2)
                    cv2.imshow('Gesture Server', image_bgr)

                # Broadcast message if confidence > 0 or it's a meaningful string
                if confidence > 0.0 or message != 'Show Gesture...':
                    payload = {"label": message, "confidence": float(confidence)}
                    loop.call_soon_threadsafe(_broadcast_queue.put_nowait, payload)

                if not HEADLESS and cv2 is not None:
                    if cv2.waitKey(5) & 0xFF == ord('q'):
                        break
        finally:
            cap.release()
            if cv2 is not None:
                cv2.destroyAllWindows()
    else:
        # Simulation mode (no MediaPipe). Broadcast a random gesture periodically.
        print('WARNING: MediaPipe not available — running in SIMULATION mode')
        gestures = [
            "HELLO / B",
            "اهلا",
            "LIKE",
            "DISLIKE",
            "ROCK ON",
            "Live Long and Prosper 🖖",
            "Letter I / PROMISE",
            "V (Victory)",
            "D / POINT",
        ]
        try:
            while True:
                label = random.choice(gestures)
                confidence = round(0.6 + random.random() * 0.4, 2)
                payload = {"label": label, "confidence": float(confidence)}
                loop.call_soon_threadsafe(_broadcast_queue.put_nowait, payload)
                time.sleep(0.2)
        except KeyboardInterrupt:
            return


async def main_async():
    # Start websocket server inside an async context
    server = await websockets.serve(websocket_handler, WEBSOCKET_HOST, WEBSOCKET_PORT)

    # Start camera thread; provide the running loop so camera loop can schedule tasks
    running_loop = asyncio.get_running_loop()
    cam_thread = threading.Thread(target=camera_loop, args=(running_loop,), daemon=True)
    cam_thread.start()

    # Start broadcaster task
    broadcaster_task = asyncio.create_task(broadcaster_loop())

    print(f"Gesture WebSocket server started at ws://{WEBSOCKET_HOST}:{WEBSOCKET_PORT}")

    # Keep running until cancelled
    try:
        await asyncio.Future()
    except asyncio.CancelledError:
        pass


def main():
    try:
        asyncio.run(main_async())
    except KeyboardInterrupt:
        print("Shutting down")


if __name__ == '__main__':
    main()
