import 'dart:async';
import 'dart:developer';
import 'package:speech_to_text/speech_to_text.dart';

class SttService {
  final SpeechToText _stt = SpeechToText();
  bool _initialized = false;

  /// Initialize the speech-to-text engine
  Future<void> init() async {
    _initialized = await _stt.initialize(
      onError: (error) {
        log('STT Error: $error', level: 1000);
      },
      onStatus: (status) {
        log('STT Status: $status', level: 800);
      },
    );
  }

  /// Listen until a final result is received or timeout
  Future<String?> listen({
    Duration maxListenDuration = const Duration(seconds: 60),
    Duration pauseFor = const Duration(seconds: 1),
    String localeId = 'en_US',
  }) async {
    if (!_initialized) return null;
    final completer = Completer<String?>();
    String lastWords = '';

    await _stt.listen(
      onResult: (result) {
        lastWords = result.recognizedWords;
        if (result.finalResult) {
          completer.complete(lastWords);
        }
      },
      listenFor: maxListenDuration,
      pauseFor: pauseFor,
      partialResults: true,
      localeId: localeId,
    );

    final recognized = await completer.future;
    await _stt.stop();
    return recognized;
  }

  /// Stop any ongoing listening
  Future<void> stop() async {
    if (_initialized && _stt.isListening) {
      await _stt.stop();
    }
  }
}