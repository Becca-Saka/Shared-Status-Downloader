import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class PlayPauseOverlay extends StatelessWidget {
  final VideoPlayerController controller;
  PlayPauseOverlay(this.controller);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        AnimatedSwitcher(
          duration: Duration(milliseconds: 50),
          reverseDuration: Duration(milliseconds: 200),
          child: controller.value.isPlaying?SizedBox.shrink()
          :Container(
            color: Colors.black26,

            child: Center(child: Container(
                              //  decoration: BoxDecoration(
                              //    color: Colors.grey.withOpacity(0.5),
                              //    borderRadius: BorderRadius.circular(50)
                              //  ),
                               child: Icon(Icons.play_arrow, size: 100,))),

          ),

        ),
        GestureDetector(
          onTap: (){
            controller.value.isPlaying?controller.pause():controller.play();
          },
        )
    
      ],
    );
  }
}