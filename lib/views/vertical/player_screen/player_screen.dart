import 'dart:io';

import 'package:flutter/material.dart';
import 'package:music/controllers/audio_controller.dart';
import 'package:music/controllers/song_controller.dart';
import 'package:provider/provider.dart';

class PlayerScreen extends StatefulWidget {
  const PlayerScreen({super.key});

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _rotationController;

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 90),
    )..repeat();
  }

  @override
  void dispose() {
    _rotationController.dispose();
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    final audioController = context.watch<AudioController>();
    final songController = context.read<SongController>();

    final song = audioController.currentSong;
    if (song == null) {
      return const Scaffold(
        body: Center(child: Text("Không có bài hát nào đang phát")),
      );
    }

    return SingleChildScrollView(
      child: Scaffold(
        backgroundColor: Colors.purple,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: const Text(
            "CHILLTIME",
            style: TextStyle(color: Colors.white, letterSpacing: 20),
          ),
          centerTitle: true,
          elevation: 0,
        ),
        body: Container(
          margin: const EdgeInsets.only(top: kToolbarHeight + 50),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(50),
              topRight: Radius.circular(50),
            ),
          ),
          child: Center(
            child: Column(
              children: [
                // Nút favorite
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 20, right: 20),
                      child: IconButton(
                        onPressed: () {
                          songController.handleFavoriteSong(song);
                        },
                        icon: Icon(
                          song.isFavorite
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: Colors.pinkAccent,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 50),

                // Ảnh xoay
                Container(
                  width: 250,
                  height: 250,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.amber, width: 5),
                    borderRadius: BorderRadius.circular(250),
                  ),
                  child: RotationTransition(
                    turns: _rotationController,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(250),
                      child: Hero(
                        tag: 'player',
                        child: song.backgroundURL != ""
                            ? Image.file(File(song.backgroundURL))
                            : Image.asset("assets/images/bg.png"),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 50),

                // Tên bài hát
                Text(
                  song.songName,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                  ),
                ),
                Text(song.songArtist),
                const SizedBox(height: 20),

                // Thanh thời gian
                StreamBuilder<Duration>(
                  stream: context
                      .read<AudioController>()
                      .audioPlayer
                      .positionStream,
                  builder: (context, snap) {
                    final position = snap.data ?? Duration.zero;
                    final total = context.read<AudioController>().totalDuration;
                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                _formatDuration(position),
                                style: const TextStyle(fontSize: 20),
                              ),
                              Text(
                                _formatDuration(total),
                                style: const TextStyle(fontSize: 20),
                              ),
                            ],
                          ),
                        ),
                        Slider(
                          min: 0,
                          max: total.inSeconds.toDouble(),
                          value: position.inSeconds
                              .clamp(0, total.inSeconds)
                              .toDouble(),
                          onChanged: (value) {
                            audioController.seek(
                              Duration(seconds: value.toInt()),
                            );
                          },
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 20),
                // Control buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      onPressed: () {
                        audioController.toggleRepeat();
                      },
                      icon: Icon(
                        Icons.repeat,
                        size: 50,
                        color: audioController.isRepeat
                            ? Colors.amber
                            : Colors.black,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        audioController.skipToPrevious();
                      },
                      icon: const Icon(Icons.skip_previous, size: 50),
                    ),
                    Container(
                      width: 75,
                      height: 75,
                      decoration: BoxDecoration(
                        color: Colors.purple,
                        borderRadius: BorderRadius.circular(75),
                      ),
                      child: IconButton(
                        onPressed: () {
                          audioController.togglePlayPause();
                          audioController.isPlaying
                              ? _rotationController.stop()
                              : _rotationController.repeat();
                        },
                        icon: Icon(
                          audioController.isPlaying
                              ? Icons.pause
                              : Icons.play_arrow,
                          size: 50,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        audioController.skipToNext();
                      },
                      icon: const Icon(Icons.skip_next, size: 50),
                    ),
                    IconButton(
                      onPressed: () {
                        audioController.toggleShuffle();
                      },
                      icon: Icon(
                        Icons.shuffle,
                        size: 50,
                        color: audioController.isShuffle
                            ? Colors.amber
                            : Colors.black,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
