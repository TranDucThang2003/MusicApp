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

  void onClickToMovePlayScreen(Song song){

  }

  @override
  Widget build(BuildContext context) {
    final audioPlayer = Provider.of<AudioController>(context);
    final songController = Provider.of<SongController>(context);

    return Column(
      children: [
        Expanded(
          child: ListView.builder (
              itemCount: songController.songs.length,
              physics: BouncingScrollPhysics(),
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                    onTap: () => audioPlayer.onPlay(index),
                    child: SongItem (
                      song: songController.songs[index],
                      onClickFavorite: () => songController.handleFavoriteSong(songController.songs[index]),
                    ),);
              },
          ),
        ),
        if (audioPlayer.currentPlayingIndex.value != null)
        Align(
          alignment: Alignment.bottomCenter,
          child: GestureDetector(
            onTap: () {
              onClickToMovePlayScreen(audioPlayer.songs[audioPlayer.currentPlayingIndex.value!]);
            },
            child: Container(
              height: 70,
              color: Colors.black,
              padding: EdgeInsets.symmetric(horizontal: 15),
              child:
                Row(
                  children: [
                // Ảnh nền bài hát hoặc icon
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                          "assets/images/bg.png",
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                          ),
                  ),
                SizedBox(width: 15),
                // Tên bài hát và nghệ sĩ
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                    Text(
                      songController.songs[audioPlayer.currentPlayingIndex.value!].songName,
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                      ),
                    Text(
                      songController.songs[audioPlayer.currentPlayingIndex.value!].songArtist,
                      style: TextStyle(color: Colors.white70, fontSize: 12),
                      overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    ),
                ),
                ])
              )
          )
        )
    ]);
  }
}