import 'dart:io';

import 'package:flutter/material.dart';
import 'package:music/controllers/audio_controller.dart';
import 'package:music/controllers/song_controller.dart';
import 'package:provider/provider.dart';

import '../../../components/song_item.dart';

class MusicListScreen extends StatefulWidget {
  const MusicListScreen({super.key});

  @override
  State<StatefulWidget> createState() => MusicListScreenState();
}

class MusicListScreenState extends State<MusicListScreen> {
  @override
  Widget build(BuildContext context) {
    final audioController = context.read<AudioController>();
    final songController = context.read<SongController>();

    return ListView.builder(
      itemCount: songController.songs.length,
      physics: BouncingScrollPhysics(),
      itemBuilder: (BuildContext context, int index) {
        return SongItem(
          song: songController.songs[index],
          onClickItem: () {
            audioController.setPlaylistAndPlay(
              songController.songs,
              songController.songs[index],
            );
          },
        );
      },
    );
  }
}
