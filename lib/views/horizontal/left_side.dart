import 'package:flutter/material.dart';
import 'package:music/controllers/audio_controller.dart';
import 'package:music/controllers/song_controller.dart';
import 'package:provider/provider.dart';

import '../../../components/song_item.dart';

class LeftSide extends StatelessWidget {
  const LeftSide({super.key});

  @override
  Widget build(BuildContext context) {
    final songController = context.read<SongController>();

    return ListView.builder(
      itemCount: songController.songs.length,
      physics: BouncingScrollPhysics(),
      itemBuilder: (BuildContext context, int index) {
        return SongItem(
          song: songController.songs[index],
          onClickItem: () {
            context.read<AudioController>().setPlaylistAndPlay(
              songController.songs,
              songController.songs[index],
            );
          },
        );
      },
    );
  }
}