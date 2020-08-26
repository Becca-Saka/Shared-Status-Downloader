import 'dart:io';
import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stacked/stacked.dart';
import 'package:status_downloader/views/home/home_viewmodel.dart';
import 'package:status_downloader/views/widgets/play_pause_overlay.dart';
import 'package:video_player/video_player.dart';

class VideosPreview extends StatelessWidget {
  final String videoPath;
  VideosPreview(this.videoPath);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HomeViewModel>.reactive(
      builder: (context, model, child){
        
        return Scaffold(
           appBar: AppBar(
             elevation: 0.0,
             backgroundColor: Theme.of(context).scaffoldBackgroundColor,
           ),
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Expanded(
                  child: Container(
                      child:   Hero(
                        tag: videoPath,
                              child: Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical:20, horizontal: 5,
                              ),
                          child: FutureBuilder(
                            future: model.intializeVideoPlayerFuture,
                            builder: (context, snapshot){
                            if(snapshot.connectionState ==ConnectionState.done){
                              return  AspectRatio(
                            aspectRatio: model.controller.value.aspectRatio,
                            child: Stack(
                                alignment: Alignment.bottomCenter,
                                children: <Widget>[
                              VideoPlayer(model.controller),
                              Stack(
                                children: <Widget>[
                                  AnimatedSwitcher(
                                    duration: Duration(milliseconds: 50),
                                    reverseDuration: Duration(milliseconds: 200),
                                    child: model.controller.value.isPlaying?SizedBox.shrink()
                                    :Container(
                                      color: Colors.black26,
                                      child: Center(child: Icon(Icons.play_arrow, size: 80,)),

                                    ),

                                  ),
                                  GestureDetector(
                                    onTap: (){
                                      model.playPause();
                                    },
                                  )
                              
                                ],
                              ),
                              VideoProgressIndicator(model.controller, allowScrubbing: true,),
                              ],
                            ),);
                            }else{
                              return Center(child: CircularProgressIndicator());
                            }
                          })
                          //  !model.isBusy?
                          // AspectRatio(
                          //   aspectRatio: model.controller.value.aspectRatio,
                          //   child: VideoPlayer(model.controller),):
                          //   CircularProgressIndicator()
                        ),
                      ),),
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                       child: IconButton(icon: Icon(Icons.save),
                       onPressed: (){
                         model.saveVideo(videoPath);

                       }),
                    ),
                     Expanded(
                        child: IconButton(icon: Icon(Icons.share),
                       onPressed: (){
                         model.share(videoPath, false);
                       }),
                     ),
                     Expanded(
                        child: IconButton(icon: Icon(Icons.cloud_upload),
                       onPressed: (){
                         model.uploadFile(videoPath, false);
                       }),
                     ),
                  
                  ],
                )
              ],
            ),
          ));
      },
      viewModelBuilder:()=> HomeViewModel(),
      onModelReady: (model) async{
        await model.initializeVideoController(videoPath);
      },
    
    );
  }
}
