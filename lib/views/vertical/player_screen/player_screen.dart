import 'dart:io';

import 'package:flutter/material.dart';
import 'package:music/controllers/audio_controller.dart';
import 'package:music/controllers/song_controller.dart';
import 'package:music/utils/utils.dart';
import 'package:provider/provider.dart';

import '../../../models/song.dart';

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
      duration: const Duration(seconds: 60),
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
    final audioController = context.read<AudioController>();
    final song = context.select<AudioController, Song?>(
      (controller) => controller.currentSong,
    );
    if (song == null) {
      return const Scaffold(
        body: Center(child: Text("Không có bài hát nào đang phát")),
      );
    }

    return Scaffold(
      backgroundColor: Colors.purple,
      extendBodyBehindAppBar: true,
      appBar: MediaQuery.of(context).orientation == Orientation.landscape
          ? null
          : AppBar(
              backgroundColor: Colors.transparent,
              title: const Text(
                "CHILLTIME",
                style: TextStyle(color: Colors.white, letterSpacing: 20),
              ),
              centerTitle: true,
              elevation: 0,
            ),
      body: Container(
        margin: MediaQuery.of(context).orientation == Orientation.landscape
            ? null
            : EdgeInsets.only(top: kToolbarHeight + 50),
        decoration: MediaQuery.of(context).orientation == Orientation.landscape
            ? BoxDecoration(
                color: Colors.white
              )
            : BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50),
                  topRight: Radius.circular(50),
                ),
              ),
        child: Center(
          child: SingleChildScrollView(
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
                          context.read<SongController>().handleFavoriteSong(
                            song,
                          );
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
                Selector<AudioController, bool>(
                  builder: (_, isPlaying, __) {
                    if (isPlaying) {
                      _rotationController.repeat();
                    } else {
                      _rotationController.stop(canceled: false);
                    }
                    return Container(
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
                    );
                  },
                  selector: (_, controller) => controller.isPlaying,
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
                  stream: audioController.audioPlayer.positionStream,
                  builder: (context, snap) {
                    final position = snap.data ?? Duration.zero;
                    final total = audioController.totalDuration;
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
                    Selector<AudioController, Repeat>(
                      builder: (_, isRepeat, __) {
                        return IconButton(
                          onPressed: () {
                            audioController.toggleRepeat();
                          },
                          icon: Icon(
                            isRepeat == Repeat.repeatOne
                                ? Icons.repeat_one
                                : Icons.repeat,
                            size: 50,
                            color: isRepeat == Repeat.noRepeat
                                ? Colors.black
                                : Colors.amber,
                          ),
                        );
                      },
                      selector: (_, controller) => controller.isRepeat,
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
                      child: Selector<AudioController, bool>(
                        builder: (_, isPlaying, __) {
                          return IconButton(
                            onPressed: () {
                              audioController.togglePlayPause();
                            },
                            icon: Icon(
                              isPlaying ? Icons.pause : Icons.play_arrow,
                              size: 50,
                            ),
                          );
                        },
                        selector: (_, controller) => controller.isPlaying,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        audioController.skipToNext();
                      },
                      icon: const Icon(Icons.skip_next, size: 50),
                    ),
                    Selector<AudioController, bool>(
                      builder: (_, isShuffle, __) {
                        return IconButton(
                          onPressed: () {
                            audioController.toggleShuffle();
                          },
                          icon: Icon(
                            Icons.shuffle,
                            size: 50,
                            color: isShuffle ? Colors.amber : Colors.black,
                          ),
                        );
                      },
                      selector: (_, controller) => controller.isShuffle,
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
