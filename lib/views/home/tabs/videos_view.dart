import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:status_downloader/services/dynamic_link_service.dart';
import 'package:status_downloader/views/home/previewers/video_preview.dart';
import 'package:status_downloader/views/widgets/size_config.dart';

import '../../widget.dart';
import '../home_viewmodel.dart';

class VideosView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return ViewModelBuilder<HomeViewModel>.reactive(
      builder: (context, model, child){
         return Scaffold(
          body: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                  Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Your status', style: TextStyle(
                    fontSize: SizeConfig.textSize(context, 4))),
                ),
                SizedBox(height: 10,),
                   model.statusPersonalList.length !=0? 
                  GridView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                      itemCount: model.statusVideoPersonalList.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 2,
                        mainAxisSpacing: 3,
                      ),
                      itemBuilder: (context, index){
                        String imagePath = model.statusVideoPersonalList[index];
                        return InkWell(
                          onTap: ()=>model.navigateToImagePreview(imagePath),
                                child: Hero(
                  tag: imagePath,
                  child: Container(
                            height: 200,
                            child: Image.file(
                              File(imagePath),
                              fit: BoxFit.cover,
                            ),),
                                ),
                        );}):
                        Center(child: Text('No video found', style: TextStyle(
                    fontSize: SizeConfig.textSize(context, 4)))),

                      SizedBox(height: 10,),

                     Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Friend\'s status', style: TextStyle(
                    fontSize: SizeConfig.textSize(context, 4))),
                ),
              

                Container(
                  child: model.statusVideoes.length !=0? 
         GridView.builder(
               physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                    itemCount: model.statusVideoes.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 2,
                      mainAxisSpacing: 3,
                    ),
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
                          height: SizeConfig.yMargin(context, 20),
                          width:width,
                          child: playOverlay(videoThumb,SizeConfig.xMargin(context, 12))
                           ),),),
                      );}):
                       model.isBusy?Center(child: CircularProgressIndicator()) :Center(child: Text('No video found', style: TextStyle(
                      fontSize: 30,
                    ),)),
                ),
              ],
            ),
          ),
        );
      },
      viewModelBuilder:()=> HomeViewModel(),
      
      onModelReady: (model)async{
        await model.getAllPersonalVideos();
        await model.getAllStatus();
       
        await model.getThumbNails();
      },
    );
  }
}
