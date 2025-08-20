import 'package:flutter/material.dart';
import 'package:music/views/playlist_screen/mini_player.dart';
import 'package:music/views/playlist_screen/search_screen.dart';
import 'package:provider/provider.dart';

import '../../controllers/audio_controller.dart';
import '../../controllers/song_controller.dart';
import 'favorite_screen.dart';
import 'music_list_screen.dart';

class PlayListScreen extends StatefulWidget{
  const PlayListScreen({super.key});

  @override
  State<StatefulWidget> createState() => PlayListScreenState();
}

class PlayListScreenState extends State<PlayListScreen>{

  int _currentIndex = 1;

  void switchPage(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final audioPlayer = Provider.of<AudioController>(context);
    final songController = Provider.of<SongController>(context);

    final pages = [
      SearchScreen(switchPage: switchPage,),
      MusicListScreen(audioPlayer: audioPlayer, songController: songController,),
      FavoriteScreen(),
    ];

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text("PLAYLIST" , style: TextStyle(letterSpacing: 20),),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(child: pages[_currentIndex]),
          MiniPlayer()
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          fixedColor: Colors.deepOrange,
          backgroundColor: Colors.orangeAccent,
          items: [
            BottomNavigationBarItem(
                label: "Search",
                icon: Icon(Icons.search)),
            BottomNavigationBarItem(
                label: "Music",
                icon: Icon(Icons.music_note)),
            BottomNavigationBarItem(
                label: "Favourite",
                icon: Icon(Icons.favorite)),
          ],
          onTap: (itemIndex){
            switchPage(itemIndex);
          },
        ),
      );
  }
}