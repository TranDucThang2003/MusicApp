import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/song_item.dart';
import '../../controllers/audio_controller.dart';
import '../../controllers/song_controller.dart';
import '../../models/song.dart';

class FavoriteScreen extends StatefulWidget{
  const FavoriteScreen({super.key}) ;

  @override
  State<StatefulWidget> createState() => FavoriteScreenState();
}

class FavoriteScreenState extends State<FavoriteScreen>{

  @override
  Widget build(BuildContext context) {
    final audioController = context.watch<AudioController>();
    final songController = context.watch<SongController>();

    songController.loadFavoriteSongs();

    List<Song> favoriteSongs = songController.favoriteSongs;

    return ListView.builder(
      itemCount: favoriteSongs.length,
      physics: BouncingScrollPhysics(),
      itemBuilder: (context, index) {
        final song = favoriteSongs[index];
        final originalIndex = audioController.songs.indexOf(song);
        return GestureDetector(
          onTap: () => audioController.onPlay(originalIndex),
          child: SongItem(
            song: favoriteSongs[index],
            onClickFavorite: () => songController.handleFavoriteSong(favoriteSongs[index]),
          ),
        );
      },
    );
  }
}