import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:status_downloader/services/dialogs_service.dart';
import 'package:status_downloader/views/home/home_viewmodel.dart';
import 'package:video_player/video_player.dart';

class VideosPreview extends StatelessWidget {
  final VideoModel videoModel;
  VideosPreview(this.videoModel);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HomeViewModel>.reactive(
      builder: (context, model, child) {
        return Scaffold(
            appBar: AppBar(
              elevation: 0.0,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
               leading: IconButton(
                icon: Icon(Icons.arrow_back, color:Colors.black),
                onPressed: (){
                  Navigator.pop(context);
                },
              ),
            ),
            body: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Expanded(
                    child: Container(
                      child: Hero(
                        tag: videoModel.path,
                        child: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 20,
                              horizontal: 5,
                            ),
                            child: FutureBuilder(
                                future: model.intializeVideoPlayerFuture,
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.done) {
                                    return AspectRatio(
                                      aspectRatio:
                                          model.controller.value.aspectRatio,
                                      child: Stack(
                                        alignment: Alignment.bottomCenter,
                                        children: <Widget>[
                                          VideoPlayer(model.controller,),
                                          Stack(
                                            children: <Widget>[
                                              AnimatedSwitcher(
                                                duration:
                                                    Duration(milliseconds: 50),
                                                reverseDuration:
                                                    Duration(milliseconds: 200),
                                                child: model.controller.value
                                                        .isPlaying
                                                    ? SizedBox.shrink()
                                                    : Container(
                                                        color: Colors.black26,
                                                        child: Center(
                                                            child: Icon(
                                                          Icons.play_arrow,
                                                          size: 80,
                                                        )),
                                                      ),
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  model.playPause();
                                                },
                                              )
                                            ],
                                          ),
                                          VideoProgressIndicator(
                                            model.controller,
                                            allowScrubbing: true,
                                            
                                          
                                          ),
                                        ],
                                      ),
                                    );
                                  } else {
                                    return Center(
                                        child: CircularProgressIndicator());
                                  }
                                })
                            ),
                      ),
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: IconButton(
                            icon: Icon(Icons.save),
                            onPressed: () => model.saveVideo(videoModel.path)
                            ),
                      ),
                      Expanded(
                        child: IconButton(
                            icon: Icon(Icons.share),
                            onPressed: () {
                              model.share(videoModel.path, false);
                            }),
                      ),
                      Expanded(
                        child: IconButton(
                            icon: Icon(Icons.cloud_upload),
                            onPressed: () async {
                               MyDialogService().showLoadingDialog(context, key);
                              String link = await model.uploadFile(false,videoModel: videoModel);
                              await Future.delayed(Duration(seconds: 1));
                              Navigator.pop(context);
                               await Future.delayed(Duration(milliseconds: 300));
                               MyDialogService().showCopyDialog(
                                 context, key,
                                link, model.copyLinkTo);
                            }
                            ),
                      ),
                    ],
                  )
                ],
              ),
            ));
      },
      viewModelBuilder: () => HomeViewModel(),
      onModelReady: (model) async {
        await model.initializeVideoController(videoModel.path);
      },
    );
  }
}
