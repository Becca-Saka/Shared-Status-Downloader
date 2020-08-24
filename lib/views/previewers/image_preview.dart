import 'dart:io';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'file:///C:/Users/TSP/FlutterProjects/status_downloader/lib/views/home/home_viewmodel.dart';

class ImagesPreview extends StatelessWidget {
  final String imagePath;
  ImagesPreview(this.imagePath);

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
              children: <Widget>[
                Expanded(
                  child: Container(
                      child:   Hero(
                        tag: imagePath,
                              child: Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical:20, horizontal: 5,
                              ),
                          child: Image.file(
                                  File(imagePath),
                                  fit: BoxFit.contain,
                          ),
                        ),
                      ),),
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                       child: IconButton(icon: Icon(Icons.save),
                       onPressed: (){
                         model.saveImage(imagePath);

                       }),
                    ),
                     Expanded(
                        child: IconButton(icon: Icon(Icons.share),
                       onPressed: (){
                         model.share(imagePath, true);
                       }),
                     ),
                      Expanded(
                        child: IconButton(icon: Icon(Icons.cloud_upload),
                       onPressed: (){
                         
                       }),
                     ),
                  
                  ],
                )
              ],
            ),
          ));
      },
      viewModelBuilder:()=> HomeViewModel(),
    
    );
  }
}
