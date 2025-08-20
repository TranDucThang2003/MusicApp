import 'package:flutter/material.dart';
import 'package:music/controllers/audio_controller.dart';
import 'package:music/controllers/song_controller.dart';
import 'package:music/views/playlist_screen/playlist_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SongController()..requestPermissionAndLoadSongs()),
        ChangeNotifierProxyProvider<SongController, AudioController>(
          create: (_) => AudioController(),
          update: (_, songController, audioController) {
            songController.loadSongsOffline();
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
      home: PlayListScreen(),
    );
  }
}