import 'dart:io';

import 'package:flutter/material.dart';
import 'package:music/controllers/audio_controller.dart';
import 'package:music/controllers/song_controller.dart';
import 'package:music/models/song.dart';
import 'package:provider/provider.dart';

import '../../components/song_item.dart';

class MusicListScreen extends StatefulWidget{
  final SongController songController;
  final AudioController audioPlayer;
  const MusicListScreen({super.key, required this.songController, required this.audioPlayer});

  @override
  State<StatefulWidget> createState() => MusicListScreenState();

}

class MusicListScreenState extends State<MusicListScreen>{
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder (
              itemCount: widget.songController.songs.length,
              physics: BouncingScrollPhysics(),
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                    onTap: () => widget.audioPlayer.onPlay(index),
                    child: SongItem (
                      song: widget.songController.songs[index],
                      onClickFavorite: () => widget.songController.handleFavoriteSong(widget.songController.songs[index]),
                    ),);
              },
          ),
        ),
    ]);
  }
}