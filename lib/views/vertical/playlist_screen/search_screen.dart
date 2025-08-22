import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../components/song_item.dart';
import '../../../controllers/audio_controller.dart';
import '../../../controllers/song_controller.dart';
import '../../../models/song.dart';

class SearchScreen extends StatefulWidget {
  final Function(int) switchPage;

  const SearchScreen({super.key, required this.switchPage});

  @override
  State<StatefulWidget> createState() => SearchScreenState();
}

class SearchScreenState extends State<SearchScreen> {
  String queryString = "";

  @override
  Widget build(BuildContext context) {
    final songController = context.read<SongController>();

    List<Song> filterSong() {
      if (queryString.isEmpty) return songController.songs;
      return songController.songs.where((song) {
        return song.songArtist.toLowerCase().contains(
              queryString.toLowerCase(),
            ) ||
            song.songName.toLowerCase().contains(queryString.toLowerCase());
      }).toList();
    }
    List<Song> filteredSongs = filterSong();

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.05,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.7,
                height: 50,
                child: TextField(
                  decoration: InputDecoration(
                    hintText: ("Tên bài hát, tên nghệ sĩ "),
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onChanged: (text) {
                    setState(() {
                      queryString = text;
                    });
                  },
                ),
              ),
              SizedBox(
                width: 50,
                height: 50,
                child: GestureDetector(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: Image.asset("assets/images/bg.png"),
                  ),
                  onTap: () {
                    widget.switchPage(2);
                  },
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 10),
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.05,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "For you",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              TextButton(
                onPressed: () {
                  widget.switchPage(1);
                },
                child: Text(
                  "view all",
                  style: TextStyle(color: Colors.grey, fontSize: 10),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 10),
        Expanded(
          child: Container(
            margin: EdgeInsets.all(10),
            child: ListView.builder(
              itemCount: filteredSongs.length,
              physics: BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                final song = filteredSongs[index];
                return SongItem(
                  song: filteredSongs[index],
                  onClickItem: () {
                    context.read<AudioController>().setPlaylistAndPlay(
                      songController.songs,
                      song,
                    );
                  },
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
