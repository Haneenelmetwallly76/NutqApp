package com.example.new_notq_app

import android.Manifest
import android.content.Intent
import android.content.pm.PackageManager
import android.os.Bundle
import android.speech.RecognitionListener
import android.speech.RecognizerIntent
import android.speech.SpeechRecognizer
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

	private val METHOD_CHANNEL = "com.example.new_notq_app/speech_methods"
	private val EVENT_CHANNEL = "com.example.new_notq_app/speech_events"
	private val REQUEST_RECORD_AUDIO = 1234

	private var speechRecognizer: SpeechRecognizer? = null
	private var eventSink: EventChannel.EventSink? = null

	override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
		super.configureFlutterEngine(flutterEngine)

		MethodChannel(flutterEngine.dartExecutor.binaryMessenger, METHOD_CHANNEL).setMethodCallHandler { call, result ->
			when (call.method) {
				"initialize" -> {
					result.success(true)
				}
				"startListening" -> {
					val args = call.arguments as? Map<*, *>
					// Accept either 'locale' or 'localeId' from Flutter. Default to ar-EG.
					var localeArg = args?.get("locale") as? String ?: args?.get("localeId") as? String ?: "ar-EG"
					// Normalize common separators (underscore -> hyphen) and casing
					localeArg = localeArg.replace('_', '-').trim()
					if (localeArg.isEmpty()) localeArg = "ar-EG"
					val listenFor = (args?.get("listenFor") as? Int) ?: 30
					startListening(localeArg, listenFor)
					result.success(null)
				}
				"stopListening" -> {
					stopListening()
					result.success(null)
				}
				else -> result.notImplemented()
			}
		}

		EventChannel(flutterEngine.dartExecutor.binaryMessenger, EVENT_CHANNEL).setStreamHandler(object : EventChannel.StreamHandler {
			override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
				eventSink = events
			}

			override fun onCancel(arguments: Any?) {
				eventSink = null
			}
		})
	}

	private fun startListening(localeId: String, listenFor: Int) {
		var localeString = localeId
		if (localeString.isBlank()) localeString = "ar-EG"
		// Ensure format like ar-EG (replace underscores if present)
		localeString = localeString.replace('_', '-').trim()

		if (ContextCompat.checkSelfPermission(this, Manifest.permission.RECORD_AUDIO) != PackageManager.PERMISSION_GRANTED) {
			ActivityCompat.requestPermissions(this, arrayOf(Manifest.permission.RECORD_AUDIO), REQUEST_RECORD_AUDIO)
			eventSink?.success(mapOf("type" to "error", "error" to "permission_required", "message" to "RECORD_AUDIO permission required"))
			return
		}

		if (SpeechRecognizer.isRecognitionAvailable(this)) {
			if (speechRecognizer == null) {
				speechRecognizer = SpeechRecognizer.createSpeechRecognizer(this)
				speechRecognizer?.setRecognitionListener(object : RecognitionListener {
					override fun onReadyForSpeech(params: Bundle?) {
						eventSink?.success(mapOf("type" to "status", "status" to "ready"))
					}

					override fun onBeginningOfSpeech() {
						eventSink?.success(mapOf("type" to "status", "status" to "listening"))
					}

					override fun onRmsChanged(rmsdB: Float) {}

					override fun onBufferReceived(buffer: ByteArray?) {}

					override fun onEndOfSpeech() {
						eventSink?.success(mapOf("type" to "status", "status" to "done"))
					}

					override fun onError(error: Int) {
						val message = when (error) {
							SpeechRecognizer.ERROR_AUDIO -> "audio_error"
							SpeechRecognizer.ERROR_CLIENT -> "client_error"
							SpeechRecognizer.ERROR_INSUFFICIENT_PERMISSIONS -> "insufficient_permissions"
							SpeechRecognizer.ERROR_NETWORK -> "network_error"
							SpeechRecognizer.ERROR_NETWORK_TIMEOUT -> "network_timeout"
							SpeechRecognizer.ERROR_NO_MATCH -> "no_match"
							SpeechRecognizer.ERROR_RECOGNIZER_BUSY -> "busy"
							SpeechRecognizer.ERROR_SERVER -> "server_error"
							SpeechRecognizer.ERROR_SPEECH_TIMEOUT -> "speech_timeout"
							else -> "unknown_error"
						}
						eventSink?.success(mapOf("type" to "error", "error" to message, "code" to error))
					}

					override fun onResults(results: Bundle?) {
						val data = results?.getStringArrayList(SpeechRecognizer.RESULTS_RECOGNITION)
						val text = data?.joinToString(" ") ?: ""
						eventSink?.success(mapOf("type" to "final", "text" to text))
					}

					override fun onPartialResults(partialResults: Bundle?) {
						val data = partialResults?.getStringArrayList(SpeechRecognizer.RESULTS_RECOGNITION)
						val text = data?.joinToString(" ") ?: ""
						eventSink?.success(mapOf("type" to "partial", "text" to text))
					}

					override fun onEvent(eventType: Int, params: Bundle?) {}
				})
			}

			val intent = Intent(RecognizerIntent.ACTION_RECOGNIZE_SPEECH)
			intent.putExtra(RecognizerIntent.EXTRA_LANGUAGE_MODEL, RecognizerIntent.LANGUAGE_MODEL_FREE_FORM)
			// Set both language and language preference so devices pick the requested locale when available
			intent.putExtra(RecognizerIntent.EXTRA_LANGUAGE, localeString)
			intent.putExtra(RecognizerIntent.EXTRA_LANGUAGE_PREFERENCE, localeString)
			intent.putExtra(RecognizerIntent.EXTRA_PARTIAL_RESULTS, true)
			intent.putExtra(RecognizerIntent.EXTRA_MAX_RESULTS, 5)
			speechRecognizer?.startListening(intent)
		} else {
			eventSink?.success(mapOf("type" to "error", "error" to "recognition_unavailable", "message" to "Speech recognition not available on this device"))
		}
	}

	private fun stopListening() {
		try {
			speechRecognizer?.stopListening()
			speechRecognizer?.cancel()
			speechRecognizer?.destroy()
			speechRecognizer = null
			eventSink?.success(mapOf("type" to "status", "status" to "stopped"))
		} catch (e: Exception) {
			eventSink?.success(mapOf("type" to "error", "error" to "stop_failed", "message" to e.message))
		}
	}

	override fun onRequestPermissionsResult(requestCode: Int, permissions: Array<String>, grantResults: IntArray) {
		super.onRequestPermissionsResult(requestCode, permissions, grantResults)
		if (requestCode == REQUEST_RECORD_AUDIO) {
			if (grantResults.isNotEmpty() && grantResults[0] == PackageManager.PERMISSION_GRANTED) {
				eventSink?.success(mapOf("type" to "status", "status" to "permission_granted"))
			} else {
				eventSink?.success(mapOf("type" to "error", "error" to "permission_denied", "message" to "User denied RECORD_AUDIO permission"))
			}
		}
	}
}
