import 'dart:io';
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import '../downloaded_viewmodel.dart';

class ImagesView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<DownloadViewModel>.reactive(
      builder: (context, model, child){
        
        return Scaffold(
          body: Container(
            padding: EdgeInsets.all(5),
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
                 return  InkWell(
                  onTap: () async{
                    final result = await model.navigateToImagePreview(imagePath);
                    if(result != null){
                      print(result);

                      await model.getAllStatus();
                      await model.getThumbNails();

                      model.snackbarService.showSnackbar(message: 'Deleted',
                        duration: Duration(milliseconds:1000)
                        );
                    }

                  },
                        child: Hero(
                          tag: imagePath,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                            ),
                    // height: 200,
                    child:
                     Image.file(
                      File(imagePath),
                      fit: BoxFit.cover,
                    ),),
                        ),
                 );
                }
               
                ):
                  Center(child: Text('No Image found', style: TextStyle(
                fontSize: 30,
              ),)),
          ),
        );
      },
      viewModelBuilder:()=> DownloadViewModel(),
      
      onModelReady: (model)async{
         model.getAllStatus();
      },
    );
  }
}
