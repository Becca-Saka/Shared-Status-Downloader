import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
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
          GridView.builder(
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
                  onTap: ()async{

                   final result = await  model.navigateToVideoPreview(model.statusVideoes[index]);
                    if(result != null){
                      print(result);
                       await model.getAllStatus();
                      await model.getThumbNails();

                      model.snackbarService.showSnackbar(message: 'Deleted',
                        duration: Duration(milliseconds:1000)
                        );
                       
                    }else{
                      print('This is $result');
                    }



                    // model.navigateToVideoPreview(model.statusVideoes[index]);
                    },
                        child: Hero(
                          tag: videoPath,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                    height: 200,
                    width:width,
                    child: playOverlay(videoThumb,SizeConfig.xMargin(context, 12))
                     ),),),
                );
              
              }
              )
                :
                 
                 model.isBusy?Center(child: CircularProgressIndicator()) :Center(child: Text('You have no downloaded video', style: TextStyle(
                fontSize: SizeConfig.textSize(context, 4.2),
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
