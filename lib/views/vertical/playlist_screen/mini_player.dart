import 'dart:io';

import 'package:flutter/material.dart';
import 'package:music/controllers/audio_controller.dart';
import 'package:provider/provider.dart';
import '../../../models/song.dart';

class MiniPlayer extends StatelessWidget {
  const MiniPlayer({super.key});

  void onClickToMovePlayScreen(BuildContext context) {
    Navigator.of(context).pushNamed('/player');
  }

  @override
  Widget build(BuildContext context) {
    final currentSong = context.select<AudioController,Song?>((controller)=>controller.currentSong);

    if (currentSong == null || MediaQuery.of(context).orientation == Orientation.landscape) return SizedBox.shrink();
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
                child: Hero(
                  tag: 'player',
                  child: currentSong.backgroundURL != ""
                      ? Image.file(File(currentSong.backgroundURL))
                      : Image.asset(
                          "assets/images/bg.png",
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        ),
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      currentSong.songName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      currentSong.songArtist,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Selector<AudioController, bool>(
                builder: (_, isPlaying, _) {
                  return IconButton(
                    icon: Icon(
                      isPlaying ? Icons.pause : Icons.play_arrow,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      context.read<AudioController>().togglePlayPause();
                    },
                  );
                },
                selector: (_, audio) => audio.isPlaying,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
