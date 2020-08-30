import 'dart:io';
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:status_downloader/views/home/previewers/image_preview.dart';

import '../home_viewmodel.dart';

class ImagesView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HomeViewModel>.reactive(
      builder: (context, model, child){
        
        return Scaffold(
          body: Container(
            child: model.statusImageList.length !=0? 
            GridView.builder(
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
                fontSize: 30,
              ),)),
          ),
        );
      },
      viewModelBuilder:()=> HomeViewModel(),
      
      onModelReady: (model)async{
         model.getAllStatus();
      },
    );
  }
}
