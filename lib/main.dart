import 'package:flutter/material.dart';
import 'package:music/controller/audio_controller.dart';
import 'package:music/controller/song_controller.dart';
import 'package:music/screens/playlist_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(providers: [
      ChangeNotifierProvider(create: (_) => SongController()),
      Provider(create: (_) => AudioController())
    ]),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: PlayListScreen(),
    );
  }
}