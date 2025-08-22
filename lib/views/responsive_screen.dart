import 'package:flutter/material.dart';
import 'package:music/views/horizontal/hozizontal_screen.dart';
import 'package:music/views/vertical/playlist_screen/playlist_screen.dart';

class ResponsiveScreen extends StatelessWidget {
  const ResponsiveScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) {
        if (orientation == Orientation.portrait) {
          // Màn hình dọc
          return PlayListScreen();
        } else {
          // Màn hình ngang
          return HorizontalScreen();
        }
      },
    );
  }
}
