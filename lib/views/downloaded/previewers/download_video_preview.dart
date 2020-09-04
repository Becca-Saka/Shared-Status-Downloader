import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:status_downloader/router/locator.dart';
import 'package:status_downloader/services/dialogs_service.dart';
import 'package:status_downloader/views/home/home_viewmodel.dart';
import 'package:status_downloader/views/widgets/size_config.dart';
import 'package:video_player/video_player.dart';

import '../downloaded_viewmodel.dart';

class DownloadVideosPreview extends StatelessWidget {
  final VideoModel videoModel;
  DownloadVideosPreview(this.videoModel);

  @override
  Widget build(BuildContext context) {
     SnackbarService _snackbarService = locator<SnackbarService>();
    return ViewModelBuilder<DownloadViewModel>.reactive(
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
                                                          size: SizeConfig.xMargin(context, 15),
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
                        child: InkWell(
                          onTap: () =>    model.share(videoModel.path, false),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.share,
                                    size: SizeConfig.xMargin(context, 6)),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  'Share',
                                  style: TextStyle(
                                    fontSize: SizeConfig.textSize(context, 3.5),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: ()  async {
                           bool result = await model.deleteFile(videoModel.path);
                           if(result){
                             Navigator.of(context).pop('del');
                           }
                           },
                            // Navigator.of(context)..pop('deleted');},
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.delete,
                                    size: SizeConfig.xMargin(context, 6)),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  'Delete',
                                  style: TextStyle(
                                    fontSize: SizeConfig.textSize(context, 3.5),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                
                  ],
              ),
            ));
      },
      viewModelBuilder: () => DownloadViewModel(),
      onModelReady: (model) async {
        await model.initializeVideoController(videoModel.path);
        print( model.controller.value.aspectRatio);
      },
    );
  }
}
