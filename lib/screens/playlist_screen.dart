import 'package:flutter/material.dart';

class PlayListScreen extends StatefulWidget{
  const PlayListScreen({super.key});

  @override
  State<StatefulWidget> createState() => PlayListScreenState();
}

class PlayListScreenState extends State<PlayListScreen>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("PLAYLIST" , style: TextStyle(letterSpacing: 20),),
      ),
    );
  }
}