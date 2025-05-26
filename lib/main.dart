import 'package:audio_session/audio_session.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:frame_ble/brilliant_bluetooth.dart';
import 'package:noa/pages/splash.dart';
import 'package:noa/util/app_log.dart';
import 'package:noa/util/foreground_service.dart';
import 'package:noa/util/location.dart';
import 'dart:developer';
final globalPageStorageBucket = PageStorageBucket();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables
  await dotenv.load(fileName: '.env');

  // Start logging container
  final container = ProviderContainer();
  container.read(appLog);

  // Initialize foreground service
  initializeForegroundService();

  // Request Bluetooth permission
  try {
    await BrilliantBluetooth.requestPermission();
  } catch (e) {
    // Handle denial
    log('Bluetooth permission denied: $e', level: 1000);
    return;
  }

  // Start location updates (permission handled internally)
  Location.startLocationStream();

  // Configure audio session for speech
  _setupAudioSession();

  runApp(UncontrolledProviderScope(
    container: container,
    child: const MainApp(),
  ));
}

void _setupAudioSession() {
  AudioSession.instance.then((audioSession) async {
    await audioSession.configure(const AudioSessionConfiguration(
      avAudioSessionCategory: AVAudioSessionCategory.playback,
      avAudioSessionCategoryOptions:
          AVAudioSessionCategoryOptions.mixWithOthers,
      avAudioSessionMode: AVAudioSessionMode.spokenAudio,
      avAudioSessionRouteSharingPolicy:
          AVAudioSessionRouteSharingPolicy.defaultPolicy,
      avAudioSessionSetActiveOptions: AVAudioSessionSetActiveOptions.none,
      androidAudioAttributes: AndroidAudioAttributes(
        contentType: AndroidAudioContentType.speech,
        flags: AndroidAudioFlags.none,
        usage: AndroidAudioUsage.assistant,
      ),
      androidAudioFocusGainType: AndroidAudioFocusGainType.gain,
      androidWillPauseWhenDucked: true,
    ));
    audioSession.setActive(true);
  });
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    startForegroundService();
    return const WithForegroundTask(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SplashPage(),
      ),
    );
  }
}