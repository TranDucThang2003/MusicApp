import 'package:flutter/material.dart';
import 'package:music/views/horizontal/left_side.dart';
import 'package:music/views/horizontal/right_side.dart';

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
            SizedBox(width:constrains.maxWidth*0.4,child: LeftSide()),
            SizedBox(width:constrains.maxWidth*0.6,child: RightSide()),
        ],
        );
      }),
    );
  }
}