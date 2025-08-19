import 'dart:io';

import 'package:flutter/material.dart';
import '../models/song.dart';


class SongItem extends StatelessWidget{
  final Song song;
  final VoidCallback onClickFavorite;

  const SongItem({super.key, required this.song, required this.onClickFavorite});

  @override
  Widget build(BuildContext context) {
    return
      Container(
        margin: EdgeInsets.all(5),
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
          // color: song.isPlaying ? Colors.orange[300] : Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(width: MediaQuery.of(context).size.width*0.05,),
                ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child:
                  song.backgroundURL != ""
                      ? Image.file(File(song.backgroundURL!),width: 50,height: 50,fit: BoxFit.cover)
                      : Image.asset("assets/images/bg.png",width: 50,height: 50,fit: BoxFit.cover),
                ),
                SizedBox(width: MediaQuery.of(context).size.width*0.05,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width*0.5,
                      child: Text(
                        song.songName,
                        textAlign: TextAlign.left,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width*0.5,
                      child: Text(
                        song.songArtist,
                        textAlign: TextAlign.left,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 15),),
                    )
                  ],
                ),
              ],
            ),
            IconButton(onPressed: onClickFavorite, icon: Icon(song.isFavorite ? Icons.favorite : Icons.favorite_border,color: Color(0xFFFF5252),))
          ],
        ),
      );
  }
}