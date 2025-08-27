import 'package:flutter/material.dart';
import 'package:music/views/vertical/player_screen/player_screen.dart';
import 'package:music/views/vertical/playlist_screen/playlist_screen.dart';

class HorizontalScreen extends StatefulWidget{
  const HorizontalScreen({super.key});


  @override
  State<StatefulWidget> createState() => HorizontalScreenState();
}

class HorizontalScreenState extends State<HorizontalScreen>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(builder: (context,constrains){
        return Row(
            children: [
            SizedBox(width:constrains.maxWidth*0.4,child: PlayListScreen()),
            SizedBox(width:constrains.maxWidth*0.6,child: PlayerScreen()),
        ],
        );
      }),
    );
  }
}