import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:status_downloader/models/video_model.dart';
import 'package:status_downloader/router/locator.dart';
import 'package:status_downloader/services/dialogs_service.dart';
import 'package:status_downloader/views/home/home_viewmodel.dart';
import 'package:status_downloader/views/widgets/size_config.dart';
import 'package:video_player/video_player.dart';

class VideosPreview extends StatelessWidget {
  final VideoModel videoModel;
  VideosPreview(this.videoModel);

  @override
  Widget build(BuildContext context) {
     SnackbarService _snackbarService = locator<SnackbarService>();
    return ViewModelBuilder<HomeViewModel>.reactive(
      builder: (context, model, child) {
        return Scaffold(
            appBar: AppBar(
              elevation: 0.0,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
               leading: IconButton(
                icon: Icon(Icons.arrow_back, color:Colors.black, size: SizeConfig.xMargin(context, 5),),
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
                          onTap: () async {
                             MyDialogService().showLoadingDialog(context, key);
                              await model.saveFile(videoModel.path, false);
                              await Future.delayed(Duration(seconds: 1));
                              Navigator.pop(context);
                              _snackbarService.showSnackbar(message: 'Video Saved',
                              duration: Duration(milliseconds:1000));
                               },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                           children: [
                              Icon(Icons.save, size: SizeConfig.xMargin(context, 6)),
                              SizedBox(width: 5,),
                              Text('Save', style: TextStyle(
                                fontSize: SizeConfig.textSize(context, 3.5),
                              ),),
                             
                           ],
                         ),
                                ),
                       ),
                    ),
                  
                      Expanded(
                       child: InkWell(
                          onTap: () async {
                             model.share(videoModel.path, false);
                               },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                           children: [
                              Icon(Icons.share, size: SizeConfig.xMargin(context, 6)),
                              SizedBox(width: 5,),
                              Text('Share', style: TextStyle(
                                fontSize: SizeConfig.textSize(context, 3.5),
                              ),),
                             
                           ],
                         ),
                                ),
                       ),
                    ),
                  
                    Expanded(
                       child: InkWell(
                          onTap: ()  async {
                            await model.videoUploader(context, key, videoModel);
                         
                          },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                           children: [
                              Icon(Icons.cloud_upload, size: SizeConfig.xMargin(context, 6)),
                              SizedBox(width: 5,),
                              Text('Upload', style: TextStyle(
                                fontSize: SizeConfig.textSize(context, 3.5),
                              ),),
                             
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
      viewModelBuilder: () => HomeViewModel(),
      onModelReady: (model) async {
        await model.initializeVideoController(videoModel.path);
      },
    );
  }
}
