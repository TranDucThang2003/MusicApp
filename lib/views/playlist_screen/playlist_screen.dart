import 'package:flutter/material.dart';
import 'package:music/views/playlist_screen/search_screen.dart';

import 'favorite_screen.dart';
import 'music_list_screen.dart';

class PlayListScreen extends StatefulWidget{
  const PlayListScreen({super.key});

  @override
  State<StatefulWidget> createState() => PlayListScreenState();
}

class PlayListScreenState extends State<PlayListScreen>{

  int _currentIndex = 1;

  @override
  Widget build(BuildContext context) {

    final pages = [
      SearchScreen(),
      MusicListScreen(),
      FavoriteScreen(),
    ];

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text("PLAYLIST" , style: TextStyle(letterSpacing: 20),),
        centerTitle: true,
      ),
      body: pages[_currentIndex],
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
            setState(() {
              _currentIndex = itemIndex;
            });
          },
        ),
      );
  }
}