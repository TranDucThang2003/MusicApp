import 'package:flutter/material.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:music/controllers/audio_controller.dart';
import 'package:music/controllers/song_controller.dart';
import 'package:music/views/responsive_screen.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,
  );

  final songController = SongController();
  await songController.requestPermissionAndLoadSongs();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => songController),
        ChangeNotifierProxyProvider<SongController, AudioController>(
          create: (_) => AudioController(),
          update: (_, songController, audioController) {
            audioController!.setSongList(songController.songs);
            return audioController;
          },
        ),
      ],
      child: const MyMusicApp(),
    ),
  );
}

class MyMusicApp extends StatelessWidget {
  const MyMusicApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: ResponsiveScreen(),
    );
  }
}
