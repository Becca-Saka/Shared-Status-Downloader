import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class DeleteShareOverlay extends StatelessWidget {
  final Widget child;
  DeleteShareOverlay(this.child);

  @override
  Widget build(BuildContext context) {
    return Column(

      children: <Widget>[
        child,
       Row(
        //  mainAxisSize: MainAxisSize.min,
         children: [
           Expanded(
                        child: Center(
                          child: IconButton(
               icon: Icon(Icons.delete),
               onPressed: (){

               }),
                        ),
           ),
            Expanded(
                          child: Center(
                child: IconButton(
                 icon: Icon(Icons.share),
                 onPressed: (){
                   
                 }),
              ),
            ),
         ],
       ),
        GestureDetector(
          onTap: (){
          },
        )
    
      ],
    );
  }
}