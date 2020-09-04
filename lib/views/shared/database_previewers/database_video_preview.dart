import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:status_downloader/models/status_details.dart';
import 'package:status_downloader/router/locator.dart';
import 'package:status_downloader/services/dialogs_service.dart';
import 'package:status_downloader/views/shared/shared_viewmodel.dart';
import 'package:status_downloader/views/widgets/size_config.dart';
import 'package:video_player/video_player.dart';

class DatabaseVideosPreview extends StatelessWidget {
  final StatusDetails statusDetails;
  DatabaseVideosPreview(this.statusDetails);

  @override
  Widget build(BuildContext context) {
    SnackbarService _snackbarService = locator<SnackbarService>();
    return ViewModelBuilder<SharedViewModel>.reactive(
      builder: (context, model, child){
        
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
                      child:   Hero(
                        tag: statusDetails.url,
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
                          })),
                      ),),
                ),        
                Row(
                  children: <Widget>[
                     Expanded(
                       child: InkWell(
                          onTap: () async {
                             model.copyLink(statusDetails.shareLink);
                             
                             },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                           children: [
                              Icon(Icons.content_copy, size: SizeConfig.xMargin(context, 6)),
                              SizedBox(width: 5,),
                              Text('Copy sharing link', style: TextStyle(
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
                                MyDialogService().showLoadingDialog(context, key);
                              bool isConnected = await model.connectionService.getConnectionState();
                              if(isConnected){
                              await model.saveFile(statusDetails.url, false);
                              await Future.delayed(Duration(seconds: 1));
                              Navigator.pop(context);
                              _snackbarService.showSnackbar(message: 'Video Saved',
                              duration: Duration(milliseconds:1000));
                              }else{
                                await Future.delayed(Duration(seconds: 1));
                              Navigator.pop(context);
                                _snackbarService.showSnackbar(message: 'Something went wrong, please try again',
                              duration: Duration(milliseconds:1000));
                              }
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
                   
                    
                    
                  
                  ],
                )
               
              ],
            ),
          ));
      },
      viewModelBuilder:()=> SharedViewModel(),
      onModelReady: (model) async{
        await model.initializeNetworkVideoController(statusDetails.url);
        //  DynamicLinkService().retriveDynamicKnownLinks(statusDetails.shareLink);
      },
    
    );
  }
}
