import 'dart:io';

import 'package:flutter/material.dart';
import 'package:music/controllers/audio_controller.dart';
import 'package:music/controllers/song_controller.dart';
import 'package:provider/provider.dart';
import '../models/song.dart';
import '../views/vertical/player_screen/player_screen.dart';

class SongItem extends StatelessWidget {
  final Song song;
  final VoidCallback onClickItem;

  const SongItem({super.key, required this.song, required this.onClickItem});

  void onClickToMovePlayScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const PlayerScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentSong = context.select<AudioController, Song?>(
      (controller) => controller.currentSong,
    );
    return GestureDetector(
      onTap: () {
        if(MediaQuery.of(context).orientation == Orientation.landscape){
          onClickItem();
        }else{
          if (currentSong == song) {
            onClickToMovePlayScreen(context);
          } else {
            onClickItem();
          }
        }
      },
      child: Container(
        margin: EdgeInsets.all(5),
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: currentSong == song ? Colors.orange[300] : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.white10, width: 1),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: song.backgroundURL != ""
                  ? Image.file(
                      File(song.backgroundURL),
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    )
                  : Image.asset(
                      "assets/images/bg.png",
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
            ),
            //SizedBox(width: MediaQuery.of(context).size.width*0.05,),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: Text(
                      song.songName,
                      textAlign: TextAlign.left,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: Text(
                      song.songArtist,
                      textAlign: TextAlign.left,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () => currentSong == song
                  ? context.read<AudioController>().togglePlayPause()
                  : context.read<SongController>().handleFavoriteSong(song),
              icon: Consumer2<SongController, AudioController>(
                builder: (_, songController, audioController, __) {
                  return Icon(
                    currentSong == song
                        ? (audioController.isPlaying ? Icons.pause : Icons.play_arrow)
                        : song.isFavorite
                        ? Icons.favorite
                        : Icons.favorite_border,
                    color: currentSong == song
                        ? Colors.black
                        : const Color(0xFFFF5252),
                  );
                },
              ),

            ),
          ],
        ),
      ),
    );
  }
}
