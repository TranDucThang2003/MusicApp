import 'dart:io';

import 'package:flutter/material.dart';
import 'package:music/controllers/audio_controller.dart';
import 'package:music/controllers/song_controller.dart';
import 'package:provider/provider.dart';
import '../models/song.dart';

class SongItem extends StatelessWidget {
  final Song song;
  final VoidCallback onClickItem;

  const SongItem({super.key, required this.song, required this.onClickItem});

  @override
  Widget build(BuildContext context) {
    final audioController = context.watch<AudioController>();
    final songController = context.watch<SongController>();
    return GestureDetector(
      onTap: onClickItem,
      child: Container(
        margin: EdgeInsets.all(5),
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: audioController.currentSong == song ? Colors.orange[300] : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color : Colors.white10,width: 1),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(width: MediaQuery.of(context).size.width * 0.05),
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: song.backgroundURL != ""
                  ? Image.file(
                      File(song.backgroundURL!),
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
              onPressed: () => audioController.currentSong == song ? audioController.onStop() : songController.handleFavoriteSong(song),
              icon: Icon(
                audioController.currentSong == song ? Icons.pause : song.isFavorite ? Icons.favorite : Icons.favorite_border,
                color: audioController.currentSong == song ? Colors.black : Color(0xFFFF5252),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
