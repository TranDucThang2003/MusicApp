import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/audio_controller.dart';
import '../../controllers/song_controller.dart';
import '../../models/song.dart';

class PlayerScreen extends StatefulWidget{
  final Song song;
  const PlayerScreen({super.key, required this.song});

  @override
  State<StatefulWidget> createState() => PlayerScreenState();
}

class PlayerScreenState extends State<PlayerScreen> with SingleTickerProviderStateMixin{

  Duration _currentPosition = Duration.zero;
  Duration _totalDuration = Duration.zero;

  late AnimationController _rotationController;


  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 90), // 10 giây cho 1 vòng xoay
    )..repeat();

  }
  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    final audioPlayer = Provider.of<AudioController>(context);
    final songController = Provider.of<SongController>(context);

    return Scaffold(
        backgroundColor: Colors.purple,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text("C H I L L I N G T I M E",style: TextStyle(color: Colors.white),),
          centerTitle: true,
          elevation: 0,
        ),
        body: Container(
            margin: const EdgeInsets.only(top : kToolbarHeight + 30),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50),
                    topRight: Radius.circular(50)
                )
            ),
            child: Center(
                child: Column(
                  children: [
                  Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      margin: EdgeInsets.only(
                          top: 20,
                          right: 20
                      ),
                      child: IconButton(onPressed: (){

                      }, icon: Icon(Icons.favorite,color: Colors.pinkAccent,)),
                    )
                  ],
                ),
                SizedBox(height: 50,),
                Container(
                  width: 250,
                  height: 250,
                  decoration: BoxDecoration(
                      border: BoxBorder.all(color: Colors.amber,width: 20),
                      borderRadius: BorderRadius.circular(250)
                  ),
                  child: RotationTransition(
                    turns: _rotationController,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(250),
                      child: Image.file(File(widget.song.backgroundURL!)),
                    ),
                  ),
                ),
                SizedBox(height: 50,),
                Text(
                  widget.song.songName,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontWeight: FontWeight.bold,fontSize: 30),),
                Text(widget.song.songArtist),
                SizedBox(height: 20,),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(_formatDuration(_currentPosition),style: TextStyle(fontSize: 20),),
                      Text(_formatDuration(_totalDuration),style: TextStyle(fontSize: 20),),
                    ],
                  ),
                ),
                    Slider(
                      min: 0,
                      max: _totalDuration.inSeconds.toDouble(),
                      value: _currentPosition.inSeconds.clamp(0, _totalDuration.inSeconds).toDouble(),
                      onChanged: (value) {
                        setState(() {
                          _currentPosition = Duration(seconds: value.toInt());
                        });
                        audioPlayer.skipToNext();
                      },),
                    SizedBox(height: 20,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                            onPressed: (){
                             // _toggleOnRepeat();
                            }, icon: Icon(Icons.repeat,size: 50,color:Colors.black,)
                        ),
                        IconButton(
                            onPressed: (){
                              //_handlePrevious();
                            }, icon: Icon(Icons.skip_previous_sharp,size: 50,color: Colors.black,)
                        ),
                        Container(
                          width: 75,
                          height: 75,
                          decoration: BoxDecoration(
                              color: Colors.purple,
                              borderRadius: BorderRadius.circular(75)
                          ),
                          child: IconButton(onPressed: (){
                            //_handlePlayPause();
                          }, icon: Icon(Icons.pause,size: 50, color: Colors.black,)),
                        ),
                        IconButton(
                            onPressed: (){
                              //_handleNext();
                            }, icon: Icon(Icons.skip_next_sharp,size: 50,color: Colors.black,)
                        ),
                        IconButton(
                            onPressed: (){
                              //_toggleOnShuffle();
                            }, icon: Icon(Icons.shuffle,size: 50, color:Colors.black,)
                        ),
                      ],
                    )
                  ],
                ),
            ),
        ),
      endDrawer: Drawer(
      ),
    );
  }
}