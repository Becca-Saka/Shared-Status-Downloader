import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:status_downloader/views/home/previewers/video_preview.dart';
import 'package:status_downloader/views/widgets/size_config.dart';

import '../../widget.dart';
import '../downloaded_viewmodel.dart';

class VideosView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return ViewModelBuilder<DownloadViewModel>.reactive(
      builder: (context, model, child){
         return Scaffold(
          body: Container(
            child: model.statusVideoes.length !=0? 
          ListView.builder(
              itemCount: model.statusVideoes.length,
              itemBuilder: (context, index){
                final videoPath = model.statusVideoes[index].path;
                final videoThumb = model.statusVideoes[index].thumb;
                return InkWell(
                  onTap: ()=>model.navigateToVideoPreview(model.statusVideoes[index]),
                        child: Hero(
                          tag: videoPath,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                    height: 200,
                    width:width,
                    child: playOverlay(videoThumb,SizeConfig.xMargin(context, 12))
                     ),),),
                );}):
                 model.isBusy?Center(child: CircularProgressIndicator()) :Center(child: Text('No video found', style: TextStyle(
                fontSize: 30,
              ),)),
          ),
        );
      },
      viewModelBuilder:()=> DownloadViewModel(),
      
      onModelReady: (model)async{
        await model.getAllStatus();
        await model.getThumbNails();
      },
    );
  }
}
