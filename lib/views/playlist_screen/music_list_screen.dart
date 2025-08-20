import 'dart:io';

import 'package:flutter/material.dart';
import 'package:music/controllers/audio_controller.dart';
import 'package:music/controllers/song_controller.dart';
import 'package:music/models/song.dart';
import 'package:provider/provider.dart';

import '../../components/song_item.dart';

class MusicListScreen extends StatefulWidget{
  const MusicListScreen({super.key});

  @override
  State<StatefulWidget> createState() => MusicListScreenState();

}

class MusicListScreenState extends State<MusicListScreen>{
  @override
  Widget build(BuildContext context) {
    final audioController = context.watch<AudioController>();
    final songController = context.read<SongController>();
    return Column(
        children: [
          Expanded(
            child: ListView.builder (
              itemCount: songController.songs.length,
              physics: BouncingScrollPhysics(),
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () => audioController.onPlay(index),
                  child: SongItem (
                    song: songController.songs[index],
                    onClickFavorite: () => songController.handleFavoriteSong(songController.songs[index]),
                  ),);
              },
            ),
          ),
        ]);
  }
}