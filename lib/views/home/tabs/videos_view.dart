import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:status_downloader/views/previewers/video_preview.dart';

import '../home_viewmodel.dart';

class VideosView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return ViewModelBuilder<HomeViewModel>.reactive(
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
                  onTap: (){
                     Navigator.push(context, CupertinoPageRoute(builder: (context)=>
                  VideosPreview(videoPath)
                  ));
                  },
                        child: Hero(
                          tag: videoPath,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                    height: 200,
                    width:width,
                    child:
                     Stack(
                      fit: StackFit.expand,
                         children: [
                            Image.memory(videoThumb,
                             fit: BoxFit.cover,
                             ),
                             Center(child: Container(
                               decoration: BoxDecoration(
                                 color: Colors.grey.withOpacity(0.5),
                                 borderRadius: BorderRadius.circular(50)
                               ),
                               child: Icon(Icons.play_arrow, size: 80,)))
                      ]
                    ),
                    ),
                          ),
                        ),
                );}):
                  Center(child: Text('No video found', style: TextStyle(
                fontSize: 30,
              ),)),
          ),
        );
      },
      viewModelBuilder:()=> HomeViewModel(),
      
      onModelReady: (model)async{
        await model.getAllStatus();
        await model.getThumbNails();
      },
    );
  }
}
