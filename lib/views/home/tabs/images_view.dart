import 'dart:io';
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:status_downloader/views/home/previewers/image_preview.dart';
import 'package:status_downloader/views/widgets/size_config.dart';

import '../home_viewmodel.dart';

class ImagesView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
                    itemCount: model.statusPersonalList.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 2,
                      mainAxisSpacing: 3,
                    ),
                    itemBuilder: (context, index){
                      String imagePath = model.statusPersonalList[index];
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
                      Center(child: Text('No Image found', style: TextStyle(
                    fontSize: SizeConfig.textSize(context, 4)))),

                    SizedBox(height: 10,),

                   Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Friend\'s status', style: TextStyle(
                    fontSize: SizeConfig.textSize(context, 4))),
              ),
            

                  
                model.statusImageList.length !=0? 
                GridView.builder(
                      physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: model.statusImageList.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 2,
                      mainAxisSpacing: 3,
                    ),
                    itemBuilder: (context, index){
                      String imagePath = model.statusImageList[index];
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
                      Center(child: Text('No Image found', style: TextStyle(
                    fontSize: SizeConfig.textSize(context, 4)
                  ),)),
              ],
            ),
          ),
        );
      },
      viewModelBuilder:()=> HomeViewModel(),
      
      onModelReady: (model)async{
         model.getAllStatus();
         model.getAllPersonalImages();
      },
    );
  }
}
