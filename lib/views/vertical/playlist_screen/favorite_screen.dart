import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../components/song_item.dart';
import '../../../controllers/audio_controller.dart';
import '../../../controllers/song_controller.dart';
import '../../../models/song.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<StatefulWidget> createState() => FavoriteScreenState();
}

class FavoriteScreenState extends State<FavoriteScreen> {
  @override
  Widget build(BuildContext context) {
    return Selector<SongController,List<Song>>(builder: (_,songs,__){
      return ListView.builder(
        itemCount: songs.length,
        physics: BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          return SongItem(
            song: songs[index],
            onClickItem: () {
              context.read<AudioController>().setPlaylistAndPlay(
                songs,
                songs[index],
              );
            },
          );
        },
      );
    }, selector: (_,controller) => controller.favoriteSongs);
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SongController>().loadFavoriteSongs();
    });
  }

}
