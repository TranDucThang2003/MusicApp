import 'package:flutter/material.dart';
import 'package:music/controllers/audio_controller.dart';
import 'package:music/controllers/song_controller.dart';
import 'package:provider/provider.dart';
import '../../models/song.dart';
import '../player_screen/player_screen.dart';

class MiniPlayer extends StatelessWidget {
  const MiniPlayer({super.key});

  void onClickToMovePlayScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const PlayerScreen(),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    final audioController = context.watch<AudioController>();

    if (!audioController.isPlaying) return const SizedBox.shrink();

    final song = audioController.songs[audioController.currentPlayingIndex!];

    return Align(
      alignment: Alignment.bottomCenter,
      child: GestureDetector(
        onTap: () => onClickToMovePlayScreen(context),
        child: Container(
          height: 70,
          color: Colors.black,
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  "assets/images/bg.png",
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(song.songName,
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis),
                    Text(song.songArtist,
                        style: const TextStyle(
                            color: Colors.white70, fontSize: 12),
                        overflow: TextOverflow.ellipsis),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(audioController.isPlaying?Icons.pause:Icons.play_arrow, color: Colors.white),
                onPressed: () {
                  audioController.togglePlayPause();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
